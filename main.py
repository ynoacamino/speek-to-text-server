from flask import Flask, request, jsonify
from pocketsphinx import AudioFile, get_model_path
from pydub import AudioSegment


app = Flask(__name__)
app.config["MAX_CONTENT_LENGTH"] = 50 * 1000 * 1000


@app.get("/env")
def env():
    model_path = get_model_path()
    return jsonify({"model_path": model_path})

@app.post("/recognize")
def recognize():
    audio_file = request.files["audio"]
    original_path = f"/tmp/{audio_file.filename}"
    converted_path = f"/tmp/converted_{audio_file.filename}"
    audio_file.save(original_path)

    # Convertir a WAV compatible con Pocketsphinx
    try:
        audio = AudioSegment.from_file(original_path)
        audio = audio.set_frame_rate(16000).set_sample_width(2).set_channels(1)
        audio.export(converted_path, format="wav")
    except Exception as e:
        return jsonify({"error": f"Error al convertir el audio: {str(e)}"}), 400


    model_path = get_model_path()

    config = {
        "verbose": False,
        "audio_file": converted_path,
        "hmm": model_path + "/es",
        "lm": model_path + "/es.lm.gz",
        "dict": model_path + "/es-dic.dic",
    }

    try:
        audio = AudioFile(**config)
        print("test", audio)
        transcript = ""
        for phrase in audio:
            print("phrase", phrase)
            transcript += str(phrase) + " "
    except Exception as e:
        return jsonify({"error": f"Error al procesar el audio: {str(e)}"}), 500

    # Devuelve el texto transcrito
    return jsonify({"transcription": transcript})

if __name__ == "__main__":
    app.run()

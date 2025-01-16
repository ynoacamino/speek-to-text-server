from flask import Flask
from flask import request
import speech_recognition as sr
app = Flask(__name__)
app.config["MAX_CONTENT_LENGTH"] = 50 * 1000 * 1000
r = sr.Recognizer()

@app.post("/recognize")
def recognize():
    audio_data = request.files["audio"]
    with sr.AudioFile(audio_data) as source:
        audio = r.record(source)
    lang = request.form["lang"]
    try:
        result = r.recognize_sphinx(audio, language=lang)
    except sr.UnknownValueError:
        result = "Could not understand audio"
    except sr.RequestError as e:
        result = f"Error: {e}"
    return {"result": result}
{
  description = "A flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs: 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        extensions = inputs.vscode-extensions.extensions.${system};
      in {
        packages = {
          default = with pkgs; (vscode-with-extensions.override {
            vscode = vscodium;
            vscodeExtensions = 
            (with extensions.vscode-marketplace; [
              jetpack-io.devbox
              detachhead.basedpyright
            ]) ++ (with pkgs.vscode-extensions; [
              github.copilot
              jnoortheen.nix-ide
              arrterian.nix-env-selector
              ms-python.python
              ms-python.debugpy
              ms-python.black-formatter
              humao.rest-client
            ]);
          });
        };
      });
}

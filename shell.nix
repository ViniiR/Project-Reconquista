# WARNING!: In rust development ensure neovim is open IN nix-shell(nsh) and use cargo check before after git clone (have good codings :))
let
  pkgs = import <nixpkgs> {};
in
  pkgs.mkShell {
    # buildInputs = with pkgs; [ ];

    packages = with pkgs; [
      yt-dlp
      ffmpeg
      mutagen
    ];

    env = {
      NIX_ENFORCE_PURITY = 0;
    };

    nativeBuildInputs = with pkgs; [
      zsh
    ];
    shellHook = ''
      exec zsh;
    '';
  }

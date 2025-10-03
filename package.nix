{
  lib,
  stdenv,
  libinput,
  ruby,
  makeWrapper  # 提供wrapProgram工具
}:
stdenv.mkDerivation rec {
  pname = "linux_detect_tablet_mode";
  version = "unstable";

  src = ./.;

  # 依赖：libinput（提供命令）和makeWrapper（提供wrapProgram）
  buildInputs = [ libinput ruby ];
  nativeBuildInputs = [ makeWrapper ];  # 构建时需要makeWrapper

  installPhase = ''
    mkdir -p $out/bin
    cp "$src/watch_tablet" "$out/bin/"
    chmod +x "$out/bin/watch_tablet"

    wrapProgram "$out/bin/watch_tablet" \
      --prefix PATH : "${libinput}/bin" \
      --prefix PATH : "${ruby}/bin"
  '';

  meta = with lib; {
    description = "Tablet mode detection and setup scripts for linux";
    license = licenses.mit;
    mainProgram = "watch_tablet";
  };
}
    
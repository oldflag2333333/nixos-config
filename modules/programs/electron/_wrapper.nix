{
  lib,
  makeWrapper,
  symlinkJoin,
}:
{ pkg, execName }:
symlinkJoin {
  name = pkg.name;
  paths = [ pkg ];
  buildInputs = [ makeWrapper ];
  postBuild = lib.strings.concatStrings [
    "wrapProgram $out/bin/"
    execName
    " --add-flags \"--ozone-platform-hint=auto\""
    " --add-flags \"--enable-wayland-ime\""
    " --add-flags \"--enable-features=WaylandWindowDecorations\""
    " --add-flags \"--enable-webrtc-pipewire-capturer\""
  ];
}

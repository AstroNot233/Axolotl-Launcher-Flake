{
  stdenv,
  fetchurl,
  libarchive,
  ...
}:
stdenv.mkDerivation rec {
  pname = "axolotl";
  version = "1.8.6";
  src = (
    let
      base = "https://github.com/Mystic-Stars/Axolotl/releases/download/v${version}";
      debs = {
        x86_64-linux = {
          url = "${base}/Axolotl.Launcher_${version}_amd64.deb";
          hash = "sha256:52ced19ff8253972b832b794e58090039dd0601b4466b51baaac5a65b73e4e7e";
        };
        aarch64-linux = {
          url = "${base}/Axolotl.Launcher_${version}_arm64.deb";
          hash = "sha256:984d110ac409cf81d749667d5670e6aafef2570cb93fbb0532474c2998301c54";
        };
      };
      sys = stdenv.hostPlatform.system;
      tar = debs.${sys} or (throw "Unsupported system: ${sys}");
    in
      fetchurl tar
  );
  nativeBuildInputs = [ libarchive ];
  unpackPhase = ''
    runHook preUnpack
    mkdir -p "$out/bin"
    mkdir -p "$out/share"
    bsdtar -xf "$src" data.tar.gz
    bsdtar -xf data.tar.gz -C "$out/bin" --strip-components=2 "usr/bin/Axolotl Launcher"
    bsdtar -xf data.tar.gz -C "$out/share" --strip-components=2 "usr/share/icons"
    runHook postUnpack
  '';
  installPhase = ''
    runHook preInstall
    chmod +x "$out/bin/Axolotl Launcher"
    runHook postInstall
  '';
}

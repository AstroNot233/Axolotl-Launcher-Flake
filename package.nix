{
  stdenv,
  fetchurl,
  libarchive,
  ...
}:
stdenv.mkDerivation rec {
  pname = "axolotl";
  version = "1.8.10";
  src = (
    let
      base = "https://github.com/Mystic-Stars/Axolotl/releases/download/v${version}";
      debs = {
        x86_64-linux = {
          url = "${base}/Axolotl.Launcher_${version}_amd64.deb";
          hash = "sha256:607d8241cd6fcfb304acc7b77a388b6039e267278da129876e25792f615b89df";
        };
        aarch64-linux = {
          url = "${base}/Axolotl.Launcher_${version}_arm64.deb";
          hash = "sha256:14076014cf6d442d484396b87f0fad4d73cd1043395fbc43654df35def6bb579";
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

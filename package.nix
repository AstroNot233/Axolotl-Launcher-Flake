{
  stdenv,
  fetchurl,
  libarchive,
  ...
}:
stdenv.mkDerivation rec {
  pname = "axolotl";
  version = "1.8.4";
  src = (
    let
      base = "https://github.com/Mystic-Stars/Axolotl/releases/download/v${version}";
      debs = {
        x86_64-linux = {
          url = "${base}/Axolotl.Launcher_${version}_amd64.deb";
          hash = "sha256:15ec7bddbc15eabdad43e1bc3f259504829fd1f42e5950aaf368f5b3e35dcafe";
        };
        aarch64-linux = {
          url = "${base}/Axolotl.Launcher_${version}_arm64.deb";
          hash = "sha256:0fee7975d646aef6aa2c7bf69fe156762fdb3f8173ce8ff2c1821970c854975f";
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

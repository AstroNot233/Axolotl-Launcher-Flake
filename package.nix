{
  stdenv,
  fetchurl,
  libarchive,
  ...
}:
stdenv.mkDerivation rec {
  pname = "axolotl";
  version = "1.8.1";
  src = (
    let
      base = "https://github.com/Mystic-Stars/Axolotl/releases/download/v${version}";
      debs = {
        x86_64-linux = {
          url = "${base}/Axolotl.Launcher_${version}_amd64.deb";
          hash = "sha256:1a6612417e86ccb610e6f170067c31ad5e6f34d87f18784add545e7f497fdec3";
        };
        aarch64-linux = {
          url = "${base}/Axolotl.Launcher_${version}_arm64.deb";
          hash = "sha256:e285aa83df6175496bfce1e50f6546233407df3a6f0e861ade765879dc05020f";
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

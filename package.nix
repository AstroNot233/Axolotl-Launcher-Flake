{
  stdenv,
  fetchurl,
  libarchive,
  ...
}:
stdenv.mkDerivation rec {
  pname = "axolotl";
  version = "1.8.3";
  src = (
    let
      base = "https://github.com/Mystic-Stars/Axolotl/releases/download/v${version}";
      debs = {
        x86_64-linux = {
          url = "${base}/Axolotl.Launcher_${version}_amd64.deb";
          hash = "sha256:b71d385a08c038510426a90ea4a74e21f8e4bc100eb8abf26705013ee07ced8d";
        };
        aarch64-linux = {
          url = "${base}/Axolotl.Launcher_${version}_arm64.deb";
          hash = "sha256:0fad5e74970430573690b539615d3d10391be9c9e7eeca6272d9b7d1adbd7f14";
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

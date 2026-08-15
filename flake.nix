{
  description = ''Axolotl Launcher is a free, open-source, ad-free, cross-platform Minecraft Java Edition launcher for searching, installing, and updating mods, modpacks, resource packs, and shaders from Modrinth and CurseForge, with Axolotl Labs built in.'';
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };
  outputs = { self, nixpkgs, ... }: (
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: builtins.listToAttrs (map (system: { name = system; value = f system; }) systems);
    in
      {
        packages = forAllSystems (system:
          { default = nixpkgs.legacyPackages.${system}.callPackage ./enwrap.nix {}; }
        );
        homeModules.axolotl = import ./home-module.nix { inherit self; };
      }
  );
}

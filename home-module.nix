{ self }: { config, lib, pkgs, ... }:
(
  let
    inherit (lib) mkEnableOption mkOption mkIf;
    axolotl-bin = pkgs.callPackage ./package.nix {};
  in
    {
      options.programs.axolotl = {
        enable = mkEnableOption "Axolotl Launcher";
        package = mkOption {
          type = with lib.types; package;
          default = self.packages.${pkgs.stdenv.hostPlatform.system}.default
            .override { inherit (config.programs.axolotl) launchEnv; };
          description = "A package of Axolotl Launcher.";
          example = "mypkgs.axolotl";
        };
        launchEnv = mkOption {
          type = with lib.types; attrsOf anything;
          default = {};
          description = ''
            Environment variables or flags to be passed to Axolotl.
          '';
          example = {
            WEBKIT_DISABLE_DMABUF_RENDERER = 1;
          };
        };
        jres = mkOption {
          type = with lib.types; listOf package;
          default = [];
          description = ''
            (WIP)
            A list of packages of JREs/JDKs to be written into the Java list.
          '';
          example = [ pkgs.jre8 ];
        };
      };
  
      config = with config.programs; mkIf axolotl.enable {
        home.packages = [ axolotl.package ];
        xdg.desktopEntries.axolotl = {
          categories = [ "Game" ];
          exec = "axolotl";
          # startupWMClass = "Axolotl Launcher";
          icon = "${axolotl-bin}/share/icons/hicolor/128x128/apps/Axolotl Launcher.png";
          name = "Axolotl Launcher";
          terminal = false;
          type = "Application";
          mimeType = [
            "application/x-modrinth-modpack+zip"
            "x-scheme-handler/axolotl"
          ];
        };
        # xdg.configFile."axolotl/java.json" = mkIf (axolotl.jres != []) {
        #   text = builtins.toJSON {
        #     all = builtins.map (jre: rec {
        #       path = "${jre}/bin/java";
        #       version = lib.getVersion jre;
        #       majorVersion = with lib; with versions; toInt ((if (toInt (major version) == 1) then minor else major) version);
        #     }) axolotl.jres;
        #   };
        # };
      };
    }
)

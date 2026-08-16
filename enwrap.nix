{ pkgs, lib, launchEnv ? {}, ... }:
(
  let
    axolotl-bin = pkgs.callPackage ./package.nix {};
  in
    pkgs.buildFHSEnv {
      name = "axolotl";
      targetPkgs = pkgs: builtins.concatLists [
        [ axolotl-bin ]
        (with pkgs; [
          # For Axolotl
          libnotify
          gtk3
          webkitgtk_4_1
          gdk-pixbuf
          cairo
          glib
          dbus
          libsoup_3
          # For Minecraf
          stdenv.cc.cc.lib
          ## native versions
          glfw3-minecraft
          openal
          ## openal
          alsa-lib
          libjack2
          libpulseaudio
          pipewire
          ## glfw
          libGL
          libx11
          libxcursor
          libxext
          libxrandr
          libxxf86vm
          wayland
          udev          # oshi
          vulkan-loader # VulkanMod's lwjglt
        ])
      ];
      profile = ''
        set -o allexport
        ${lib.toShellVars launchEnv}
        GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules"
        SSL_SERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
        set +o allexport
      '';
      runScript = ''
        "${axolotl-bin}/bin/Axolotl Launcher"
      '';
    }
)

<div align="center">
  <img src="https://github.com/Mystic-Stars/Axolotl/raw/main/apps/app/icons/128x128.png" width="128" height="128" alt="Axolotl Launcher Logo" />
  <h1>Axolotl Launcher</h1>
  <p><strong>次世代 Minecraft 桌面客户端，全能、美观、全平台覆盖。</strong></p>
</div>

---

**Axolotl Launcher（美西螈启动器）** 是一款免费、开源、跨平台的 Minecraft Java 版第三方启动器，支持在一个客户端中搜索、安装和更新来自 Modrinth 与 CurseForge 的模组、整合包、资源包和光影，并提供实例管理、多种账户认证、个性化外观与 Axolotl 实验室工具。

更多资讯详见Axolotl Launcher的[官方页面](https://axlmc.org)或者[GitHub主页](https://github.com/Mystic-Stars/Axolotl)。

本项目（主要是为NixOS用户）提供了一个使用Axolotl Launcher的Flake。

---

## 如何使用

您可以在以下三种方式中，选择您喜欢的一种使用。

### 使用 nix run 体验

```sh
nix run github:AstroNot233/Axolotl-Launcher-Flake
```

### 仅安装到用户 profile

```
nix profile add github:AstroNot233/Axolotl-Launcher-Flake
```
在安装到 profile 后，若您需要解除安装，请使用如下命令。
```
nix profile remove Axolotl-Launcher-Flake
```
> 若您通过此办法安装，您可以通过命令`axolotl`启动。

### 使用 home-manager 持久化配置

```nix
# flake.nix
inputs = {
  # ...
  axolotl = {
    url = "github:AstroNot233/Axolotl-Launcher-Flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  # ...
};
```
```nix
# home.nix
imports = [
  inputs.axolotl.homeModules.axolotl
];
programs.axolotl = {
  enable = true;
  jres = [
    pkgs.jdk8
    pkgs.jdk11
    pkgs.jdk17
    pkgs.jdk21
    pkgs.jdk25
  ];
};
```
> 若您使用此办法持久化配置，您可以通过自动创建的桌面文件启动，也可以通过`axolotl`在命令行中启动。

## 已知问题

由于Axolotl Launcher基于Modrinth App，故目前使用数据库存储JRE路径，这使得通过Nix维护Axolotl Launcher的JRE列表目前是不可能的。
因此`programs.axolotl.jres`目前仅为占位符，暂时没有任何作用。

# Guess The Anime

## About

I used to enjoy making Roblox games, but that was before the vibecode era. **Guess The Anime** was one I made around 2019–2022, when I was bored during quarantine. Over time, my love for music outgrew my interest in game development, and I eventually stopped working on it.

This repository preserves the project and makes it possible to build and try it in Roblox Studio.

[Play the original game on Roblox](https://www.roblox.com/games/8410558107/Guess-The-Anime).

The project uses [Rojo](https://rojo.space/) to map Luau scripts and Roblox models into the game hierarchy.

## Build and open in Roblox Studio

### Requirements

- [Roblox Studio](https://www.roblox.com/create)
- [Git](https://git-scm.com/)
- [Rokit](https://github.com/rojo-rbx/rokit#installation)

Clone the repository, open a terminal in the project folder, and run:

```sh
rokit install
rojo build default.project.json -o build.rbxl
```

Open `build.rbxl` in Roblox Studio. It is a generated local build and is not committed to the repository.

If `rojo` is not recognized after installation, restart the terminal or add Rokit's executable directory to `PATH` (`%USERPROFILE%\.rokit\bin` on Windows, `~/.rokit/bin` on macOS and Linux).

### Live sync (optional)

Install the Rojo Studio plugin, then run:

```sh
rojo serve default.project.json
```

Connect the plugin to the running server from Roblox Studio. Use a disposable local place while developing; do not live-sync to the production experience.

In Studio playtests, player profiles use an in-memory mock. Progress is discarded when the test server closes, and persistent leaderboards and badge calls are skipped.

## Releases

Pushing a version tag such as `v1.0.0` runs the GitHub Actions release workflow. It builds a `.rbxl` file and publishes a GitHub release with the build attached.

## Project layout

- `default.project.json` maps files and models into Roblox services and instances. Keep this mapping aligned with the hierarchy in Studio.
- `src/` contains Luau source files arranged by Roblox service and instance. `.server.luau` and `.client.luau` files map to server Scripts and LocalScripts.
- `assets/` contains binary Roblox models (`.rbxm`) used by the project. These files hold assets whose hierarchy or properties are kept together.
- `rokit.toml` pins the Rojo and Lune versions used by the project.

Keep mapped paths and names intact when moving scripts or models: scripts may rely on their Roblox parent hierarchy and module locations.

## License

Original code and Roblox model files in `assets/` are licensed under the MIT License; see [`LICENSE`](LICENSE). The copyright notice uses my GitHub handle, `cavyion`.

The MIT license does not cover material the project author does not own. In particular, it does not grant rights to:

- Third-party packages in `src/ReplicatedStorage/Packages/` (including packages attributed to `@ffrostfall`, `@GFink`, `@loleris`, `@NanoBlox`, `@Quenty`, and ReactLua).
- Any third-party copyrighted images, anime names and characters, music, or other media referenced by the game through Roblox asset IDs. These belong to their respective rights holders; I do not claim ownership of them, and they are not covered by this repository's MIT license.

Check the original creator's terms before reusing or redistributing those materials. The MIT license allows use, modification, and redistribution of covered code, provided the copyright and license notice are retained; it does not restrict commercial use.

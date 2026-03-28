# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Wofl** is a cross-platform C++ game engine with platform-specific implementations for Windows, iOS, and Android. The primary game built on it is **Neuro**, a cyberpunk-themed game with Lua scripting. The repo contains the engine (`Engine/`) and several game projects (`Neuro/`, plus smaller samples like BurgerThyme, FishHotel, etc.).

## Building

Primary build system is **Visual Studio** via `Wofl.sln` (Windows). There are two projects:
- `Wofl` — the engine library
- `Neuro` — the game (depends on Wofl)

Configurations: `Debug|x64`, `Release|x64`, `ARM64` variants, `x86`.

A partial **CMake** alternative exists at `Neuro/CMakeLists.txt` (does not cover all sources).

To build from the command line with Visual Studio:
```
msbuild Wofl.sln /p:Configuration=Debug /p:Platform=x64
```

There is no automated test suite.

## Architecture

### Engine (`Engine/`)

The engine uses a **platform abstraction layer** with abstract base classes and platform-specific implementations:

| Abstract | Windows impl |
|---|---|
| `WoflPlatform` | `WindowsPlatform` |
| `WoflFile` | `WindowsFile` |
| `WoflInput` | `WindowsInput` |
| `WoflRenderer` | `WindowsRenderer` |

Platform services are accessed globally via the **`Utils` singleton** (`Engine/Misc/WoflUtils.h`), e.g. `Utils::File()`, `Utils::Input()`, `Utils::Platform()`.

**File domains** (`FileDomain` enum in `WoflFile.h`) control path resolution:
- `Save` — APPDATA per-game save directory
- `Game` — game-specific resources
- `System` — shared system resources
- `Engine` — engine resources
- `Absolute` — raw absolute path

**Serialization** uses `IJsonObj` interface (via JsonCPP). Games and entities implement `ToJson`/`FromJson` for save/load.

**Rendering** is OpenGL-based (GLEW + GLFW on Windows). Sprites use an atlas system (`WoflAtlases`). Shaders are `.vsh`/`.fsh` GLSL files copied to the output directory at build time.

**Entry point** is `Engine/Windows/Launch/Launch.cpp`. It calls the externally-defined `GlobalGameInitialization()` which each game project implements to register itself.

### Neuro Game (`Neuro/`)

- `NeuroGame` — main game class, inherits `WoflGame`
- `NeuroLua` — template-heavy Lua 5.4 bindings for calling Lua from C++ with typed arguments
- `NeuroState` — game state management with change notifications
- UI: `Gridbox`, `Ninebox`, `Textbox` — box-based layout components

**Resources** live in `Neuro/Resources/` organized by subsystem:
- `Neuromancer/` — cyberpunk content: rooms, sites, conversations (JSON + Lua)
- `System/` — core UI: dialogs, inventory, messaging
- `Bettws/` — early/placeholder content

Game logic and room/scene definitions are written in **Lua scripts**; C++ handles engine mechanics.

### Key Patterns

- `GlobalGameInitialization()` — the seam between engine and game; each game project defines this
- Template metaprogramming is used heavily in `NeuroLua.h` for Lua type binding
- JSON is used for both game config data and save state
- Multiple games can coexist; the active game is selected at startup

## Dependencies

All external libraries are vendored under `Engine/Windows/includes/` and `Engine/Windows/libs/`:
- **GLFW 3** — windowing and input
- **GLEW 2.2.0** — OpenGL extensions
- **Lua 5.4** — scripting
- **JsonCPP** — JSON parsing
- **stb_image** — PNG loading (header-only)
- **GLM** — math library

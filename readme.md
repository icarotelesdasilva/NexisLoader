# NexisLoader

<p align="center">
  <strong>Handcrafted x86 Kernel Bootloader</strong>
</p>

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#project-status">Status</a> •
  <a href="#features">Features</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#boot-menu">Boot Menu</a> •
  <a href="#memory-map">Memory Map</a> •
  <a href="#kernel-loading">Kernel Loading</a> •
  <a href="#roadmap">Roadmap</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Architecture-x86-informational?style=flat-square" alt="Architecture">
  <img src="https://img.shields.io/badge/Language-NASM-blue?style=flat-square" alt="Language">
  <img src="https://img.shields.io/badge/Build-Make-000000?style=flat-square" alt="Build">
  <img src="https://img.shields.io/badge/Mode-Real%20%2B%20Protected-orange?style=flat-square" alt="Execution Mode">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/Status-Early%20Development-orange?style=flat-square" alt="Status">
</p>

## Overview

NexisLoader is an independent, handcrafted x86 bootloader written from scratch.

Its purpose is to initialize the machine, provide a minimal boot environment, prepare the processor, detect available memory, load a kernel, and transfer execution to it.

NexisLoader is developed independently from NexisK while remaining part of the broader Nexis ecosystem.

> From firmware to kernel, one stage at a time.

## Project Status

**Early Development**

NexisLoader is currently in its initial development stage.

The current implementation starts through the BIOS boot process, executes in 16-bit Real Mode, provides a basic interactive menu, handles keyboard input, detects the BIOS memory map through E820, initializes a Global Descriptor Table, and transitions into 32-bit Protected Mode.

Kernel loading and a stable bootloader/kernel interface are still under development.

## Features

### Implemented

* [x] x86 boot entry
* [x] BIOS boot support
* [x] 16-bit Real Mode
* [x] Basic initialization
* [x] Text output
* [x] Keyboard input
* [x] Interactive boot menu
* [x] ENTER key handling
* [x] Global Descriptor Table (GDT)
* [x] Real Mode to Protected Mode transition
* [x] 32-bit Protected Mode
* [x] Basic 32-bit execution environment
* [x] BIOS E820 memory map detection

### In Development

* [ ] Robust multi-stage kernel loader
* [ ] Disk access improvements
* [ ] Kernel discovery
* [ ] Kernel loading
* [ ] Kernel validation
* [ ] Kernel entry-point handling
* [ ] Boot information structure
* [ ] Memory map handoff
* [ ] Filesystem support
* [ ] ELF kernel support
* [ ] 64-bit Long Mode
* [ ] x86_64 kernel loading
* [ ] Stable bootloader/kernel interface

## Architecture

The current boot flow is:

```text
                    BIOS
                     |
                     v
                Stage 1
                     |
                     v
                Stage 2
                     |
          +----------+----------+
          |          |          |
          v          v          v
      Initialize   Keyboard    Menu
          |          |          |
          +----------+----------+
                     |
                     v
                  E820
                     |
                     v
              Memory Map
                     |
                     v
                   GDT
                     |
                     v
          Enable Protected Mode
                     |
                     v
                  Far Jump
                     |
                     v
          32-bit Protected Mode
                     |
                     v
             Kernel Loader
                     |
                     v
                  Kernel
```

The architecture will evolve as additional loading, validation and boot protocol components are implemented.

## Boot Menu

NexisLoader currently includes a minimal text-based boot menu.

The menu serves as both a basic user interface and a development mechanism.

Future versions may use the menu for:

* Kernel selection
* Boot parameters
* Debug modes
* Recovery modes
* Multiple kernel images
* Configuration options

The current implementation waits for keyboard input and recognizes the `ENTER` key to continue the boot process.

## 16-bit Real Mode

NexisLoader initially executes in x86 Real Mode.

The initial stage is responsible for establishing the environment required for subsequent execution.

Current responsibilities include:

* Initial processor setup
* Segment initialization
* Text output
* Keyboard input
* Boot menu
* Memory map detection
* GDT preparation

The 16-bit stage is intentionally kept small.

## Memory Map

NexisLoader uses the BIOS `INT 15h, E820h` interface to detect the system's physical memory map.

The loader requests the available memory regions from the BIOS and stores the returned E820 entries in memory for use during later boot stages.

Conceptually:

```text
BIOS
 |
 | INT 15h / E820h
 v
+----------------------+
| Memory Map Entry 0   |
+----------------------+
| Memory Map Entry 1   |
+----------------------+
| Memory Map Entry 2   |
+----------------------+
| ...                  |
+----------------------+
```

The current implementation establishes the memory-discovery foundation required for a future boot information structure.

The memory map is not yet exposed through a stable bootloader/kernel ABI.

## 16-bit to 32-bit Transition

One of the first major milestones of NexisLoader is the transition from 16-bit Real Mode to 32-bit Protected Mode.

The transition can be summarized as:

```text
16-bit Real Mode
       |
       v
Prepare GDT
       |
       v
Load GDT
       |
       v
Enable Protected Mode
       |
       v
Far Jump
       |
       v
32-bit Protected Mode
```

The 32-bit environment will serve as the foundation for the kernel-loading implementation.

## Global Descriptor Table

The initial Protected Mode environment uses a minimal Global Descriptor Table.

```text
GDT
|
+-- Null Descriptor
|
+-- 32-bit Code Segment
|
+-- 32-bit Data Segment
```

The GDT implementation may be extended as the architecture develops.

## Kernel Loading

The primary responsibility of NexisLoader is to eventually load and start a kernel.

The intended process is:

```text
              NexisLoader
                   |
                   v
             Locate Kernel
                   |
                   v
              Read Kernel
                   |
                   v
           Validate Kernel
                   |
                   v
          Prepare Boot Info
                   |
                   v
          Transfer Execution
                   |
                   v
                 Kernel
```

The complete kernel-loading subsystem is not yet finished.

The final kernel format, memory layout and boot protocol will be defined during development.

## NexisLoader and NexisK

NexisLoader and NexisK are separate repositories and separate projects.

Their intended relationship is:

```text
Nexis Ecosystem
|
+-- NexisLoader
|   |
|   +-- Bootloader
|   +-- Hardware Initialization
|   +-- Memory Discovery
|   +-- Kernel Loading
|   `-- Boot Interface
|
`-- NexisK
    |
    +-- Kernel
    +-- Memory Management
    +-- Process Management
    `-- Operating System Components
```

A future Nexis system may use NexisLoader to start NexisK.

However, NexisLoader is not dependent on NexisK.

The bootloader is intended to remain an independent project capable of loading compatible test or experimental kernels.

## Development Philosophy

NexisLoader is designed around low-level development and direct understanding of the boot process.

The project prioritizes:

* Minimal abstractions
* Explicit hardware interaction
* Small and understandable components
* Manual processor initialization
* Clear separation between bootloader and kernel
* Incremental development
* Reproducible builds
* Documented interfaces

The project is not intended to hide the boot process.

It is intended to expose it.

## Development Environment

The exact toolchain may evolve, but development is primarily focused on:

* x86 Assembly
* BIOS
* Real Mode
* Protected Mode
* x86 hardware interfaces
* Global Descriptor Table (GDT)
* BIOS disk services
* Memory map discovery
* Kernel loading
* x86_64 Long Mode

A typical development environment may include an assembler, linker, build system, emulator and debugger.

## Building

NexisLoader uses Make to manage the build process.

### Clean

Remove generated build artifacts:

```bash
make clean
```

### Build

Compile the project:

```bash
make all
```

### Running

Run NexisLoader using the configured emulator:

```bash
make run
```

## Debugging

Low-level debugging is an important part of the project.

Future development may include dedicated debugging configurations for:

* Boot-sector execution
* Stage 2 execution
* GDT initialization
* E820 memory detection
* Protected Mode entry
* Disk operations
* Kernel loading
* Memory layout
* Kernel handoff

Debug builds should make it possible to identify failures during each individual boot stage.

## Roadmap

### Phase 1: Boot Foundation

* [x] Boot sector
* [x] Real Mode
* [x] Basic initialization
* [x] Text output
* [x] Keyboard input
* [x] Boot menu
* [x] ENTER handling
* [x] GDT
* [x] Protected Mode
* [x] 32-bit execution
* [x] E820 memory map detection

### Phase 2: Kernel Loader

* [x] Initial Stage 2
* [ ] Robust disk access
* [ ] Kernel discovery
* [ ] Kernel loading
* [ ] Kernel validation
* [ ] Kernel entry point
* [ ] Kernel handoff

### Phase 3: Boot Protocol

* [ ] Boot information structure
* [ ] Memory map handoff
* [ ] Hardware information
* [ ] Kernel parameters
* [ ] Defined boot ABI
* [ ] Stable loader/kernel interface

### Phase 4: 64-bit

```text
16-bit
  |
  v
32-bit
  |
  v
64-bit
  |
  v
x86_64 Kernel
```

Planned work:

* [ ] PAE
* [ ] Page tables
* [ ] Long Mode
* [ ] 64-bit execution
* [ ] x86_64 kernel loading

### Phase 5: Nexis Integration

* [ ] Define NexisLoader/NexisK interface
* [ ] Define kernel format
* [ ] Define boot information ABI
* [ ] Test NexisK loading
* [ ] Optional NexisK integration

## Source Code Identification

Every source file may contain a project identification header:

```asm
;
; NexisLoader
; Handcrafted x86 Kernel Bootloader
;
; Independent project within the Nexis ecosystem
;
; Copyright (c) 2026 icarotelesdasilva
; Licensed under the MIT License
;
```

The project name is intentionally kept visible throughout the source code and boot environment.

The MIT License requires applicable copyright and license notices to remain with redistributed copies of the software.

## License

NexisLoader is released under the MIT License.

Copyright (c) 2026 icarotelesdasilva

See [LICENSE](LICENSE) for the complete license text.

The MIT License permits use, modification, distribution, sublicensing and commercial use, subject to its terms.

## Disclaimer

NexisLoader is experimental software under active development.

The following may change without notice:

* Boot protocol
* Memory layout
* Kernel format
* Source structure
* Build system
* Loader/kernel interface
* CPU initialization sequence
* Supported hardware
* Project architecture

NexisLoader should not currently be considered production-ready boot software.

## Project Information

| Property         | Value                 |
| ---------------- | --------------------- |
| Project          | NexisLoader           |
| Type             | Kernel Bootloader     |
| Architecture     | x86                   |
| Initial Mode     | 16-bit Real Mode      |
| Current Target   | 32-bit Protected Mode |
| Future Target    | x86_64 Long Mode      |
| Status           | Early Development     |
| License          | MIT                   |
| Kernel           | Independent           |
| NexisK           | Separate Project      |
| Memory Detection | BIOS E820             |

## Contributing

Contributions, experiments, technical discussions and improvements may be accepted as the project evolves.

Before submitting changes, ensure that:

1. The code remains consistent with the project's low-level architecture.
2. Changes are documented when they affect the boot protocol.
3. Build instructions remain functional.
4. Existing functionality is not unintentionally broken.
5. Hardware-specific assumptions are documented.

## License and Attribution

NexisLoader is free and open-source software released under the MIT License.

The project name, source-code attribution and copyright notices are intentionally maintained as part of the project's identity.

For the legally binding terms, refer to the `LICENSE` file.

## Final Note

NexisLoader is a bootloader built to explore what happens between firmware and a kernel.

It is intentionally developed close to the hardware, from BIOS execution and Real Mode to Protected Mode, memory discovery and eventually kernel loading.

The project is still evolving, and its architecture will continue to change as new bootloader subsystems are implemented.

<p align="center">
  <strong>NexisLoader — Handcrafted from scratch. Built for kernels.</strong>
</p>

<p align="center">
  Firmware → NexisLoader → Kernel → Operating System
</p>

<p align="center">
  <strong>From firmware to kernel, one stage at a time.</strong>
</p>

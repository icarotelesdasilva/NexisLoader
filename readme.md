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

The current implementation starts through the BIOS boot process, executes in 16-bit Real Mode, provides a basic interactive menu, handles keyboard input, detects the BIOS memory map through E820, stores the returned memory regions, initializes a Global Descriptor Table, and transitions into 32-bit Protected Mode.

The detected E820 memory map is stored in physical memory and made accessible to the kernel environment. The current implementation also transfers the number of detected entries through the Protected Mode boot path.

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
* [x] E820 memory region collection
* [x] E820 map storage
* [x] E820 entry counting
* [x] Memory map made available to the kernel environment

### In Development

* [ ] Robust multi-stage kernel loader
* [ ] Disk access improvements
* [ ] Kernel discovery
* [ ] Kernel loading
* [ ] Kernel validation
* [ ] Kernel entry-point handling
* [ ] Boot information structure
* [ ] Stable memory map structure
* [ ] Stable memory map pointer ABI
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
          Store Map in Memory
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
* E820 memory map detection
* E820 entry collection
* E820 map storage
* GDT preparation

The 16-bit stage is intentionally kept small.

## Memory Map

NexisLoader uses the BIOS `INT 15h, E820h` interface to detect the system's physical memory map.

The loader requests the available memory regions from the BIOS and stores the returned E820 entries in memory.

The collected entries are then made accessible to the kernel environment.

### E820 Collection

The E820 request is performed through the BIOS interrupt interface:

```text
INT 15h
EAX = 0xE820
EDX = "SMAP"
ECX = 24
```

The BIOS returns one memory region per successful call.

The bootloader continues requesting entries until the BIOS indicates that there are no more regions.

For every valid entry, NexisLoader stores the returned structure and advances to the next destination address.

### Current Memory Layout

The current implementation uses a predefined physical memory area for the E820 data.

The memory map begins at:

```text
0x00050000
```

The number of collected entries is stored at:

```text
0x00057000
```

The current layout is therefore:

```text
Physical Address

0x00050000
    |
    +-- E820 Entry 0   (24 bytes)
    |
    +-- E820 Entry 1   (24 bytes)
    |
    +-- E820 Entry 2   (24 bytes)
    |
    +-- ...
    |
    +-- E820 Entry N
    |
    v
0x00057000
    |
    +-- E820 entry count
```

Each E820 entry occupies 24 bytes.

Therefore the address of an entry can be calculated as:

```text
entry_address = 0x00050000 + (index * 24)
```

For example:

```text
Entry 0 = 0x00050000
Entry 1 = 0x00050018
Entry 2 = 0x00050030
Entry 3 = 0x00050048
```

### E820 Entry Format

NexisLoader requests the extended 24-byte E820 structure.

The layout is:

```text
Offset  Size    Field
------  ------  ----------------
0x00    8       Base Address
0x08    8       Region Length
0x10    4       Memory Type
0x14    4       Extended Attributes
```

Conceptually:

```text
+------------------------------+  +0x00
| Base Address (64-bit)        |
+------------------------------+  +0x08
| Region Length (64-bit)       |
+------------------------------+  +0x10
| Memory Type (32-bit)         |
+------------------------------+  +0x14
| Extended Attributes (32-bit) |
+------------------------------+  +0x18
```

The next entry begins immediately after the previous 24-byte entry.

### Memory Types

The `Type` field describes the purpose of the corresponding physical memory region.

The most important value is:

```text
0x00000001 = Usable RAM
```

Other values describe memory that should not be treated as ordinary available RAM, such as reserved or firmware-owned regions.

The kernel must therefore **not assume that all physical memory is usable**.

It must inspect the E820 entries and determine which regions can safely be used.

### Example E820 Map

A BIOS may return entries such as:

```text
Base: 0x0000000000000000
Size: 0x000000000009FC00
Type: 0x00000001

Base: 0x000000000009FC00
Size: 0x0000000000000400
Type: 0x00000002

Base: 0x0000000000100000
Size: 0x0000000007EE0000
Type: 0x00000001
```

The kernel can interpret these as:

```text
0x00000000 - 0x0009FBFF
    Usable RAM

0x0009FC00 - 0x0009FFFF
    Reserved

0x00100000 - ...
    Usable RAM
```

The exact memory layout is machine-dependent.

The kernel must use the E820 map instead of assuming a fixed amount of available RAM.

## Receiving the Memory Map

The bootloader and kernel communicate through memory prepared by NexisLoader.

The current E820 map is stored at:

```text
0x00050000
```

The number of entries is stored at:

```text
0x00057000
```

The kernel therefore needs two pieces of information:

```text
Memory map:
    0x00050000

Entry count:
    value stored at 0x00057000
```

Conceptually, the kernel can interpret the map as an array of E820 entries:

```text
E820Entry *memory_map = (E820Entry *)0x00050000;
```

and the number of entries as the value stored by the bootloader at the count location.

The important distinction is that the bootloader does not calculate which memory is usable.

It reports the physical memory layout returned by the BIOS.

The kernel is responsible for interpreting that information.

## Current Kernel Handoff

The current Protected Mode transition retrieves the number of E820 entries and places that value on the stack before entering the C boot entry point.

The current flow is:

```text
             BIOS
               |
               v
          INT 15h E820
               |
               v
      Collect E820 entries
               |
               v
       Store entries at
          0x00050000
               |
               v
       Store entry count at
          0x00057000
               |
               v
       Enter Protected Mode
               |
               v
       Push entry count
               |
               v
         C entry point
```

This means that the current implementation explicitly transfers the **number of E820 entries** through the boot path.

The actual E820 array remains at its predefined physical address.

Therefore, the current implementation should be considered a **working development interface**, not a finalized boot ABI.

## How the Kernel Should Consume the Map

The kernel-side memory initialization should conceptually perform the following operations:

```text
1. Obtain the number of E820 entries.

2. Treat 0x00050000 as the beginning
   of the E820 entry array.

3. Iterate through each 24-byte entry.

4. Read:
      Base Address
      Region Length
      Memory Type
      Extended Attributes

5. Identify regions with:
      Type = 0x00000001

6. Exclude reserved and unavailable
   regions from the physical memory allocator.

7. Preserve the memory occupied by
   bootloader data until it is no longer needed.
```

Conceptually:

```text
E820 map
   |
   v
+-----------------------+
| Entry 0               |
| Base                  |
| Length                |
| Type                  |
| Attributes            |
+-----------------------+
| Entry 1               |
| Base                  |
| Length                |
| Type                  |
| Attributes            |
+-----------------------+
| Entry N               |
+-----------------------+
          |
          v
      Kernel PMM
          |
          v
  Physical memory regions
```

The kernel's physical memory manager can then construct its own representation of usable physical memory from this information.

## Bootloader Memory Ownership

The E820 map occupies physical memory reserved by the bootloader during the boot process.

The kernel must not immediately treat this area as free RAM.

The kernel should first consume or copy the E820 information it needs.

Only after the information has been preserved and the bootloader's memory requirements are accounted for should the physical memory manager consider reclaiming those regions.

This is important because a physical memory map describes the machine's memory, but it does not automatically describe memory currently occupied by the bootloader itself.

The kernel must account for both:

```text
BIOS-reported memory regions
+
Bootloader/kernel reserved memory
```

when constructing the physical memory allocator.

## Recommended Future Boot Interface

The current fixed-address mechanism works for development, but it is not an ideal permanent interface.

A stable boot protocol should explicitly provide the kernel with a boot information structure.

For example:

```text
BootInfo
|
+-- memory_map
|      |
|      +-- pointer to E820 entries
|
+-- memory_map_count
|
+-- other boot information
```

Conceptually:

```text
NexisLoader
      |
      | prepares BootInfo
      v
+---------------------------+
| BootInfo                  |
|                           |
| memory_map  -> 0x50000    |
| map_count   -> N           |
+---------------------------+
             |
             v
           Kernel
```

The kernel would then receive one defined structure instead of depending on hard-coded addresses.

This structure may eventually contain:

* E820 memory map
* E820 entry count
* Kernel location
* Bootloader information
* Video information
* Boot parameters
* Command-line arguments
* Hardware information
* Other firmware-provided information

The exact structure will be defined when the NexisLoader/NexisK boot ABI is formalized.

## Current Memory Map Status

The E820 subsystem currently provides:

* BIOS E820 detection
* E820 enumeration
* 24-byte E820 entry storage
* Entry counting
* E820 map storage at `0x00050000`
* Entry count storage at `0x00057000`
* Protected Mode transition
* Entry count transfer to the C boot entry point
* Kernel-visible access to the stored E820 data

The following are **not yet finalized**:

* Stable `BootInfo` structure
* Stable memory map pointer ABI
* Stable bootloader/kernel calling convention
* Formal boot ABI
* Complete ownership rules for every bootloader memory region

## 16-bit to 32-bit Transition

One of the first major milestones of NexisLoader is the transition from 16-bit Real Mode to 32-bit Protected Mode.

The transition can be summarized as:

```text
16-bit Real Mode
       |
       v
Initialize environment
       |
       v
Detect E820 memory
       |
       v
Store memory map
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

The 32-bit environment serves as the foundation for the kernel-loading implementation.

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
* E820 memory map discovery
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

Useful areas to inspect include:

* Boot-sector execution
* Stage 2 execution
* GDT initialization
* E820 memory detection
* E820 entry collection
* E820 memory map storage
* Memory map delivery
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
* [x] E820 memory region collection
* [x] E820 map storage
* [x] Entry counting
* [x] Memory map made available to kernel environment

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
* [x] Basic E820 memory map availability
* [ ] Stable memory map pointer
* [ ] Stable memory map structure
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
* [x] Initial NexisK memory map integration
* [ ] Test complete NexisK loading
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
| Map Location     | `0x00050000`          |
| Count Location   | `0x00057000`          |
| Entry Size       | 24 bytes              |

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

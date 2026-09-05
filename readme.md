NexisLoader

Handcrafted x86 Kernel Bootloader

NexisLoader is an independent, handcrafted x86 bootloader written from scratch.

Its purpose is to initialize the machine, provide a minimal boot environment, prepare the processor, load a kernel, and transfer execution to it.

NexisLoader is developed independently from NexisK while remaining part of the broader Nexis ecosystem.

From firmware to kernel, one stage at a time.

Project Status

Early Development

NexisLoader is currently in its initial development stage.

The current implementation boots in 16-bit Real Mode, provides a basic interactive menu, handles keyboard input, and transitions into 32-bit Protected Mode.

Kernel loading is currently under development.

Features

Implemented

* [x]	x86 boot entry
* [x]	BIOS boot support
* [x]	16-bit Real Mode
* [x]	Basic initialization
* [x]	Text output
* [x]	Keyboard input
* [x]	Interactive boot menu
* [x]	ENTER key handling
* [x]	Global Descriptor Table (GDT)
* [x]	Real Mode → Protected Mode transition
* [x]	32-bit Protected Mode
* [x]	Basic 32-bit execution environment

In Development

* [ ]	Multi-stage bootloader
* [ ]	Disk access
* [ ]	Kernel discovery
* [ ]	Kernel loading
* [ ]	Kernel validation
* [ ]	Kernel entry-point handling
* [ ]	Boot information structure
* [ ]	Memory map
* [ ]	Filesystem support
* [ ]	ELF kernel support
* [ ]	64-bit Long Mode
* [ ]	x86_64 kernel loading
* [ ]	Stable bootloader/kernel interface

Architecture

The current boot flow is:

                    BIOS
                     |
                     v
                Boot Sector
                     |
                     v
             16-bit Real Mode
                     |
          +----------+----------+
          |          |          |
          v          v          v
      Initialize   Keyboard    Menu
          |                     |
          +----------+----------+
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

The architecture will evolve as additional stages are implemented.

Boot Menu

NexisLoader currently includes a minimal text-based boot menu.

The menu currently serves as both a basic user interface and a development mechanism.

Future versions may use the menu for:

* Kernel selection
* Boot parameters
* Debug modes
* Recovery modes
* Multiple kernel images
* Configuration options

16-bit Real Mode

NexisLoader initially executes in x86 Real Mode.

The initial stage is responsible for establishing the environment required for subsequent execution.

Current responsibilities include:

* Initial processor setup
* Stack initialization
* Text output
* Keyboard input
* Boot menu
* GDT preparation

The 16-bit stage is intentionally kept small.

16-bit to 32-bit Transition

One of the first major milestones of NexisLoader is the transition from 16-bit Real Mode to 32-bit Protected Mode.

The transition can be summarized as:

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

The 32-bit environment will serve as the foundation for the initial kernel-loading implementation.

Global Descriptor Table

The initial Protected Mode environment uses a minimal Global Descriptor Table.

GDT
|
+-- Null Descriptor
|
+-- 32-bit Code Segment
|
+-- 32-bit Data Segment

The GDT implementation may be extended as the architecture develops.

Kernel Loading

The primary responsibility of NexisLoader is to eventually load and start a kernel.

The intended process is:

              NexisLoader
                   |
                   v
             Locate Kernel
                   |
                   v
              Read Kernel
                   |
                   v
          
                   |
                   v
          Transfer Execution
                   |
                   v
                 Kernel

The kernel-loading subsystem is not yet complete.

The final kernel format and boot protocol will be defined during development.

NexisLoader and NexisK

NexisLoader and NexisK are separate repositories and separate projects.

Their intended relationship is:

Nexis Ecosystem
|
+-- NexisLoader
|   |
|   +-- Bootloader
|   +-- Hardware Initialization
|   +-- Kernel Loading
|   `-- Boot Interface
|
`-- NexisK
    |
    +-- Kernel
    +-- Memory Management
    +-- Process Management
    `-- Operating System Components

A future Nexis system may use NexisLoader to start NexisK.

However, NexisLoader is not dependent on NexisK.

The bootloader is intended to remain an independent project capable of loading compatible test or experimental kernels.


Development Philosophy

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

Development Environment

The exact toolchain may evolve, but development is primarily focused on:

* x86 Assembly
* BIOS
* Real Mode
* Protected Mode
* x86 hardware interfaces
* GDT
* Disk I/O
* Memory management
* x86_64 Long Mode

A typical development environment may include an assembler, linker, build system, emulator, and debugger.

Building

NexisLoader uses Make to manage the build process.

Clean

Remove generated build artifacts:

make clean

Build

Compile the project:

make all

Running

Run NexisLoader using the configured emulator:

make run

Debugging

Low-level debugging is an important part of the project.

Future development may include dedicated debugging configurations for:

* Boot-sector execution
* GDT initialization
* Protected Mode entry
* Disk operations
* Kernel loading
* Memory layout
* Kernel handoff

Debug builds should make it possible to identify failures during each individual boot stage.

Roadmap

Phase 1 — Boot Foundation

* [x]	Boot sector
* [x]	Real Mode
* [x]	Basic initialization
* [x]	Text output
* [x]	Keyboard input
* [x]	Boot menu
* [x]	ENTER handling
* [x]	GDT
* [x]	Protected Mode
* [x]	32-bit execution

Phase 2 — Kernel Loader

* [ ]	Second-stage loader
* [ ]	Disk access
* [ ]	Kernel discovery
* [ ]	Kernel loading
* [ ]	Kernel validation
* [ ]	Kernel entry point
* [ ]	Kernel handoff

Phase 3 — Boot Protocol

* [ ]	Boot information structure
* [ ]	Memory map
* [ ]	Hardware information
* [ ]	Kernel parameters
* [ ]	Defined boot ABI
* [ ]	Stable loader/kernel interface

Phase 4 — 64-bit

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

Planned work:

* [ ]	PAE
* [ ]	Page tables
* [ ]	Long Mode
* [ ]	64-bit execution
* [ ]	x86_64 kernel loading

Phase 5 — Nexis Integration

* [ ]	Define NexisLoader/NexisK interface
* [ ]	Define kernel format
* [ ]	Define boot information ABI
* [ ]	Test NexisK loading
* [ ]	Optional NexisK integration

Source Code Identification

Every source file may contain a project identification header:

;
; NexisLoader
; Handcrafted x86 Kernel Bootloader
;
; Independent project within the Nexis ecosystem
;
; Copyright (c) 2026 icarotelesdasilva
; Licensed under the MIT License
; 

The project name is intentionally kept visible throughout the source code and boot environment.

The MIT License requires applicable copyright and license notices to remain with redistributed copies of the software.

License

NexisLoader is released under the MIT License.

Copyright (c) 2026 [AUTHOR NAME]

See LICENSE for the complete license text.

The MIT License permits use, modification, distribution, sublicensing, and commercial use, subject to its terms.

Disclaimer

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

Project Information

Property	Value
Project	NexisLoader
Type	Kernel Bootloader
Architecture	x86
Initial Mode	16-bit Real Mode
Current Target	32-bit Protected Mode
Future Target	x86_64 Long Mode
Status	Early Development
License	MIT
Kernel	Independent
NexisK	Separate Project

Contributing

Contributions, experiments, technical discussions, and improvements may be accepted as the project evolves.

Before submitting changes, ensure that:

1. The code remains consistent with the project’s low-level architecture.
2. Changes are documented when they affect the boot protocol.
3. Build instructions remain functional.
4. Existing functionality is not unintentionally broken.
5. Hardware-specific assumptions are documented.

License and Attribution

NexisLoader is free and open-source software released under the MIT License.

The project name, source-code attribution, and copyright notices are intentionally maintained as part of the project’s identity.

For the legally binding terms, refer to the LICENSE file.

NexisLoader

Handcrafted from scratch.
Built for kernels.
Independent from NexisK.

Firmware
   |
   v
NexisLoader
   |
   v
Kernel
   |
   v
Operating System

From firmware to kernel, one stage at a time.
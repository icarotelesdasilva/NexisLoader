NexisLoader

Handcrafted x86 Kernel Bootloader

NexisLoader is an independent, handcrafted x86 bootloader developed from scratch to initialize the machine, provide a minimal boot interface, prepare the processor, and eventually load and transfer execution to a kernel.

The project is developed as part of the broader Nexis ecosystem, but NexisLoader is a separate project from NexisK.

Its primary purpose is to provide a dedicated bootloader implementation while serving as a low-level development and research project for understanding the boot process, processor initialization, memory, and the interface between a bootloader and a kernel.

⸻

Project Status

Current status: Early Development

NexisLoader is currently in its initial development stage.

The project already has a basic boot flow capable of starting in x86 16-bit Real Mode, displaying a boot menu, accepting keyboard input, and transitioning into 32-bit Protected Mode.

The kernel-loading infrastructure is still under development.

Current Features

* x86 boot support
* BIOS boot entry
* 16-bit Real Mode execution
* Basic boot initialization
* Text-mode boot interface
* Keyboard input
* Boot menu
* ENTER key handling
* Initial Global Descriptor Table (GDT)
* Real Mode to Protected Mode transition
* 32-bit Protected Mode execution
* Basic 32-bit execution environment

Planned Features

* Multi-stage bootloader architecture
* Kernel discovery
* Kernel loading
* Kernel verification
* Kernel execution
* Kernel loading from a filesystem
* ELF kernel support
* Memory detection
* Boot information structure
* Hardware information passed to the kernel
* Bootloader-to-kernel interface
* 64-bit Long Mode support
* x86_64 kernel loading
* Optional NexisK integration

⸻

Purpose

NexisLoader exists to implement the early stages of the system boot process without relying on a pre-existing bootloader implementation.

The project is intentionally low-level.

Instead of hiding the boot process behind a high-level framework, NexisLoader is designed to expose the individual stages involved in getting from firmware execution to kernel execution.

The long-term objective is to provide a small and understandable bootloader capable of preparing a machine and transferring control to a kernel in a well-defined environment.

⸻

NexisLoader and NexisK

NexisLoader and NexisK are separate projects.

NexisLoader is responsible for the boot process and kernel loading.

NexisK is the kernel project.

The intended relationship can be represented as:

Nexis Ecosystem
│
├── NexisLoader
│   └── Bootloader
│
└── NexisK
    └── Kernel

A future system may use NexisLoader to load NexisK:

Firmware / BIOS
       |
       v
NexisLoader
       |
       | Initializes the machine
       | Loads the kernel
       |
       v
NexisK
       |
       v
Operating System

However, NexisLoader does not depend on NexisK being its final or exclusive kernel.

The bootloader is designed as an independent project and may eventually support test kernels or other kernels that conform to its boot interface.

⸻

Boot Process

The current boot process is based on the traditional x86 BIOS boot environment.

The general execution flow is:

BIOS
 |
 v
Boot Sector
 |
 v
16-bit Real Mode
 |
 +-- Basic initialization
 |
 +-- Display initialization
 |
 +-- Boot menu
 |
 +-- Keyboard input
 |
 v
GDT Initialization
 |
 v
Protected Mode
 |
 v
32-bit Execution
 |
 v
Kernel Loader
 |
 v
Kernel

The exact architecture will evolve as the project develops.

⸻

16-bit Real Mode

NexisLoader initially executes in x86 Real Mode.

At this stage, the bootloader performs the operations required before entering Protected Mode.

Initial responsibilities include:

* Establishing the initial execution environment
* Initializing the stack
* Preparing basic display output
* Handling keyboard input
* Displaying the boot menu
* Preparing the Global Descriptor Table
* Preparing the processor for Protected Mode

The 16-bit stage is intentionally kept as small and understandable as possible.

⸻

Boot Menu

NexisLoader currently provides a minimal text-based boot menu.

A conceptual example:

========================================
              NEXISLOADER
========================================
[1] Boot Kernel
[2] Test
[3] Information
Select an option:
Press ENTER to continue...

The menu is part of the early boot environment and is currently intended primarily for development and testing.

As the bootloader evolves, the menu may be extended to support features such as:

* Kernel selection
* Boot parameters
* Debug modes
* Recovery modes
* Multiple kernel images
* Configuration options

⸻

Keyboard Input

NexisLoader contains an initial keyboard input implementation for interacting with the boot menu.

The current implementation is intentionally minimal.

One of the primary inputs handled during the current development stage is:

ENTER

The keyboard subsystem is expected to become more capable as the bootloader develops.

⸻

16-bit to 32-bit Transition

One of the first major technical milestones of NexisLoader is the transition from x86 16-bit Real Mode to 32-bit Protected Mode.

The current conceptual flow is:

16-bit Real Mode
       |
       v
Initialize GDT
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

The transition requires the bootloader to configure the processor appropriately before continuing execution using 32-bit code.

The 32-bit stage provides the foundation for the future kernel-loading implementation.

⸻

Global Descriptor Table

NexisLoader uses a Global Descriptor Table as part of its transition into Protected Mode.

The initial GDT is intentionally simple.

Conceptually:

GDT
|
+-- Null Descriptor
|
+-- 32-bit Code Segment
|
+-- 32-bit Data Segment

This configuration provides the basic segmentation environment required by the initial Protected Mode implementation.

The GDT may be expanded or redesigned as additional processor features are introduced.

⸻

32-bit Protected Mode

After the transition, NexisLoader continues execution in 32-bit Protected Mode.

The 32-bit stage is intended to become the primary environment for the kernel-loading process during the current phase of development.

Future responsibilities may include:

* Memory detection
* Kernel discovery
* Filesystem access
* Kernel loading
* Kernel validation
* Boot information generation
* Preparing the kernel execution environment
* Transferring control to the kernel

⸻

Kernel Loading

The central purpose of NexisLoader is eventually to load and execute a kernel.

The intended high-level process is:

NexisLoader
     |
     v
Locate Kernel
     |
     v
Read Kernel
     |
     v
Load Kernel Into Memory
     |
     v
Validate Kernel
     |
     v
Prepare Kernel Environment
     |
     v
Transfer Control
     |
     v
Kernel

The kernel-loading implementation is not yet considered complete.

The exact kernel format and boot protocol will be defined as the project progresses.

⸻

Future 64-bit Support

The current development target focuses on establishing a functional 32-bit Protected Mode environment.

A future version is expected to support x86_64 Long Mode.

The intended progression is:

16-bit Real Mode
        |
        v
32-bit Protected Mode
        |
        v
64-bit Long Mode
        |
        v
64-bit Kernel

The transition to Long Mode will require additional processor initialization, including appropriate page tables and other architectural requirements.

⸻

Architecture

NexisLoader is designed around a staged boot architecture.

A possible future architecture is:

Stage 1
  |
  | Minimal boot entry
  v
Stage 2
  |
  | Extended bootloader
  v
Kernel Loader
  |
  | Kernel discovery and loading
  v
Kernel

The exact number and responsibilities of stages are subject to change.

The project prioritizes keeping each stage understandable and independently testable.

⸻

Project Structure

The repository may be organized approximately as follows:

NexisLoader/
|
+-- src/
|   |
|   +-- boot.asm
|   +-- menu.asm
|   +-- keyboard.asm
|   +-- gdt.asm
|   +-- protected_mode.asm
|   +-- kernel_loader.asm
|   +-- disk.asm
|   `-- memory.asm
|
+-- kernel/
|   `-- test_kernel.asm
|
+-- scripts/
|   `-- build.sh
|
+-- build/
|
+-- Makefile
+-- LICENSE
`-- README.md

The structure is not considered final and may change as the architecture becomes more mature.

⸻

Development Philosophy

NexisLoader follows a simple development philosophy:

Understand the machine by implementing the fundamentals directly.

The project emphasizes:

* Low-level programming
* Explicit processor initialization
* Minimal abstractions
* Small components
* Understandable assembly
* Direct interaction with hardware interfaces
* Incremental development
* Clear separation between bootloader and kernel

The goal is not merely to produce a bootable image.

The goal is to understand how the system reaches the point where a kernel can take control.

⸻

Technology

The project is primarily focused on x86 low-level development.

Current and planned technologies include:

* x86 Assembly
* BIOS
* Real Mode
* Protected Mode
* Global Descriptor Table
* x86 hardware interfaces
* Keyboard input
* Disk access
* Memory detection
* Protected-mode execution
* x86_64 Long Mode
* Kernel loading

The specific assembler, linker, emulator, and build tools may vary depending on the development environment.

⸻

Testing

During development, NexisLoader should preferably be tested using an emulator or virtual machine.

The intended development flow is:

Source Code
    |
    v
Assembler
    |
    v
Build System
    |
    v
Boot Image
    |
    v
Emulator / Virtual Machine
    |
    v
BIOS
    |
    v
NexisLoader
    |
    v
Kernel

Experimental bootloader builds should be tested carefully before being executed on physical hardware.

⸻

Roadmap

Phase 1 — Boot Foundation

* [x]	Boot sector
* [x]	16-bit Real Mode
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
* [ ]	Transfer control to kernel

Phase 3 — Boot Interface

* [ ]	Boot information structure
* [ ]	Memory map
* [ ]	Hardware information
* [ ]	Kernel command-line parameters
* [ ]	Defined boot protocol
* [ ]	Stable loader/kernel interface

Phase 4 — 64-bit

* [ ]	PAE
* [ ]	Page tables
* [ ]	Long Mode
* [ ]	x86_64 execution
* [ ]	64-bit kernel loading

Phase 5 — Nexis Integration

* [ ]	Define NexisLoader/NexisK interface
* [ ]	Test NexisK loading
* [ ]	Define kernel format
* [ ]	Define boot information ABI
* [ ]	Optional NexisK integration

⸻

Source Code Identity

NexisLoader is intentionally developed as a recognizable project.

The project name should remain clearly identifiable throughout the source tree and documentation.

Source files may use a header similar to:

; ============================================================
; NexisLoader
; Handcrafted x86 Kernel Bootloader
;
; Independent project within the Nexis ecosystem
;
; Copyright (c) 2026 [AUTHOR NAME]
; Licensed under the MIT License
; ============================================================

The bootloader may also identify itself during execution:

========================================
              NEXISLOADER
========================================
Initializing...

The MIT License requires preservation of the applicable copyright and license notices when redistributing the software.

⸻

License

NexisLoader is released under the MIT License.

Copyright (c) 2026 [AUTHOR NAME]

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files, to deal in the software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and sell copies of the software, subject to the conditions stated in the license.

See the LICENSE file for the complete license text.

⸻

Disclaimer

NexisLoader is an experimental project under active development.

The boot protocol, memory layout, kernel format, source structure, interfaces, and implementation details may change without compatibility guarantees.

NexisLoader should not currently be considered production-ready boot software.

⸻

Relationship to the Nexis Ecosystem

NexisLoader is an independent project developed within the broader Nexis ecosystem.

Its existence does not imply that it is the official, final, or mandatory bootloader for NexisK.

The projects may evolve independently.

The intended relationship is:

                    Nexis Ecosystem
                           |
              +------------+------------+
              |                         |
              v                         v
        NexisLoader                  NexisK
        Bootloader                   Kernel
              |                         ^
              |                         |
              +------ loads ------------+

The long-term architecture will be determined as both projects mature.

⸻

Project Identity

Project: NexisLoader
Type: x86 Kernel Bootloader
Architecture: x86
Current Execution Mode: 16-bit Real Mode → 32-bit Protected Mode
Status: Early Development
License: MIT
Relationship: Independent project within the Nexis ecosystem

⸻

Final Objective

The long-term objective of NexisLoader is straightforward:

Firmware
   |
   v
NexisLoader
   |
   | Initialize
   | Configure
   | Load
   | Prepare
   |
   v
Kernel
   |
   v
Operating System

NexisLoader is intended to be the layer responsible for taking the machine from its initial boot state to the point where the kernel can assume control.

It is built from the ground up, one stage at a time.
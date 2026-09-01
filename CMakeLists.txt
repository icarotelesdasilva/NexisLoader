cmake_minimum_required(VERSION 3.20)

project(NexisLoader NONE)

find_program(NASM nasm REQUIRED)
find_program(GCC gcc REQUIRED)
find_program(LD ld REQUIRED)
find_program(DD dd REQUIRED)
find_program(QEMU qemu-system-i386 REQUIRED)

set(STAGE1_SRC ${CMAKE_SOURCE_DIR}/stage1.S)
set(STAGE2_SRC ${CMAKE_SOURCE_DIR}/stage2.S)
set(BOOT_C    ${CMAKE_SOURCE_DIR}/boot/boot.c)

set(STAGE1_BIN ${CMAKE_BINARY_DIR}/stage1.bin)
set(STAGE2_OBJ ${CMAKE_BINARY_DIR}/stage2.o)
set(BOOT_OBJ   ${CMAKE_BINARY_DIR}/boot.o)
set(STAGE2_BIN ${CMAKE_BINARY_DIR}/stage2.bin)
set(STAGE2_INC ${CMAKE_BINARY_DIR}/stage2_sectors.inc)
set(DISK_IMG   ${CMAKE_BINARY_DIR}/disk.img)

add_custom_command(
OUTPUT ${STAGE2_OBJ}
COMMAND ${NASM}
-f elf32
${STAGE2_SRC}
-o ${STAGE2_OBJ}
DEPENDS ${STAGE2_SRC}
VERBATIM
)

add_custom_command(
OUTPUT ${BOOT_OBJ}
COMMAND ${GCC}
-m32
-ffreestanding
-fno-pie
-fno-stack-protector
-fno-builtin
-nostdlib
-nodefaultlibs
-c
${BOOT_C}
-o ${BOOT_OBJ}
DEPENDS ${BOOT_C}
VERBATIM
)

add_custom_command(
OUTPUT ${STAGE2_BIN}
COMMAND ${LD}
-m elf_i386
-Ttext 0x10000
-e stage2
--oformat binary
${STAGE2_OBJ}
${BOOT_OBJ}
-o ${STAGE2_BIN}
DEPENDS
${STAGE2_OBJ}
${BOOT_OBJ}
VERBATIM
)

add_custom_command(
OUTPUT ${STAGE2_INC}
COMMAND ${CMAKE_COMMAND}
-DSTAGE2_BIN=${STAGE2_BIN}
-DSTAGE2_INC=${STAGE2_INC}
-P ${CMAKE_SOURCE_DIR}/generate_sectors.cmake
DEPENDS ${STAGE2_BIN}
VERBATIM
)


add_custom_command(
OUTPUT ${STAGE1_BIN}
COMMAND ${NASM}
-f bin
-I${CMAKE_BINARY_DIR}/
${STAGE1_SRC}
-o ${STAGE1_BIN}
DEPENDS
${STAGE1_SRC}
${STAGE2_INC}
VERBATIM
)

add_custom_command(
OUTPUT ${DISK_IMG}


COMMAND ${CMAKE_COMMAND}
        -E copy
        ${STAGE1_BIN}
        ${DISK_IMG}

COMMAND ${DD}
        if=${STAGE2_BIN}
        of=${DISK_IMG}
        bs=512
        seek=1
        conv=notrunc

DEPENDS
    ${STAGE1_BIN}
    ${STAGE2_BIN}
VERBATIM


)


add_custom_target(bootloader ALL
DEPENDS ${DISK_IMG}
)


add_custom_target(run
COMMAND ${QEMU}
-drive format=raw,file=${DISK_IMG}
-net none
DEPENDS bootloader
USES_TERMINAL
)

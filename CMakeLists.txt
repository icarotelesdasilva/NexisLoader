cmake_minimum_required(VERSION 3.20)

project(MyBootloader NONE)

find_program(NASM nasm REQUIRED)
find_program(QEMU qemu-system-i386 REQUIRED)

set(BUILD_DIR ${CMAKE_BINARY_DIR})

set(STAGE1_BIN ${BUILD_DIR}/stage1.bin)
set(STAGE2_BIN ${BUILD_DIR}/stage2.bin)
set(DISK_IMG   ${BUILD_DIR}/disk.img)

add_custom_command(
    OUTPUT ${STAGE1_BIN}
    COMMAND ${NASM} -f bin
            ${CMAKE_SOURCE_DIR}/stage1.S
            -o ${STAGE1_BIN}
    DEPENDS ${CMAKE_SOURCE_DIR}/stage1.S
    VERBATIM
)

add_custom_command(
    OUTPUT ${STAGE2_BIN}
    COMMAND ${NASM} -f bin
            ${CMAKE_SOURCE_DIR}/stage2.S
            -o ${STAGE2_BIN}
    DEPENDS ${CMAKE_SOURCE_DIR}/stage2.S
    VERBATIM
)

add_custom_command(
    OUTPUT ${DISK_IMG}
    COMMAND ${CMAKE_COMMAND} -E cat
            ${STAGE1_BIN}
            ${STAGE2_BIN}
            > ${DISK_IMG}
    DEPENDS ${STAGE1_BIN} ${STAGE2_BIN}
    VERBATIM
)

add_custom_target(bootloader ALL
    DEPENDS ${DISK_IMG}
)

add_custom_target(run
    COMMAND ${QEMU} -drive format=raw,file=${DISK_IMG}
    DEPENDS bootloader
    USES_TERMINAL
)
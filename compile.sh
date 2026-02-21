#!/bin/sh

OUTPUT=${OUTPUT:=.}
INPUT=${INPUT:=src}
QUICKJS=${QUICKJS:=./quickjs}
OUTPUT_FILE=${OUTPUT_FILE:=quickjs-eval.js}

emcc -o ${OUTPUT}/${OUTPUT_FILE} \
        ${INPUT}/exports.c \
        ${QUICKJS}/quickjs.c \
        ${QUICKJS}/cutils.c \
        ${QUICKJS}/libregexp.c \
        ${QUICKJS}/libunicode.c \
        ${QUICKJS}/dtoa.c \
        -I${QUICKJS} \
        -I${INPUT} \
        -DCONFIG_VERSION="\"1.0.0\"" \
        -s ALLOW_MEMORY_GROWTH=1 \
        -s WASM=1 \
        -s SINGLE_FILE \
        -s MODULARIZE=1 \
        -s EXPORT_ES6=1 \
        -s ENVIRONMENT='web' \
        -s ERROR_ON_UNDEFINED_SYMBOLS=1 \
        -s NO_FILESYSTEM=1 \
        -s NO_EXIT_RUNTIME=1 \
        -s MALLOC=emmalloc \
        -lm -Oz \
        -s EXPORTED_FUNCTIONS='["_init", "_commFun", "_evalInSandbox", "_nukeSandbox", "_dumpMemoryUse", "_free"]' \
        -s EXPORTED_RUNTIME_METHODS='["ccall", "cwrap", "stringToNewUTF8"]' \
        -s AGGRESSIVE_VARIABLE_ELIMINATION=1 \
        -s ASSERTIONS=0 \
        -flto \
        --closure 1 \
        --js-library ${INPUT}/myjs.js

sed -i '1 i\/* THIS FILE IS GENERATED - DO NOT EDIT */' ${OUTPUT}/${OUTPUT_FILE}
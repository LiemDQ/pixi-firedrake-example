#!/bin/bash

# Variables that depend on PETSC_ARCH. Static variables (CC, CXX, HDF5_MPI,
# PYOP2_*) are set in pixi.toml under [feature.firedrake-build.activation.env].

# Not relying on PETSC_DIR from pixi.toml here: this script is also sourced
# directly by scripts/install-firedrake.sh.
export PETSC_DIR="$CONDA_PREFIX/petsc"

# Auto-detect PETSC_ARCH only if not already set (the build tasks set it)
if [ -z "$PETSC_ARCH" ]; then
    if [ -d "$PETSC_DIR/arch-firedrake-complex" ]; then
        export PETSC_ARCH="arch-firedrake-complex"
    else
        export PETSC_ARCH="arch-firedrake-default"
    fi
fi

# SLEPc support (auto-detect if installed)
if [ -e "$PETSC_DIR/$PETSC_ARCH/lib/libslepc.so" ] || [ -e "$PETSC_DIR/$PETSC_ARCH/lib/libslepc.dylib" ]; then
    export SLEPC_DIR="$PETSC_DIR/$PETSC_ARCH"
fi

# Point to PETSc's built HDF5
export HDF5_DIR="$PETSC_DIR/$PETSC_ARCH"

# Ensure libraries are found at runtime
export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:$PETSC_DIR/$PETSC_ARCH/lib:${LD_LIBRARY_PATH:-}"
export PKG_CONFIG_PATH="$CONDA_PREFIX/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

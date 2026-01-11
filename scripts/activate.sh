#!/bin/bash

# PETSc configuration
export PETSC_DIR="$CONDA_PREFIX/petsc"
export PETSC_ARCH="arch-firedrake-default"

# Auto-detect PETSC_ARCH: prefer complex if it exists, otherwise default
if [ -d "$PETSC_DIR/arch-firedrake-complex" ]; then
    export PETSC_ARCH="arch-firedrake-complex"
else
    export PETSC_ARCH="arch-firedrake-default"
fi

# SLEPc support (auto-detect if installed)
if [ -d "$PETSC_DIR/$PETSC_ARCH/lib/libslepc.so" ] || [ -d "$PETSC_DIR/$PETSC_ARCH/lib/libslepc.dylib" ]; then
    export SLEPC_DIR="$PETSC_DIR/$PETSC_ARCH"
fi

# MPI compiler wrappers
export CC=mpicc
export CXX=mpicxx

# HDF5 MPI support - point to PETSc's built HDF5
export HDF5_MPI="ON"
export HDF5_DIR="$PETSC_DIR/$PETSC_ARCH"

# Ensure libraries are found at runtime
export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:$PETSC_DIR/$PETSC_ARCH/lib:${LD_LIBRARY_PATH:-}"
export PKG_CONFIG_PATH="$CONDA_PREFIX/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

# PyOP2 compilation flags. For JIT kernel compilation, PyOP2 uses the `sniff_compiler` function 
# to detect the compiler version and set flags accordingly. However Conda compiler versions typically start with
# arch-conda-os-* which PyOP2 doesn't expect, and it defaults to AnonymousCompiler which doesn't provide the right flags.  
# So we need to manually set -shared and -fPIC.
export PYOP2_CFLAGS="-fPIC"
export PYOP2_LDFLAGS="-shared"

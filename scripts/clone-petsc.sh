#!/bin/bash
set -e

PETSC_DIR="$CONDA_PREFIX/petsc"

if [ ! -d "$PETSC_DIR" ]; then
    PETSC_VERSION=$(python3 "$CONDA_PREFIX/firedrake-configure" --show-petsc-version)
    echo "Cloning PETSc version: $PETSC_VERSION"
    git clone --depth 1 --branch "$PETSC_VERSION" \
        https://gitlab.com/petsc/petsc.git "$PETSC_DIR"
else
    echo "PETSc directory already exists, skipping clone"
fi

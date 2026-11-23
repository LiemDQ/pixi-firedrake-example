#!/bin/bash
set -e

#"default" or "complex" 
ARCH_TYPE="$1" 

# Firedrake installation options.
FIREDRAKE_EXTRAS="$2" 

# Additional PETSc configuration flags.
PETSC_EXTRAS="$3"

# PETSC_ARCH is set by the pixi task (see `env` in pixi.toml)
: "${PETSC_ARCH:?PETSC_ARCH must be set; run this via 'pixi run setup'}"

if [ "$ARCH_TYPE" = "complex" ]; then
    ARCH_FLAG="--arch complex"
else
    ARCH_FLAG=""
fi

if [[ $FIREDRAKE_EXTRAS == *"slepc"* ]]; then
    PETSC_EXTRAS="$PETSC_EXTRAS --download-slepc"
fi

PETSC_DIR="$CONDA_PREFIX/petsc"
cd "$PETSC_DIR"

if [ ! -f "$PETSC_ARCH/lib/libpetsc.so" ]; then
    echo "Configuring PETSc (arch=$ARCH_TYPE)..."

    # We use --no-package manager to ensure all dependencies are properly
    # configured rather than relying on the system package manager, 
    # or conda packages.
    BASE_OPTS=$(python3 "$CONDA_PREFIX/firedrake-configure" \
        --no-package-manager $ARCH_FLAG \
        --show-petsc-configure-options)

    # Combine with extra options
    echo "$BASE_OPTS $PETSC_EXTRAS" | xargs ./configure

    echo "Building PETSc..."
    make PETSC_DIR="$PETSC_DIR" PETSC_ARCH="$PETSC_ARCH" all
else
    echo "PETSc ($PETSC_ARCH) already built, skipping"
fi

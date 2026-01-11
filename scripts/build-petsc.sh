#!/bin/bash
set -e

ARCH_TYPE="$1" #"${PETSC_ARCH_TYPE:-default}"

FIREDRAKE_EXTRAS="$2" #${PETSC_SLEPC:-false}"

# Additional PEtSc configuration flags.
PETSC_EXTRAS="$3"

# Determine PETSC_ARCH based on arch type
if [ "$ARCH_TYPE" = "complex" ]; then
    PETSC_ARCH="arch-firedrake-complex"
    ARCH_FLAG="--arch complex"
else
    PETSC_ARCH="arch-firedrake-default"
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

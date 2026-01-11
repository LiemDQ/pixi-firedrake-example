#!/bin/bash
set -e

# Configuration from environment (set by pixi task)
ARCH_TYPE="$1" #"${PETSC_ARCH_TYPE:-default}"
EXTRAS="$2" #"${PETSC_SLEPC:-false}"

# Determine PETSC_ARCH
if [ "$ARCH_TYPE" = "complex" ]; then
    PETSC_ARCH="arch-firedrake-complex"
else
    PETSC_ARCH="arch-firedrake-default"
fi

# Build the extras string for pip
# Start with "check" as base
EXTRAS_LIST="check"

# Add user-specified extras
if [ -n "$EXTRAS" ]; then
    EXTRAS_LIST="$EXTRAS_LIST,$EXTRAS"
fi

# Add slepc if requested
if [[ $EXTRAS_LIST == *"slepc"* ]]; then
    export SLEPC_DIR="$CONDA_PREFIX/petsc/$PETSC_ARCH"
fi

echo "Installing Firedrake with extras: [$EXTRAS_LIST]"
pip cache purge
pip install --no-binary h5py "firedrake[$EXTRAS_LIST]"
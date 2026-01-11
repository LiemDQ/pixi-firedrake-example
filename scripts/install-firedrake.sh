#!/bin/bash
set -e

# Configuration from environment (set by pixi task)
ARCH_TYPE="$1"
EXTRAS="$2" 

# Determine and export PETSC_ARCH before sourcing activate.sh
if [ "$ARCH_TYPE" = "complex" ]; then
    export PETSC_ARCH="arch-firedrake-complex"
else
    export PETSC_ARCH="arch-firedrake-default"
fi

# Re-source activate.sh to pick up correct HDF5_DIR, LD_LIBRARY_PATH, etc.
# (activate.sh respects pre-set PETSC_ARCH and won't override it)
source "$(dirname "$0")/activate.sh"

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

PIP_FLAGS=""
if [[ $EXTRAS_LIST == *"torch"* ]]; then
    PIP_FLAGS="--extra-index-url https://download.pytorch.org/whl/cpu $PIP_FLAGS"
fi

echo "Installing Firedrake with extras: [$EXTRAS_LIST]"
pip cache purge
pip install --no-binary h5py "firedrake[$EXTRAS_LIST]"
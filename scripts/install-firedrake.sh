#!/bin/bash
set -e

# Firedrake extras, comma-separated
EXTRAS="$1"

# PETSC_ARCH is set by the pixi task (see `env` in pixi.toml)
: "${PETSC_ARCH:?PETSC_ARCH must be set; run this via 'pixi run setup'}"

# Pixi ran activate.sh before the task's PETSC_ARCH was applied, so HDF5_DIR,
# LD_LIBRARY_PATH, etc. may point at a different arch. Re-source it to
# recompute them (activate.sh respects a pre-set PETSC_ARCH).
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
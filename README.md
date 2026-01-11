# pixi-firedrake-example

This is an example of how to integrate [Firedrake](https://www.firedrakeproject.org/index.html#) with [Pixi](https://pixi.prefix.dev/latest/), a modern package manager designed for scientific computing. 

## System requirements

* Pixi version 0.62.0 or greater.
* 64-bit Linux or MacOS.

## Quick start

You can install Firedrake by cloning this repository and simply running `pixi run setup` in the root folder.

```bash
# Install Firedrake and all dependencies
# NOTE: will take 30-60 minutes for a fresh build!
pixi run setup

# Verify installation using firedrake-check
pixi run check

# Activation of installation environment in shell
pixi shell 
```

To isolate the installation from your system, all of the dependencies for PETSc are downloaded and compiled from scratch. This can take over an hour, depending on your computer and internet connection. 

Once installed, updating will be much faster as only packages that require updates will be updated or rebuilt. You can also cache or copy the `.pixi/` folder for team use. 

## Project dependencies

Any other project dependencies can be installed with Pixi from a Conda channel or PyPi using the normal approach. Pixi will handle the dependency resolution and package installation.

Either use the CLI:
```
pixi add numpy matplotlib ...
```
Or modify `pixi.toml` directly:

```toml
[dependencies]
numpy = ...      # Add project deps here
matplotlib = ...
```

## Build customization

The installation process can be customized by passing additional arguments to `pixi run setup`. The order of arguments is:

```bash
pixi run setup arch extras petsc_opts
```

* `arch` determines the PETSc number support and is either `default` or `complex`.
* `extras` is for additional Firedrake dependencies like slepc, vtk, jax. Must be provided as a quotation mark delineated string of comma-separated variables: `"vtk,jax,slepc,..."`
* `petsc_opts` is a list of compiler flags for PETSc compilation. Must be provided as a string of flags. 

As of version 0.62.0, Pixi's task CLI functionality is fairly basic, and it isn't possible to skip arguments or provide them as flags. If you have a specific and complex build in mind, it may be preferable to directly modify the shell scripts found in `scripts/`.

## Why Pixi?

By design, Firedrake is tightly coupled to PETSc, and to link properly it needs to have full knowledge of PETSc's build configuration—not just the build version number. This historically made it hard to work with environment-based package managers like Conda/Mamba, which download precompiled binaries without control over the compilation flags. (There is even a [mention of this in the installation FAQ.](https://github.com/firedrakeproject/firedrake/wiki/Install-Frequently-Asked-Questions))

Pixi uses a workspace-based approach, akin to [Poetry](https://python-poetry.org/), to ensure builds are portable, reproducible, automatable and isolated. All the installation files are contained in a single folder that can be nuked and rebuilt. That means nothing leaks out into the system PATH or causes weird caching issues with other projects on your system. No manual virtual environment management. And everything can be set up with a few commands. 
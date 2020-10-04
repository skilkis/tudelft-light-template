# ![LightLogo](/images/header_logo.svg)

A minimal repository containing the TU Delft Light report template which can be
integrated into other repositories as a submodule. The benefit of using this
submodule is the ability to receive updates directly. For a full list of
features as well as examples of this LaTeX template please visit the main
[`tudelft-light`](https://github.com/skilkis/tudelft-light) repository.

## Installation

To use this repository as a submodule a `.gitmodules` file must be defined in
the parent repository with the following contents:

```gitconfig
[submodule "tudelft-light"]
    path = tudelft-light
    url = https://github.com/skilkis/tudelft-light-template.git
    branch = master
```

Then in the parent repository, the submodule can be initialized with the
following command:

```bash
git submodule update --init tudelft-light
```

## Updating

Once the submodule is installed, the following command will fetch the
newest version of the template:

```bash
git submodule update --recursive --remote
```
# ![LightLogo](./images/header_logo.svg)

A minimal repository containing the TU Delft Light report template which can be
integrated into other repositories as a submodule. The benefit of using this
submodule is the ability to receive updates directly. For a full list of
features, changelog, as well as examples of this LaTeX template please visit
the main [`tudelft-light`](https://github.com/skilkis/tudelft-light)
repository.

## Installation

To use this repository as a submodule a `.gitmodules` file must be defined in
the parent repository with the following contents:

```gitconfig
[submodule "tudelft-light"]
    path = tudelft-light
    url = https://github.com/skilkis/tudelft-light-template.git
    branch = master
```

The easiest way to generate this file as well as clone the template is to run
the following command:

```bash
git submodule add https://github.com/skilkis/tudelft-light-template.git tudelft-light
```

If desired, the template can be added into a subdirectory, i.e a `docs/` folder
as follows:

```bash
git submodule add https://github.com/skilkis/tudelft-light-template.git docs/tudelft-light
```

## Updating

Once the submodule is installed, the following command will fetch the
newest version of the template:

```bash
git submodule update --recursive --remote
```

If you have other submodules in the parent repository and only want to update
the template, then use the following command:

```bash
git submodule update --remote tudelft-light
```

**Note:** If the `docs/` subdirectoy method was used when installing the
template, the above command will become:

```bash
git submodule update --remote docs/tudelft-light
```

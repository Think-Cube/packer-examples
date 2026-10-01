# Contributing

Thank you for your interest in contributing to PackerExamples.

## Guidelines

- All templates must be written in **HCL2** (`.pkr.hcl`). JSON templates are not accepted.
- Target **currently supported** OS versions only.
- Every template must pass `packer validate` before opening a pull request.
- Include a `variables.pkrvars.hcl.example` for any template that requires user-supplied variables.
- Scripts must be POSIX-compatible (`#!/usr/bin/env bash`, `set -euo pipefail`).
- PowerShell scripts must include `#Requires -RunAsAdministrator` and `$ErrorActionPreference = "Stop"`.

## Adding a new template

1. Fork the repository and create a feature branch.
2. Create a directory under the appropriate platform folder (`azure/`, `virtualbox/`, or `vmware/`).
3. Add the template, scripts, and an example var file.
4. Run `packer init . && packer validate .` locally.
5. Open a pull request — CI will re-run validation automatically.

## Commit style

Use short imperative commit messages, e.g.:

```
add rocky-9 vmware template
update ubuntu-24.04 iso checksum
fix debian-12 preseed late-command
```

## License

By contributing you agree that your contribution is licensed under the [MIT License](LICENSE).

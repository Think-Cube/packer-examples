# Security Policy

## Supported versions

Only the latest commit on the `main` branch is actively maintained.

## Reporting a vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.

Report them privately via GitHub's [Security Advisories](https://github.com/Think-Cube/PackerExamples/security/advisories/new) feature.

Include:
- A description of the vulnerability
- Steps to reproduce
- Potential impact

We aim to respond within 5 business days.

## Notes

- Never commit real credentials — use environment variables or a `.pkrvars.hcl` file listed in `.gitignore`.
- The example var files (`*.pkrvars.hcl.example`) must contain only placeholder values.

<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/org-logos/master/orgs/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" width="256" />
    </a>
</p>

<h1 align="center">The Lupaxa Project: The<em>.github</em> Repository</h1>

This repository contains organisation‑wide documentation, standards, and governance for all projects within **The Lupaxa Project** GitHub organisation.
These documents define how our tools are developed, maintained, secured, documented, and governed.

## Organisation Overview

This repository defines the organisation-wide defaults for:

- Issue templates
- Pull request templates
- Shared documentation (security, contribution guidelines, etc.)
- Label conventions
- Central governance and project structure

These files apply automatically to all repositories under The Lupaxa Project unless explicitly overridden.

<h2>How GitHub Uses This Repo</h2>

GitHub automatically recognises and applies certain files from this repository across all the organisations **public repositories**:

Supported Files:

- CODE_OF_CONDUCT.md
- CONTRIBUTING.md
- FUNDING.md
- GOVERNANCE.md
- SECURITY.md
- SUPPORT.md

Supported Directories:

- ISSUE_TEMPLATE
- PULL_REQUEST_TEMPLATE

<h3>Extending or Overriding Defaults</h3>

Projects within The Lupaxa Project inherit these organizational files automatically.
However, maintainers can override or extend them when necessary.

Repositories overriding central files should retain references back to the organisation-wide versions to preserve visibility and intent.

<h4>Example</h4>

```text
This repository extends the Lupaxa Project Contributing Guidelines.
```

<h2>Key Documents</h2>

- [Code of Conduct][1]
- [Contributing][2]
- [Governance][3]
- [Maintainers][4]
- [Projects Overview][5]
- [Security Policy][6]
- [Support Guide][7]

[1]: https://github.com/TheLupaxaProject/.github/blob/master/CODE_OF_CONDUCT.md
[2]: https://github.com/TheLupaxaProject/.github/blob/master/CONTRIBUTING.md
[3]: https://github.com/TheLupaxaProject/.github/blob/master/GOVERNANCE.md
[4]: https://github.com/TheLupaxaProject/.github/blob/master/MAINTAINERS.md
[5]: https://github.com/TheLupaxaProject/.github/blob/master/PROJECTS.md
[6]: https://github.com/TheLupaxaProject/.github/blob/master/SECURITY.md
[7]: https://github.com/TheLupaxaProject/.github/blob/master/SUPPORT.md

<h2>Organisation-Wide Labels</h2>

We maintain a consistent, structured label taxonomy across all repositories:

- Impact levels (impact: critical, impact: low, etc.)
- State labels (state: triage, state: confirmed, etc.)
- Resolution labels
- Dependabot ecosystem labels
- Type labels (type: feature, type: bug, …)

More details can be found in the labels section of [How to Contribute](CONTRIBUTING.md).

<h2>Security by Design</h2>

Security is a core organisational principle.

- All commits must be signed
- All workflows follow principle of least privilege
- Default permissions are read-only unless escalated by consumer workflows
- All reusable workflows include explicit input validation and guardrails
- Public vulnerability handling is documented in [Security Policy](SECURITY.md)

<h2>High-Level Governance</h2>

The Lupaxa Project enforces:

- Consistent coding standards across languages
- Reproducible builds
- Mandatory testing in all relevant versions
- Open governance for feature proposals
- Clearly defined lifecycle for issues and PRs
- Automated stale/triage workflows
- Secure, minimal permissions for all automation

This repository captures these principles so all downstream repositories inherit the same quality and safety requirements.

<h2>Contributing</h2>

We welcome all contributions, code, documentation, testing, or design.

Review:

- [How to Contribute](CONTRIBUTING.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)

Before sending a pull request.

<h2>Security Reporting</h2>

Never open a public issue for a vulnerability.

Please refer to the [Security Policy](SECURITY.md) for the correct reporting channel.

<h2>License</h2>

Unless explicitly stated otherwise, repositories under The Lupaxa Project follow the [MIT License](LICENSE.md).

<h1></h1>

<p align="center">
    <strong>
        &copy; The Lupaxa Project.
    </strong>
    <br />
    <em>
        Where exploration meets precision.<br />
        Where the untamed meets the engineered.
    </em>
</p>

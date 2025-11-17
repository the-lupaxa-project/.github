<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/org-logos/master/orgs/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" width="256" />
    </a>
</p>

<h1 align="center">The Lupaxa Project: The <em>.github</em> Repository</h1>

<h2>Overview</h2>

This repository (the-lupaxa-project/.github) defines the organisation-wide defaults for:

- Issue templates
- Pull request templates
- Organisation-level GitHub Actions workflows
- Shared documentation (security, contribution guidelines, etc.)
- Label conventions
- Central governance and project structure

These files apply automatically to all repositories under The Lupaxa Project unless explicitly overridden.

This repo acts as the central source of truth for project standards, security practices, automation, and contributor experience.

<h2>How GitHub Uses This Repo</h2>

GitHub automatically recognises and applies certain files from the organisation’s `.github` repository across all its **public repositories**:

| File / Folder          | Purpose                                          |
| :--------------------- | :----------------------------------------------- |
| profile/README.md      | Appears on the organisation’s public profile.    |
| CODE_OF_CONDUCT.md     | Linked automatically in all repositories.        |
| CONTRIBUTING.md        | Used as the default contribution guide.          |
| SECURITY.md            | Linked under "Report a vulnerability".           |
| ISSUE_TEMPLATE/        | Shared issue templates.                          |
| PULL_REQUEST_TEMPLATE/ | Shared PR templates for consistent submissions.  |
| .github/workflows/     | Provides reusable workflows for CI/CD.           |

<h3>Extending or Overriding Defaults</h3>

Projects within The Lupaxa Project inherit these organizational files automatically.
However, maintainers can override or extend them when necessary:

- Custom CONTRIBUTING.md — additional testing or workflow steps.
- Custom SECURITY.md — defining project-specific scope or contact options.
- Extra issue templates — for highly specialized tools.
- Repo-specific workflows — custom build/test pipelines layered on top of reusable ones.
- Per-repo lint configs (for example .markdownlint.yaml, .yamllint.yaml) — to fine-tune local rules.

Repositories overriding central files should retain references back to the organization-wide versions to preserve visibility and intent.

<h4>Example</h4>

```text
This repository extends the Lupaxa Project Contributing Guidelines.
```

<h2>Documentation Index</h2>

The Lupaxa Project follows a structured, cross-referenced documentation model.
Each file plays a specific role and links into the overall governance structure.

<h3>Contributor & Community Documentation</h3>

| Document                                 | Purpose                                                  |
| :--------------------------------------- | :------------------------------------------------------- |
| [CONTRIBUTING.md](CONTRIBUTING.md)￼      | How to report issues, request features, and submit PRs.  |
| [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)￼| Expected behaviour and community standards.              |
| [PROJECTS.md](PROJECTS.md)￼              | Overview of key projects in the organisation.            |
| [WORKFLOWS.md](WORKFLOWS.md)￼            | Documentation for all reusable GitHub Actions workflows. |

<h3>Security Documentation</h3>

| Document                                             | Purpose                                                       |
| :--------------------------------------------------- | :------------------------------------------------------------ |
| [SECURITY.md](SECURITY.md)￼                          | Public vulnerability disclosure policy.                       |
| [SECURITY_PROCESSS.md](SECURITY_PROCESS.md)          | Internal lifecycle for security reports, fixes, & disclosure. |
| [SECURITY_ARCHITECTURE.md](SECURITY_ARCHITECTURE.md) | High-level security principles and organisational guarantees. |

> [!NOTE]
> Private versions of security documents are maintained in our private .github-private repository.

<h2>Reusable GitHub Workflows</h2>

This repository also acts as a **central catalog of reusable workflows** for:

- Standardised linting
- Security scanning
- Workflow hardening
- Release preparation & tagging
- Dependency automation
- Slack notifications
- Check-jobs validation
- Code quality enforcement

There are two layers:

1. **Reusable workflows**
   - Live in this repo: `.github/workflows/reusable-*.yml`  
   - Called by other repos via `uses: the-lupaxa-project/.github/...@master`

2. **Local workflows**
   - Live in this repo: `.github/workflows/local-*.yml`  
   - Use `uses: ./.github/workflows/reusable-*.yml` to call the shared logic.

A complete description of each reusable workflow is available in [WORKFLOWS.md](WORKFLOWS.md) which also includes input tables, behaviour notes, and consumer examples.

<h2>Organisation-Wide Labels</h2>

We maintain a consistent, structured label taxonomy across all repositories:

- Impact levels (impact: critical, impact: low, etc.)
- State labels (state: triage, state: confirmed, etc.)
- Resolution labels
- Dependabot ecosystem labels
- Type labels (type: feature, type: bug, …)

More details can be found in [WORKFLOWS.md](WORKFLOWS.md) and the labels section of [CONTRIBUTING.md](CONTRIBUTING.md).

<h2>Security by Design</h2>

Security is a core organisational principle.

- All commits must be signed
- All workflows follow principle of least privilege
- Default permissions are read-only unless escalated by consumer workflows
- All reusable workflows include explicit input validation and guardrails
- Public vulnerability handling is documented in [SECURITY.md](SECURITY.md)

A deeper architectural overview is provided in the [SECURITY_ARCHITECTURE.md](SECURITY_ARCHITECTURE.md).

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

We welcome all contributions — code, documentation, testing, or design.

Review:

- [CONTRIBUTING.md](CONTRIBUTING.md)
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)

Before sending a pull request.

<h2>Security Reporting</h2>

Never open a public issue for a vulnerability.

See:

[SECURITY.md](SECURITY.md)

for the correct reporting channel.

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

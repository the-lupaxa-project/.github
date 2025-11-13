<!-- markdownlint-disable -->
<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/org-logos/master/orgs/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" width="256" />
    </a>
</p>

<h3 align="center">
    The Lupaxa Project — .github Repository
</h3>

<hr style="width: 50%; height: 1px; margin: 1em auto 0.5em;">
<!-- markdownlint-enable -->

### Overview

This repository defines the **shared standards, documentation, and automation resources** used across all **public repositories** in
**The Lupaxa Project** organization.

It serves as the **central hub** for community policies, contribution guidelines, security practices, and optional CI/CD workflows that embody our
*Security by Design* and *Open Source with Integrity* principles.

### Purpose

The `.github` repository provides:

- **Organization-wide defaults**  
  Issue templates, PR templates, and global documentation automatically inherited by all Lupaxa **public repositories**.

- **Centralized policies**  
  The official Code of Conduct, Contributing Guide, and Security Policy shared across every project.

- **Organization profile**  
  The public [organization profile README](https://github.com/the-lupaxa-project) displayed on GitHub.

- **Reusable automation**  
  Global GitHub Actions, workflow templates, and composite actions for consistent CI/CD pipelines across every project.

### How GitHub Uses This Repo

GitHub automatically recognizes and applies certain files from the organization’s `.github` repository across all **public repositories**:

| File / Folder          | Purpose                                          |
| :--------------------- | :----------------------------------------------- |
| profile/README.md      | Appears on the organization’s public profile.    |
| CODE_OF_CONDUCT.md     | Linked automatically in all repositories.        |
| CONTRIBUTING.md        | Used as the default contribution guide.          |
| SECURITY.md            | Linked under "Report a vulnerability".           |
| ISSUE_TEMPLATE/        | Shared issue templates for the entire org.       |
| PULL_REQUEST_TEMPLATE/ | Shared PR templates for consistent submissions.  |
| .github/workflows/     | Provides reusable workflows for CI/CD.           |

Individual repositories can override any of these by including their own copies.

### Reusable CI/CD Workflows

This `.github` repository also acts as a **central catalog of reusable workflows** for linting, security scanning, and general CI hygiene.

There are three layers:

1. **Reusable workflows (per tool)**  
   - Live in this repo: `.github/workflows/reusable-*.yml`  
   - Called by other repos via `uses: the-lupaxa-project/.github/...@master`

2. **Local workflows (per tool)**  
   - Live in **each** repo that wants a direct one-off job: `.github/workflows/local-*.yml`  
   - Use `uses: ./.github/workflows/reusable-*.yml` to call the shared logic.

3. **Combined "bundle" workflows**  
   - For example, a "docs lint" bundle that runs Markdown, YAML, and shell checks together.

### SHA Pinning Policy

All Lupaxa organizations enforce a rule that **3rd party workflows must be referenced using a full commit SHA**, never a branch or tag.

There is one deliberate exception:

Calls to the-lupaxa-project/.github/.github/workflows/*.yml are explicitly allow-listed in the security-hardening configuration.

This allows all Lupaxa repos to reference organization workflows using @master, for example:

```yml
  uses: the-lupaxa-project/.github/.github/workflows/reusable-markdown-lint.yml@master
```

This gives you:

- Automatic updates to shared workflows via the .github repo.
- Strong SHA pinning for all other third-party actions.

### Workflow Catalog

Please refer to [WORKFLOWS.md](WORKFLOWS.md) for details on all the available reusable workflows.

### Extending or Overriding Defaults

Projects within The Lupaxa Project inherit these organizational files automatically.
However, maintainers can override or extend them when necessary:

- Custom CONTRIBUTING.md — additional testing or workflow steps.
- Custom SECURITY.md — defining project-specific scope or contact options.
- Extra issue templates — for highly specialized tools.
- Repo-specific workflows — custom build/test pipelines layered on top of reusable ones.
- Per-repo lint configs (for example .markdownlint.yaml, .yamllint.yaml) — to fine-tune local rules.

Repositories overriding central files should retain references back to the organization-wide versions to preserve visibility and intent.

#### Example:

```text
This repository extends the Lupaxa Project Contributing Guidelines.
```

### Community Standards

All repositories under The Lupaxa Project follow these shared principles:

- Code of Conduct￼
- Contributing Guidelines￼
- Security Policy￼

These documents define how we collaborate respectfully, build securely, and contribute effectively across every Lupaxa project.

### License

All files within this repository are provided under the MIT License, unless otherwise noted in specific project repositories.

<!-- markdownlint-disable -->

<hr style="width: 50%; height: 1px; margin: 1em auto 0.5em;">
<p align="center">
    <em>
        The Lupaxa Project — Open Source, Secure by Design, Guided by Integrity.
    </em>
</p>
<!-- markdownlint-enable -->

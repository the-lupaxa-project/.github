<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/org-logos/master/orgs/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" width="256" />
    </a>
</p>

<h1 align="center">
    The Lupaxa Project: The <em>.github</em> Repository
</h1>

<h2>
    Overview
</h2>

This repository defines the **shared standards, documentation, and automation resources** used across all repositories in **The Lupaxa Project** organisation.

> [!NOTE]
> Automation resources (reusable workflows) are also used by all repositories in associated organisations.

It serves as the **central hub** for community policies, contribution guidelines, security practices, and optional CI/CD workflows that embody our
*Security by Design* and *Open Source with Integrity* principles.

<h2>
    Purpose
</h2>

This repository provides:

- **Organisation-wide defaults**  
  Issue templates, Pull Request (PR) templates, and global documentation automatically inherited by all Lupaxa Project repositories.

- **Centralized policies**  
  The official [Code of Conduct](CODE_OF_CONDUCT.md), [Contributing Guide](CONTRIBUTING.md), and [Security Policy](SECURITY.md) for The Lupaxa Project.

- **Organisation profile**  
  The public [organisation profile README](https://github.com/the-lupaxa-project) displayed on GitHub.

- **Reusable automation**  
  Global GitHub Actions, workflow templates, and composite actions for consistent CI/CD pipelines.

<h2>
    How GitHub Uses This Repo
</h2>

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

<h3>
    Extending or Overriding Defaults
</h3>

Projects within The Lupaxa Project inherit these organizational files automatically.
However, maintainers can override or extend them when necessary:

- Custom CONTRIBUTING.md — additional testing or workflow steps.
- Custom SECURITY.md — defining project-specific scope or contact options.
- Extra issue templates — for highly specialized tools.
- Repo-specific workflows — custom build/test pipelines layered on top of reusable ones.
- Per-repo lint configs (for example .markdownlint.yaml, .yamllint.yaml) — to fine-tune local rules.

Repositories overriding central files should retain references back to the organization-wide versions to preserve visibility and intent.

<h4>
    Example:
</h4>

```text
This repository extends the Lupaxa Project Contributing Guidelines.
```

<h2>
    Reusable CI/CD Workflows
</h2>

This repository also acts as a **central catalog of reusable workflows** for linting, security scanning, and general CI hygiene.

There are three layers:

1. **Reusable workflows**
   - Live in this repo: `.github/workflows/reusable-*.yml`  
   - Called by other repos via `uses: the-lupaxa-project/.github/...@master`

2. **Local workflows**
   - Live in this repo: `.github/workflows/local-*.yml`  
   - Use `uses: ./.github/workflows/reusable-*.yml` to call the shared logic.

3. **Combined "bundle" workflows**
   - For example, a "docs lint" bundle that runs Markdown, YAML, and shell checks together.

<h2>
    SHA Pinning Policy
</h2>

All Lupaxa Project organisations enforce a rule that **3<sup>rd</sup> party workflows must be referenced using a full commit SHA**, never a branch or tag.

***There is one deliberate exception:***

Calls to the-lupaxa-project/.github/.github/workflows/*.yml are explicitly allow-listed in the security-hardening configuration.

This allows all Lupaxa repos to reference organisation workflows using @master, for example:

```yml
  uses: the-lupaxa-project/.github/.github/workflows/reusable-markdown-lint.yml@master
```

This gives you:

- Automatic updates to shared workflows via the .github repo, which is in turn updated automatically by dependabot.
- Strong SHA pinning for all other third-party actions.

<h2>
    Workflow Catalog
</h2>

Please refer to [WORKFLOWS.md](WORKFLOWS.md) for details on all the available reusable workflows.

<h2>
    Community Standards
</h2>

All repositories under The Lupaxa Project follow these shared principles:

- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Security Policy](SECURITY.md)

These documents define how we collaborate respectfully, build securely, and contribute effectively across every Lupaxa project.

<h2>
    License
</h2>

All files within The Lupaxa Project are provided under the [MIT License](LICENSE.md), unless otherwise noted in specific project repositories.

<hr>

<p align="center">
    <em>
        &copy; The Lupaxa Project: Where Wild Instinct Meets Structured Intelligence.
    </em>
</p>

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
  The official Code of Conduct, Contributing Guide, and Security Policy shared across every **public project**.

- **Organization profile**  
  The public [organization profile README](https://github.com/the-lupaxa-project) displayed on GitHub.

- **Reusable automation**  
  Global GitHub Actions, workflow templates, and composite actions for consistent CI/CD pipelines across every **public project**.

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
   - Called by other repos via `uses: the-lupaxa-project/.github/...@<COMMIT_SHA>`

2. **Local workflows (per tool)**  
   - Live in **each** repo that wants a direct one-off job: `.github/workflows/local-*.yml`  
   - Use `uses: ./.github/workflows/reusable-*.yml` to call the shared logic.

3. **Combined “bundle” workflows**  
   - For example, a “docs lint” bundle that runs Markdown, YAML, and shell checks together.

### SHA Pinning Policy

All Lupaxa organizations enforce a rule that **reusable workflows must be referenced using a full commit SHA**, never a branch or tag.

**Within this `.github` repo** (self-use):

```yaml
jobs:
  markdown:
    uses: ./.github/workflows/reusable-markdown-lint.yml
```

From other repositories (remote use):

```yaml
jobs:
  markdown:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-markdown-lint.yml@<COMMIT_SHA>
```

> Replace <COMMIT_SHA> with the commit hash of this .github repository that you wish to pin to (for example, from git rev-parse HEAD or the GitHub UI).

### Workflow Catalog (CICDToolbox Tools)

The following reusable workflows wrap tools from the CICDToolbox￼ organization.
Each one runs the tool’s pipeline.sh script and shares a common interface.

#### Common Inputs

All per-tool reusable workflows accept the same core inputs:

- include_files — optional, comma-separated list of paths/globs/regex to include.
- exclude_files — optional, comma-separated list of paths/globs/regex to exclude.
- report_only — true/false, report issues without failing the job.
- show_errors — true/false, show detailed errors.
- show_skipped — true/false, show skipped/ignored files.
 no_color — true/false, disable coloured output.

These map to environment variables like INCLUDE_FILES, EXCLUDE_FILES, REPORT_ONLY, SHOW_ERRORS, SHOW_SKIPPED, NO_COLOR that all CICDToolbox tools understand.

#### Catalog Overview

| Tool / Domain       | CICDToolbox Repo        | Reusable Workflow File               | Typical include_files                |
| :------------------ | :---------------------- | :----------------------------------- | :----------------------------------- |
| GitHub Actions      | action-lint             | reusable-action-lint.yml             | .github/workflows/*.yml              |
| Links in Markdown   | awesomebot              | reusable-awesomebot.yml              | **/*.md                              |
| Python security     | bandit                  | reusable-bandit.yml                  | **/*.py                              |
| Dockerfiles         | hadolint                | reusable-hadolint.yml                | Dockerfile,**/Dockerfile*            |
| JSON config         | json-lint               | reusable-json-lint.yml               | **/*.json                            |
| Markdown            | markdown-lint           | reusable-markdown-lint.yml           | **/*.md                              |
| Perl                | perl-lint               | reusable-perl-lint.yml               | **/*.pl,**/*.pm                      |
| PHP                 | php-lint                | reusable-php-lint.yml                | **/*.php                             |
| Puppet              | puppet-lint             | reusable-puppet-lint.yml             | **/*.pp                              |
| Python requirements | pur                     | reusable-pur.yml                     | requirements.txt                     |
| Python style        | pycodestyle             | reusable-pycodestyle.yml             | **/*.py                              |
| Python docstrings   | pydocstyle              | reusable-pydocstyle.yml              | **/*.py                              |
| Python meta-linter  | pylama                  | reusable-pylama.yml                  | **/*.py                              |
| Python linting      | pylint                  | reusable-pylint.yml                  | **/*.py                              |
| Ruby code smells    | reek                    | reusable-reek.yml                    | **/*.rb                              |
| Ruby style          | rubocop                 | reusable-rubocop.yml                 | **/*.rb                              |
| Shell scripts       | shellcheck              | reusable-shellcheck.yml              | **/*.sh,**/*.bash,**/*.ksh,**/*.dash |
| Citation metadata   | validate-citations-file | reusable-validate-citations-file.yml | CITATION.cff                         |
| YAML config         | yaml-lint               | reusable-yaml-lint.yml               | **/*.yml,**/*.yaml                   |

### Examples (Reusable + Local + Combined)

#### Example 1 — Using a reusable workflow from another repo

In any repo under The Lupaxa Project, you can call a reusable workflow like this:

```yaml
name: Docs Lint

on:
  pull_request:
  push:
    branches:
      - main
      - master

jobs:
  markdown:
    name: Markdown Lint
    uses: the-lupaxa-project/.github/.github/workflows/reusable-markdown-lint.yml@<COMMIT_SHA>
    permissions:
      contents: read
    with:
      include_files: "**/*.md"
      report_only: false
      show_errors: true

  yaml:
    name: YAML Lint
    uses: the-lupaxa-project/.github/.github/workflows/reusable-yaml-lint.yml@<COMMIT_SHA>
    permissions:
      contents: read
    with:
      include_files: |
        **/*.yml
        **/*.yaml"
      report_only: false
```

You can add as many jobs as you like for different tools:

```yaml
  shellcheck:
    name: ShellCheck
    uses: the-lupaxa-project/.github/.github/workflows/reusable-shellcheck.yml@<COMMIT_SHA>
    permissions:
      contents: read
    with:
      include_files: |
        **/*.sh
        **/*.bash
        **/*.dash
        **/*.ksh
```

#### Example 2 — Local workflow that calls the shared ones

Sometimes you want a single repo-local workflow file that orchestrates several tools.
In that case, your repo can have:

```yaml
name: Local Docs Lint

on:
  pull_request:
  push:
    branches:
      - main
      - master

jobs:
  markdown:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-markdown-lint.yml@<COMMIT_SHA>
    permissions:
      contents: read
    with:
      include_files: "**/*.md"

  yaml:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-yaml-lint.yml@<COMMIT_SHA>
    permissions:
      contents: read
    with:
      include_files: |
        **/*.yml
        **/*.yaml
```

You might also create repo-specific variants like local-python-quality.yml that call reusable-bandit.yml and reusable-pylint.yml in a similar fashion.

#### Example 3 — Combined “all linters” workflow

In the .github repo itself, you can maintain a combined reusable bundle, for example:

- reusable-docs-lint.yml — orchestrates Markdown, YAML, and Shellcheck.
- reusable-python-quality.yml — orchestrates Bandit, Pylint, Pydocstyle, etc.
- reusable-ruby-quality.yml — orchestrates Rubocop + Reek.
- reusable-all-linters.yml — runs everything for “belt and braces” checks.

Other repos then call them like this:

```yaml
name: Full Quality Gate

on:
  pull_request:
  push:
    branches:
      - main
      - master

jobs:
  docs:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-docs-lint.yml@<COMMIT_SHA>
    permissions:
      contents: read

  python:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-python-quality.yml@<COMMIT_SHA>
    permissions:
      contents: read

  ruby:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-ruby-quality.yml@<COMMIT_SHA>
    permissions:
      contents: read
```

The exact set of combined workflows (and their filenames) is intentionally flexible; the .github repo is the place where those “house styles” live.

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

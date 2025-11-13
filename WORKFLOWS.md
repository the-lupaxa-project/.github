<!-- markdownlint-disable -->
<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/org-logos/master/orgs/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" width="256" />
    </a>
</p>

<h3 align="center">
    The Lupaxa Project — Workflow Catalog
</h3>

<hr style="width: 50%; height: 1px; margin: 1em auto 0.5em;">
<!-- markdownlint-enable -->

### Overview

This document describes the shared GitHub Actions workflows provided by  
The Lupaxa Project via the .github repository.

It covers:

- The SHA pinning policy for reusable workflows.
- Naming conventions for reusable and local workflows.
- A catalog of CICDToolbox-based workflows and their capabilities.
- Practical usage examples for consuming repositories.

All workflows are designed to be:

- Reusable across all Lupaxa repos.
- Secure by default (no unpinned actions).
- Consistent with organizational linting and documentation standards.

### SHA Pinning and Usage Models

#### SHA pinning policy

All Lupaxa organizations enforce strict SHA pinning for reusable workflows.
Branch names (main, master) and version tags are **NOT** permitted.

#### Using workflows within this repository

```yaml
jobs:
  example:
    uses: ./.github/workflows/reusable-markdown-lint.yml
```

#### Using workflows from another organization repo

```yaml
jobs:
  example:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-markdown-lint.yml@<COMMIT_SHA>
```

> Replace <COMMIT_SHA> with the actual commit hash of the .github repository.

### Naming Conventions

#### Reusable workflows

- Stored under: .github/workflows/
- Naming pattern: reusable-NAME.yml
- Example: reusable-markdown-lint.yml

#### Local workflows

- Defined in consuming repositories.
- Naming pattern: local-NAME.yml
- Example: local-quality-checks.yml

#### Bundle workflows

- Combine multiple reusable workflows.
- Example: reusable-docs-lint.yml (Markdown + YAML + Shell)

### CICDToolbox-based Reusable Workflows

All reusable workflows:

- Wrap CICDToolbox repos.
- Execute the tool’s pipeline.sh.
- Accept standard inputs:
  - include_files
  - exclude_files
  - report_only
  - show_errors
  - show_skipped
  - no_color

These map to environment variables expected by pipeline.sh.

### Catalog Overview

| Workflow file                        | CICDToolbox repo        | Purpose                          |
| ------------------------------------ | ----------------------- | -------------------------------- |
| reusable-action-lint.yml             | action-lint             | Lint GitHub Actions workflows.   |
| reusable-awesomebot.yml              | awesomebot              | Validate Markdown links.         |
| reusable-bandit.yml                  | bandit                  | Python security scanning.        |
| reusable-hadolint.yml                | hadolint                | Dockerfile linting.              |
| reusable-json-lint.yml               | json-lint               | JSON linting.                    |
| reusable-markdown-lint.yml           | markdown-lint           | Markdown linting.                |
| reusable-perl-lint.yml               | perl-lint               | Perl linting.                    |
| reusable-php-lint.yml                | php-lint                | PHP linting.                     |
| reusable-puppet-lint.yml             | puppet-lint             | Puppet manifest linting.         |
| reusable-pur.yml                     | pur                     | Update Python requirements.      |
| reusable-pycodestyle.yml             | pycodestyle             | Python style checking.           |
| reusable-pydocstyle.yml              | pydocstyle              | Python docstring style checking. |
| reusable-pylama.yml                  | pylama                  | Python meta-linting.             |
| reusable-pylint.yml                  | pylint                  | Python linting.                  |
| reusable-reek.yml                    | reek                    | Ruby code smell analysis.        |
| reusable-rubocop.yml                 | rubocop                 | Ruby linting and formatting.     |
| reusable-shellcheck.yml              | shellcheck              | Shell script linting.            |
| reusable-validate-citations-file.yml | validate-citations-file | Validate CITATION.cff files.     |
| reusable-yaml-lint.yml               | yaml-lint               | YAML linting.                    |

### Usage Examples

All examples assume usage from another repository with SHA pinning.

#### Markdown Lint

```yaml
jobs:
  markdown:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-markdown-lint.yml@<COMMIT_SHA>
    with:
      include_files: **/*.md
```

#### YAML Lint

```yaml
jobs:
  yaml:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-yaml-lint.yml@<COMMIT_SHA>
    with:
      include_files: **/*.yml,**/*.yaml
```

#### Action Lint

```yaml
jobs:
  actionlint:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-action-lint.yml@<COMMIT_SHA>
```

#### ShellCheck

```yaml
jobs:
  shellcheck:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-shellcheck.yml@<COMMIT_SHA>
    with:
      include_files: **/*.sh
```

#### Bandit

```yaml
jobs:
  bandit:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-bandit.yml@<COMMIT_SHA>
```

#### JSON Lint

```yaml
jobs:
  json:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-json-lint.yml@<COMMIT_SHA>
```

#### Rubocop

```yaml
jobs:
  rubocop:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-rubocop.yml@<COMMIT_SHA>
```

#### Reek

```yaml
jobs:
  reek:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-reek.yml@<COMMIT_SHA>
```

#### Citation File Validation

```yaml
jobs:
  citation:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-validate-citations-file.yml@<COMMIT_SHA>
    with:
      include_files: CITATION.cff
```

### Bundle Workflows

#### Example: reusable-docs-lint.yml

```yaml
jobs:
  docs:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-docs-lint.yml@<COMMIT_SHA>
```

<!-- markdownlint-disable -->
<hr style="width: 50%; height: 1px; margin: 1em auto 0.5em;">
<p align="center">
    <em>The Lupaxa Project — Open Source, Secure by Design, Guided by Integrity.</em>
</p>
<!-- markdownlint-enable -->
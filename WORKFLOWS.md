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

This document describes the shared GitHub Actions reusable workflows provided by
The Lupaxa Project via the .github repository.

It covers:

- The branch / SHA policy for reusable workflows.
- Naming conventions for reusable and local workflows.
- A catalog of CICDToolbox-based and core governance / maintenance workflows.
- Detailed, copy-paste-ready usage examples for every reusable workflow.

All workflows are designed to be:

- Reusable across all Lupaxa repositories and organizations.
- Secure by default, with strong controls around third-party actions.
- Consistent with organizational linting, documentation, and security standards.

### Branch / SHA Policy and Security Hardening

#### General policy

Across most Lupaxa repositories, we require external actions to be pinned to a specific commit SHA.

To help enforce this, we provide:

- reusable-ensure-sha-pinned-actions.yml — a reusable workflow powered by zgosalvez/github-actions-ensure-sha-pinned-actions.
- Local security-hardening workflows in consuming repos that call this reusable workflow.

These security-hardening workflows:

- Scan all workflow files under .github/workflows/.
- Fail the build if they detect uses: entries that:
  - Point to external repos without @&lt;SHA&gt;, or
  - Use @main, @master, or version tags that are not allow-listed.

There is one deliberate exception:

Calls to the-lupaxa-project/.github/.github/workflows/*.yml are explicitly allow-listed in the security-hardening configuration.

This allows all Lupaxa repos to reference organization workflows using @master, for example:

```yml
  uses: the-lupaxa-project/.github/.github/workflows/reusable-markdown-lint.yml@master
```

This gives you:

- Automatic updates to shared workflows via the .github repo.
- Strong SHA pinning for all other third-party actions.

### Naming Conventions

#### Reusable workflows

- Location: .github/workflows/
- Naming pattern: reusable-NAME.yml
- Purpose: reusable primitives and bundles that other repos call.

##### Reusable Example:

- reusable-markdown-lint.yml
- reusable-yaml-lint.yml
- reusable-codeql.yml

#### Local workflows

- Location: .github/workflows/ in a consuming repository.
- Naming pattern: local-NAME.yml
- Purpose: thin orchestration wrappers that:
- Define triggers (on:),
- Group jobs logically,
- Call one or more reusable-*.yml workflows via uses:.

##### Local Example:

- local-docs-lint.yml
- local-security-hardening.yml

### CICDToolbox-based Reusable Workflows

These workflows wrap tools from the CICDToolbox￼ GitHub organization￼ and all follow the same pattern:

- They call the tool’s pipeline.sh via curl | bash.
- They accept the standard inputs:
  - include_files — comma-separated paths / globs / regex (tool-specific).
  - exclude_files — comma-separated paths / globs / regex to skip.
  - report_only — if true, do not fail the build even on errors.
  - show_errors — show detailed error output.
  - show_skipped — show skipped files.
  - no_color — disable coloured output.

These map to environment variables used by CICDToolbox pipelines:

- INCLUDE_FILES
- EXCLUDE_FILES
- REPORT_ONLY
- SHOW_ERRORS
- SHOW_SKIPPED
- NO_COLOR

#### Catalog — CICDToolbox-based Workflows

| Workflow file                              | Purpose                               | Example                                     |
| :----------------------------------------- | :------------------------------------ | :-----------------------------------------: |
| [reusable-awesomebot.yml][1]               | Check Markdown links.                 | [Example](#markdown-link-checking)          |
| [reusable-bandit.yml][2]                   | Python security scanning.             | [Example](#python-security-bandit)          |
| [reusable-hadolint.yml][3]                 | Dockerfile linting.                   | [Example](#dockerfile-linting)              |
| [reusable-json-lint.yml][4]                | JSON linting.                         | [Example](#json-linting)                    |
| [reusable-markdown-lint.yml][5]            | Markdown linting.                     | [Example](#markdown-linting)                |
| [reusable-perl-lint.yml][6]                | Perl linting.                         | [Example](#perl-linting)                    |
| [reusable-php-lint.yml][7]                 | PHP linting.                          | [Example](#php-linting)                     |
| [reusable-puppet-lint.yml][8]              | Puppet manifest linting.              | [Example](#puppet-manifest-linting)         |
| [reusable-pur.yml][9]                      | Update Python requirements.           | [Example](#python-requirements-updates-pur) |
| [reusable-pycodestyle.yml][10]             | Python style checking (PEP 8).        | [Example](#python-style-pycodestyle)        |
| [reusable-pydocstyle.yml][11]              | Python docstring style checking.      | [Example](#python-docstrings-pydocstyle)    |
| [reusable-pylama.yml][12]                  | Python meta-linting (Pylama).         | [Example](#python-meta-linting-pylama)      |
| [reusable-pylint.yml][13]                  | Python linting (Pylint).              | [Example](#python-linting-pylint)           |
| [reusable-reek.yml][14]                    | Ruby code smell analysis.             | [Example](#ruby-code-smells-reek)           |
| [reusable-rubocop.yml][15]                 | Ruby linting and formatting.          | [Example](#ruby-linting-rubocop)            |
| [reusable-shellcheck.yml][16]              | Shell script linting.                 | [Example](#shell-script-linting)            |
| [reusable-validate-citations-file.yml][17] | Validate CITATION.cff metadata files. | [Example](#citation-file-validation)        |
| [reusable-yaml-lint.yml][18]               | YAML linting.                         | [Example](#yaml-linting)                    |

[1]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-awesomebot.yml
[2]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-bandit.yml
[3]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-hadolint.yml
[4]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-json-lint.yml
[5]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-markdown-lint.yml
[6]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-perl-lint.yml
[7]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-php-lint.yml
[8]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-puppet-lint.yml
[9]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-pur.yml
[10]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-pycodestyle.yml
[11]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-pydocstyle.yml
[12]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-pylama.yml
[13]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-pylint.yml
[14]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-reek.yml
[15]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-rubocop.yml
[16]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-shellcheck.yml
[17]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-validate-citations-file.yml
[18]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-yaml-lint.yml

### Core Governance & Maintenance Workflows

These workflows are not CICDToolbox-based, but provide core services like dependency updates, stale handling, CodeQL analysis, and security-hardening.

#### Catalog — Core Workflows

| Workflow file                                     | Purpose                                                                                             | Example                                   |
| :------------------------------------------------ | :-------------------------------------------------------------------------------------------------- | :---------------------------------------: |
| [reusable-codeql.yml][20]                         | CodeQL security and quality scanning.                                                               | [Example](#codeql-security-and-quality)   |
| [reusable-dependabot.yml][21]                     | Wrapper to standardise Dependabot config across repos.                                              | [Example](#dependabot-standardisation)    |
| [reusable-docs-lint.yml][22]                      | Bundle: Markdown + YAML docs linting.                                                               | [Example](#docs-bundle-markdown-and-yaml) |
| [reusable-ensure-sha-pinned-actions.yml][23]      | Enforce SHA-pinned actions, with an allow-list for the-lupaxa-project/.github workflows on @master. | [Example](#enforce-sha-pinned-actions)    |
| [reusable-greetings.yml][24]                      | Greet first-time issue and PR authors.                                                              | [Example](#first-interaction-greetings)   |
| [reusable-purge-deprecated-workflow-runs.yml][25] | Purge obsolete / cancelled / failed / skipped workflow runs.                                        | [Example](#purge-old-workflow-runs)       |
| [reusable-stale.yml][26]                          | Mark and close stale issues/PRs.                                                                    | [Example](#stale-issues-and-prs)          |

[20]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-codeql.yml
[21]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-dependabot.yml
[22]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-docs-lint.yml
[23]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-ensure-sha-pinned-actions.yml
[24]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-greetings.yml
[25]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-purge-deprecated-workflow-runs.yml
[26]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-stale.yml

### Detailed Usage Examples (Alphabetical by Workflow File)

All examples assume you are calling from another repo in the organization and using:

```yaml
uses: the-lupaxa-project/.github/.github/workflows/<reusable-workflow>.yml@master
```

You can adapt triggers (on:), paths, and inputs for your specific project.

#### Markdown Link Checking

Check for broken links in Markdown files using CICDToolbox/awesomebot.

```yaml
name: Markdown Link Check

on:
  pull_request:
    paths:
      - "**/*.md"
  push:
    branches:
      - "**"
  paths:
    - "**/*.md"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  awesomebot:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-awesomebot.yml@master
```

#### Python Security (Bandit)

Run Bandit security scans on Python files.

```yaml
name: Python Security (Bandit)

on:
  pull_request:
    paths:
      - "**/*.py"
  push:
    branches:
      - "**"
    paths:
      - "**/*.py"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  bandit:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-bandit.yml@master
```

#### CodeQL Security and Quality

Standardised CodeQL setup for one or more languages.

```yaml
name: CodeQL Analysis

on:
  push:
    branches-ignore:
      - "dependabot/"
    paths-ignore:
      - "**/*.md"
      - "**/*.cff"
  pull_request:
    branches:
      - "**"
  paths-ignore:
    - "**/*.md"
    - "**/*.cff"
  schedule:
    - cron: "4 3 * * 1"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  actions: read
  contents: read
  security-events: write

jobs:
  codeql:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-codeql.yml@master
    with:
      languages: "python,javascript"
```

#### Dependabot Standardisation

Run a common Dependabot configuration (when orchestrated via Actions).

```yaml
name: Dependabot

on:
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

jobs:
  dependabot:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-dependabot.yml@master
```

#### Docs Bundle (Markdown and YAML)

Run both Markdown and YAML lint in one call.

```yaml
name: Documentation Lint (Markdown + YAML)

on:
  pull_request:
  push:
    branches:
      - "**"
  workflow_dispatch:

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  docs:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-docs-lint.yml@master
```

#### Enforce SHA-Pinned Actions

Used by local "security hardening" workflows to enforce SHA pinning.

```yaml
name: Ensure SHA-Pinned Actions

on:
  pull_request:
    paths:
      - ".github/workflows/*.yml"
      - ".github/workflows/*.yaml"
  push:
    branches:
      - "**"
    paths:
      - ".github/workflows/*.yml"
      - ".github/workflows/*.yaml"
  workflow_dispatch:

jobs:
  ensure-sha:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-ensure-sha-pinned-actions.yml@master
```

#### First Interaction Greetings

Greet first-time issue / PR authors using actions/first-interaction.

```yaml
name: Greetings

on:
  pull_request:
  issues:
  workflow_dispatch:

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  issues: write
  pull-requests: write

jobs:
  greetings:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-greetings.yml@master
    secrets:
      repo-token: ${{ secrets.GITHUB_TOKEN }}
```

#### Dockerfile Linting

Lint Dockerfiles with hadolint.

```yaml
name: Dockerfile Lint (Hadolint)

on:
  pull_request:
    paths:
      - "Dockerfile"
      - "**/Dockerfile*"
  push:
    branches:
      - "**"
    paths:
      - "Dockerfile"
      - "**/Dockerfile*"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  hadolint:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-hadolint.yml@master
```

#### JSON Linting

Lint JSON configuration files.

```yaml
name: JSON Lint

on:
  pull_request:
    paths:
      - "**/*.json"
  push:
    branches:
      - "**"
    paths:
      - "**/*.json"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  json:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-json-lint.yml@master
```

#### Markdown Linting

Run Markdown lint checks via CICDToolbox/markdown-lint.

```yaml
name: Markdown Lint

on:
  pull_request:
    paths:
      - "**/*.md"
  push:
    branches:
      - "**"
    paths:
      - "**/*.md"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  markdown:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-markdown-lint.yml@master
```

#### Perl Linting

Lint Perl scripts and modules.

```yaml
name: Perl Lint

  on:
    pull_request:
      paths:
        - "**/*.pl"
        - "**/*.pm"
    push:
      branches:
        - "**"
      paths:
        - "**/*.pl"
        - "**/*.pm"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  perl-lint:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-perl-lint.yml@master
```

#### PHP Linting

Lint PHP files.

```yaml
name: PHP Lint

on:
  pull_request:
    paths:
      - "**/*.php"
  push:
    branches:
      - "**"
    paths:
      - "**/*.php"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  php-lint:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-php-lint.yml@master
```

#### Puppet Manifest Linting

Lint Puppet .pp manifests.

```yaml
name: Puppet Lint

on:
  pull_request:
    paths:
      - "**/*.pp"
  push:
    branches:
      - "**"
    paths:
      - "**/*.pp"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  puppet-lint:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-puppet-lint.yml@master
```

#### Python Requirements Updates (pur)

Run pur to update requirements.txt style files.

```yaml
name: Python Requirements (pur)

on:
  pull_request:
    paths:
      - "**/*.py"
      - "**/requirements.txt"
  push:
    branches:
      - "**"
    paths:
      - "**/*.py"
      - "**/*.requirements.txt"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: write

jobs:
  pur:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-pur.yml@master
```

#### Purge Old Workflow Runs

Purge obsolete, cancelled, failed, or skipped workflow runs using otto-de/purge-deprecated-workflow-runs.

```yaml
name: Purge Deprecated Workflow Runs

on:
  workflow_dispatch:
    schedule:
      - cron: "33 3 * * 1"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  actions: write

jobs:
  purge-deprecated-workflows:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-purge-deprecated-workflow-runs.yml@master
```

#### Python Style (pycodestyle)

PEP 8 style checking via pycodestyle.

```yaml
name: Python Style (pycodestyle)

on:
  pull_request:
    paths:
      - "**/*.py"
  push:
    branches:
      - "**"
    paths:
      - "**/*.py"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  pycodestyle:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-pycodestyle.yml@master
```

#### Python Docstrings (pydocstyle)

Docstring style enforcement.

```yaml
name: Python Docstrings (pydocstyle)

on:
  pull_request:
    paths:
      - "**/*.py"
  push:
    branches:
      - "**"
    paths:
      - "**/*.py"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  pydocstyle:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-pydocstyle.yml@master
```

#### Python Meta-Linting (Pylama)

Aggregate linting via pylama.

```yaml
name: Python Meta Lint (Pylama)

on:
  pull_request:
    paths:
      - "**/*.py"
  push:
    branches:
      - "**"
    paths:
    - "**/*.py"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  pylama:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-pylama.yml@master
```

#### Python Linting (Pylint)

Run pylint against Python code.

```yaml
name: Python Lint (Pylint)

on:
  pull_request:
    paths:
      - "**/*.py"
  push:
    branches:
      - "**"
    paths:
      - "**/*.py"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  pylint:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-pylint.yml@master
```

#### Ruby Code Smells (Reek)

Detect Ruby code smells via Reek.

```yaml
name: Ruby Code Smells (Reek)

on:
  pull_request:
    paths:
      - "**/*.rb"
  push:
    branches:
      - "**"
    paths:
      - "**/*.rb"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  reek:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-reek.yml@master
```

#### Ruby Linting (Rubocop)

Ruby style and lint checks.

```yaml
name: Ruby Lint (Rubocop)

on:
  pull_request:
    paths:
      - "**/*.rb"
  push:
    branches:
      - "**"
    paths:
      - "**/*.rb"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  rubocop:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-rubocop.yml@master
```

#### Shell Script Linting

Lint shell scripts via ShellCheck.

```yaml
name: ShellCheck

on:
  pull_request:
    paths:
      - "**/*.sh"
      - "**/*.bash"
      - "**/*.ksh"
      - "**/*.dash"
  push:
    branches:
      - "**"
    paths:
      - "**/*.sh"
      - "**/*.bash"
      - "**/*.ksh"
      - "**/*.dash"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  shellcheck:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-shellcheck.yml@master
```

#### Stale Issues and PRs

Mark stale issues/PRs and close them after a grace period.

```yaml
name: Stale Issue & PR Handler

on:
  schedule:
    - cron: "35 5 * * *"
  workflow_dispatch:

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: write
  issues: write
  pull-requests: write

jobs:
  stale:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-stale.yml@master
```

#### CITATION File Validation

Validate CITATION.cff files via validate-citations-file.

```yaml
name: Citation File Validation

on:
  pull_request:
    paths:
      - "CITATION.cff"
  push:
    branches:
      - "**"
    paths:
      - "CITATION.cff"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  citations:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-validate-citations-file.yml@master
```

#### YAML Linting

YAML linting using CICDToolbox/yaml-lint and your repo’s .yamllint.yml.

```yaml
name: YAML Lint

on:
  pull_request:
    paths:
      - "**/*.yml"
      - "**/*.yaml"
  push:
    branches:
      - "**"
    paths:
      - "**/*.yml"
      - "**/*.yaml"

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  yaml:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-yaml-lint.yml@master
```

<!-- markdownlint-disable -->


<hr style="width: 50%; height: 1px; margin: 1em auto 0.5em;">
<p align="center">
    <em>
        The Lupaxa Project — Open Source, Secure by Design, Guided by Integrity.
    </em>
</p>
<!-- markdownlint-enable -->

<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/org-logos/master/orgs/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" width="256" />
    </a>
</p>

<h3 align="center">
    The Lupaxa Project — Workflow Catalog
</h3>

<hr style="width: 50%; height: 1px; margin: 1em auto 0.5em;">

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

| Workflow file                              | Purpose                                | Example                                       |
| :----------------------------------------- | :------------------------------------- | :-------------------------------------------: |
| [reusable-awesomebot.yml][1]               | Check Markdown links.                  | [Example](#markdown-link-checking-awesomebot) |
| [reusable-bandit.yml][2]                   | Python security scanning.              | [Example](#python-security-bandit)            |
| [reusable-hadolint.yml][3]                 | Dockerfile linting.                    | [Example](#dockerfile-linting-hadolint)       |
| [reusable-json-lint.yml][4]                | JSON linting.                          | [Example](#json-linting)                      |
| [reusable-markdown-lint.yml][5]            | Markdown linting.                      | [Example](#markdown-linting)                  |
| [reusable-perl-lint.yml][6]                | Perl linting.                          | [Example](#perl-linting)                      |
| [reusable-php-lint.yml][7]                 | PHP linting.                           | [Example](#php-linting)                       |
| [reusable-puppet-lint.yml][8]              | Puppet manifest linting.               | [Example](#puppet-manifest-linting)           |
| [reusable-pur.yml][9]                      | Update Python requirements.            | [Example](#python-requirements-updates-pur)   |
| [reusable-pycodestyle.yml][10]             | Python style checking (PEP 8).         | [Example](#python-style-pycodestyle)          |
| [reusable-pydocstyle.yml][11]              | Python docstring style checking.       | [Example](#python-docstrings-pydocstyle)      |
| [reusable-pylama.yml][12]                  | Python meta-linting (Pylama).          | [Example](#python-meta-linting-pylama)        |
| [reusable-pylint.yml][13]                  | Python linting (Pylint).               | [Example](#python-linting-pylint)             |
| [reusable-reek.yml][14]                    | Ruby code smell analysis.              | [Example](#ruby-code-smells-reek)             |
| [reusable-rubocop.yml][15]                 | Ruby linting and formatting.           | [Example](#ruby-linting-rubocop)              |
| [reusable-shellcheck.yml][16]              | Shell script linting.                  | [Example](#shell-script-linting)              |
| [reusable-validate-citations-file.yml][17] | Validate CITATION.cff metadata files.  | [Example](#citation-file-validation)          |
| [reusable-yaml-lint.yml][18]               | YAML linting.                          | [Example](#yaml-linting)                      |

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

| Workflow file                                     | Purpose                                                                                             | Example                                         |
| :------------------------------------------------ | :-------------------------------------------------------------------------------------------------- | :---------------------------------------------: |
| [reusable-check-job-status.yml][20]               | Validates results of upstream jobs and fails the run if any did not succeed.                        | [Example](#check-job-status)                    |
| [reusable-codeql.yml][21]                         | CodeQL security and quality scanning.                                                               | [Example](#codeql-security-and-quality)         |
| [reusable-dependabot.yml][22]                     | Wrapper to standardise Dependabot config across repos.                                              | [Example](#dependabot-standardisation)          |
| [reusable-docs-lint.yml][23]                      | Bundle: Markdown + YAML docs linting.                                                               | [Example](#docs-bundle-markdown-and-yaml)       |
| [reusable-ensure-sha-pinned-actions.yml][24]      | Enforce SHA-pinned actions, with an allow-list for the-lupaxa-project/.github workflows on @master. | [Example](#enforce-sha-pinned-actions)          |
| [reusable-generate-release.yml][25]               | Create GitHub Releases with changelog.                                                              | [Example](#generate-release)                    |
| [reusable-greetings.yml][26]                      | Greet first-time issue and PR authors.                                                              | [Example](#first-interaction-greetings)         |
| [reusable-purge-deprecated-workflow-runs.yml][27] | Purge obsolete / cancelled / failed / skipped workflow runs.                                        | [Example](#purge-old-workflow-runs)             |
| [reusable-slack-workflow-status.yml][28]          | Posts final workflow status to Slack via webhook.                                                   | [Example](#slack-workflow-status-notifications) |
| [reusable-stale.yml][29]                          | Mark and close stale issues/PRs.                                                                    | [Example](#stale-issues-and-prs)                |

[20]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-check-job-status.yml
[21]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-codeql.yml
[22]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-dependabot.yml
[23]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-docs-lint.yml
[24]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-ensure-sha-pinned-actions.yml
[25]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-generate-release.yml
[26]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-greetings.yml
[27]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-purge-deprecated-workflow-runs.yml
[28]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-slack-workflow-status.yml
[29]: https://github.com/the-lupaxa-project/.github/tree/master/.github/workflows/reusable-stale.yml

### Detailed Usage Examples (Alphabetical by Workflow File)

All examples assume you are calling from another repo in the organization and using:

```yaml
uses: the-lupaxa-project/.github/.github/workflows/<reusable-workflow>.yml@master
```

You can adapt triggers (on:), paths, and inputs for your specific project.

#### Markdown Link Checking (Awesomebot)

Reusable wrapper for the CICDToolbox awesomebot pipeline, checking Markdown links (internal and external) for breakage and basic formatting issues across your docs.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Python Security (Bandit)

Runs the CICDToolbox bandit pipeline to perform static security analysis on Python code, flagging common vulnerabilities and insecure patterns.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Check Job Status

Summarises the results of upstream jobs (success, failure, skipped, cancelled, timed_out) and fails the workflow if any required job did not succeed,
giving a single, consolidated status report.

The workflow:

- Accepts a JSON representation of the needs context.
- Uses an enhanced check-jobs.sh script to:
- List every upstream job with its result (success, failure, cancelled, skipped, or timed_out)
- Emit appropriate GitHub error/warning annotations
- Exit non-zero if any upstream job did not succeed

> IMPORTANT: this is a *job-level* uses, not under steps!

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input     | Type    | Required | Default | Description                              |
| :-------- | :------ | :------- | :------ | :--------------------------------------- |
| jobs_json | string  | Yes      |         | JSON string of job results to aggregate. |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

```yaml
name: Example with job status summary

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
  markdown:
  uses: the-lupaxa-project/.github/.github/workflows/reusable-markdown-lint.yml@master

  yaml:
  uses: the-lupaxa-project/.github/.github/workflows/reusable-yaml-lint.yml@master

  # 🔴 IMPORTANT: this is a *job-level* uses, not under steps:
  check-status:
    name: Check Job Statuses
    needs:
      - markdown
      - yaml
    uses: the-lupaxa-project/.github/.github/workflows/reusable-check-job-status.yml@master
    with:
      jobs_json: ${{ toJson(needs) }}
```

<br>
</details>

#### CodeQL Security and Quality

Standardised CodeQL security analysis workflow with a language matrix, suitable for running GitHub’s code scanning across one or more supported languages in a consistent way.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input      | Type   | Required | Default | Description                       |
| :--------- | :----- | :------- | :------ | :-------------------------------- |
| languages  | string | Yes      |         | Comma-separated list of CodeQL languages e.g. "python", "python,javascript". |

> We always enforce +security-and-quality to the queries.

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Dependabot Standardisation

Centralised Dependabot configuration runner that can be triggered from other workflows to ensure dependency update checks are applied consistently across all supported ecosystems.

> This workflow does not expose any inputs; all behaviour is defined in the workflow.

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Docs Bundle (Markdown and YAML)

"Docs quality bundle" that orchestrates Markdown and YAML linting (and optionally more later) via the underlying CICDToolbox workflows, giving a single job for documentation hygiene.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| md_globs      | string  | No       |         | Comma-separated list of regex patterns for Markdown files. Passed to the Markdown lint runner.     |
| yml_globs     | string  | No       |         | Comma-separated list of regex patterns for YAML files. Passed to the YAML lint runner.             |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Enforce SHA-Pinned Actions

Security-hardening workflow that inspects all workflow files and enforces SHA-pinned actions, allowing a controlled allow-list
(such as the-lupaxa-project/.github) while blocking branch/tag references elsewhere.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input      | Type    | Required | Default | Description                                                                                                                                                                             |
| :--------- | :------ | :------: | :------ | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| allow_list | string  | No       |         | Optional newline-separated list of owner[/repo] patterns that are allowed to use non-SHA refs (e.g. "the-lupaxa-project/.github"). Each line should be either "owner/" or "owner/repo". |
| dry_run    | boolean | No       | false   | If true, only report unpinned actions but do not fail the job.                                                                                                                          |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Generate Release

Generic GitHub release creator that takes a tag, generates a changelog, and creates a GitHub Release via softprops/action-gh-release,
so any repo can get consistent, documented releases.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input        | Type    | Required | Default               | Description                                                                                         |
| :----------- | :------ | :------: | :-------------------- | :-------------------------------------------------------------------------------------------------- |
| tag          | string  | No       | github.ref            | Tag ref to release, e.g. "refs/tags/v1.2.3". If omitted, uses github.ref from the calling workflow. |
| release_name | string  | No       | <tag without refs/*/> | Optional explicit release name. If empty, the tag name stripped of the refs/*/ prefix is used.      |
| draft        | boolean | No       | false                 | If true, create the release as a draft.                                                             |
| prerelease   | boolean | No       | false                 | If true, mark the release as a pre-release.                                                         |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example (Production Release)</strong></summary>
<br>

```yaml
name: Generate Release

on:
  push:
    tags:
      - "v[0-9]+.[0-9]+.[0-9]+"
      - '!v[0-9].[0-9]+.[0-9]+rc[0-9]+'

permissions:
  contents: write

jobs:
  create-release:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-github-release.yml@master
    secrets:
      github-token: ${{ secrets.GITHUB_TOKEN }}
```

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example (Test Release)</strong></summary>
<br>

```yaml
name: Generate Test Release

on:
  push:
    tags:
      - 'v[0-9].[0-9]+.[0-9]+rc[0-9]+'

permissions:
  contents: write

jobs:
  create-release:
    uses: the-lupaxa-project/.github/.github/workflows/reusable-github-release.yml@master
    secrets:
      github-token: ${{ secrets.GITHUB_TOKEN }}
```

<br>
</details>

#### First Interaction Greetings

Reusable wrapper around actions/first-interaction to post a friendly, standardised greeting on a contributor’s first issue and/or pull request in a repository.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default                                                                                          | Description                                    |
| :------------ | :------ | :------: | :----------------------------------------------------------------------------------------------- | :--------------------------------------------- |
| issue-message | string  | No       | "Thank you for raising your first issue - all contributions to this project are welcome!"        | Message posted on a user's first issue.        |
| pr-message    | string  | No       | "Thank you for raising your first pull request - all contributions to this project are welcome!" | Message posted on a user's first pull request. |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Dockerfile Linting (Hadolint)

Runs the CICDToolbox hadolint pipeline to lint Dockerfiles and Docker-related build files for best practices, portability, and common mistakes.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### JSON Linting

Invokes the CICDToolbox json-lint pipeline to validate JSON files, catching syntax errors and formatting issues in configuration and data files.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Markdown Linting

Standard Markdown linting workflow using the CICDToolbox markdown-lint pipeline and the shared .markdownlint.yml configuration for consistent prose and formatting rules.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Perl Linting

Uses the CICDToolbox perl-lint pipeline to run linting checks over Perl scripts and modules, enforcing style and catching common issues.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### PHP Linting

Runs the CICDToolbox php-lint pipeline to syntax-check and lint PHP files, helping keep PHP projects clean and error-free.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Puppet Manifest Linting

Wraps the CICDToolbox puppet-lint pipeline to validate Puppet manifests, enforcing style and best practices for configuration management code.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Python Requirements Updates (pur)

Uses the CICDToolbox pur pipeline to update Python requirements*.txt files, ensuring dependencies are brought up to date in a controlled way before commit or release.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Purge Old Workflow Runs

Reusable wrapper around otto-de/purge-deprecated-workflow-runs to clean up old, obsolete, cancelled, failed, or skipped workflow runs, keeping repository Actions history tidy.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input             | Type    | Required | Default | Description                                                                                       |
| :---------------- | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------ |
| token             | string  | No       |         | Optional token to use for the purge. If omitted, the workflow uses github.token.                  |
| remove_obsolete   | boolean | No       | true    | If true, remove workflow runs that are no longer associated with an existing workflow definition. |
| remove_cancelled  | boolean | No       | true    | If true, delete cancelled workflow runs.                                                          |
| remove_failed     | boolean | No       | true    | If true, delete failed workflow runs.                                                             |
| remove_skipped    | boolean | No       | true    | If true, delete skipped workflow runs.                                                            |
| remove_older_than | string  | No       |         | Optional multi-line spec passed to remove-older-than. Example: 30d * or 7d Some Workflow Name.    |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Python Style (pycodestyle)

Runs the CICDToolbox pycodestyle pipeline to enforce PEP 8-style guidelines on Python code, catching layout and style violations.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Python Docstrings (pydocstyle)

Invokes the CICDToolbox pydocstyle pipeline to check Python docstrings against a configured convention, improving API documentation consistency.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Python Meta-Linting (Pylama)

Uses the CICDToolbox pylama pipeline as a meta-linter that combines multiple Python linters into a single, unified quality gate.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Python Linting (Pylint)

Runs the CICDToolbox pylint pipeline to perform deep static analysis on Python code, enforcing coding standards and catching a wide range of potential issues.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Ruby Code Smells (Reek)

Wraps the CICDToolbox reek pipeline to detect "code smells" in Ruby code, helping highlight complexity and maintainability problems.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Ruby Linting (Rubocop)

Runs the CICDToolbox rubocop pipeline to provide Ruby linting and auto-formatting checks according to a shared configuration.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Shell Script Linting

Invokes the CICDToolbox shellcheck pipeline to lint shell scripts (.sh, .bash, etc.), catching unsafe constructs and portability problems.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### Slack Workflow Status Notifications

Posts a Slack notification summarising workflow status using Gamesight/slack-workflow-status, with support for toggles like manual opt-out, "no-slack" markers, and tag-run skipping.

This reusable workflow intentionally contains no guardrails. Its philosophy is simple:

`If you called me, you meant it.`

All logic and guardrails around if we should send the message to slack comes from the consuming workflow.
Below is a detailed (and commented) example with a selection of guardrails that can be used.

Guardrail List:

- Ensure Slack is globally enabled
- Ensure webhook secret exists
- Skip notify on PRs from forks
- Skip notify when commit message contains “[no-slack]”
- Skip notify when PR title contains “[no-slack]”
- Skip notify when manually dispatched AND manually disabled
- Skip notify for tag builds
- Always run (using strong guardrails)
- Has access to secrets

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input                  | Type    | Required | Default | Description                                                                                |
| :--------------------- | :------ | :------: | :------ | :----------------------------------------------------------------------------------------- |
| include_jobs           | string  | No       | "true"  | Controls inclusion of per-job status details. Valid values: "true", "false", "on-failure". |
| include_commit_message | boolean | No       | true    | If true, include the commit message in the Slack notification.                             |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

```yaml
name: Example CI with Slack

on:
  push:
    branches:
      - "**"
  pull_request:
  workflow_dispatch:
    inputs:
      enable_slack:
        description: "Send Slack notification for this manual run?"
        required: false
        type: boolean
        default: true

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

env:
  SLACK_ENABLED: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Do build / tests
        run: echo "Build goes here"

  slack-workflow-status:
    name: Slack Workflow Status
    needs:
      - build

  if: >
    always() &&                          # Always evaluate this block, even if earlier jobs fail.
    env.SLACK_ENABLED == true &&         # Global toggle set by the repo author.
    secrets.SLACK_WEBHOOK_URL != '' &&   # Skip if webhook isn't configured at repo/org level.
    
    # --- Prevent Slack for pull requests coming from forks ---
    # Forks should NEVER have access to internal Slack systems.
    (
      github.event_name != 'pull_request' ||
      github.event.pull_request.head.repo.full_name == github.repository
    ) &&

    # --- Allow manual workflow_dispatch to turn Slack on/off ---
    # If this is a manually-triggered run, only notify Slack if the user opted in.
    (
      github.event_name != 'workflow_dispatch' ||
      github.event.inputs.enable_slack == true
    ) &&

    # --- Skip Slack notifications when commit message contains “[no-slack]” ---
    # Developers can prevent Slack noise on minor commits.
    (
      github.event_name != 'push' ||
      !contains(github.event.head_commit.message, '[no-slack]')
    ) &&

    # --- Skip Slack on PRs when title contains “[no-slack]” ---
    (
      github.event_name != 'pull_request' ||
      !contains(github.event.pull_request.title, '[no-slack]')
    ) &&

    # --- Skip tag builds (commonly used for release tagging) ---
    (
      github.ref == '' ||
      !startsWith(github.ref, 'refs/tags/')
    )
  
    uses: the-lupaxa-project/.github/.github/workflows/reusable-slack-workflow-status.yml@master
    secrets:
      slack_webhook_url: ${{ secrets.SLACK_WEBHOOK_URL }}
```

<br>
</details>

#### Stale Issues and PRs

Reusable wrapper around actions/stale to automatically mark and optionally close stale issues and pull requests, using organisation-standard labels and timeouts.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input                   | Type    | Required | Default                                                                                                                                  | Description                                                       |
| :---------------------- | :------ | :------: | :--------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------------------------------- |
| stale-issue-message     | string  | No       | "This issue is stale because it has been open 30 days with no activity. Remove stale label or comment or this will be closed in 5 days." | Message when an issue becomes stale.                              |
| close-issue-message     | string  | No       | "This issue was closed because it has been stalled for 5 days with no activity."                                                         | Message when an issue is closed as stale.                         |
| days-before-issue-stale | number  | No       | 30                                                                                                                                       | Number of days before an issue is marked stale.                   |
| days-before-issue-close | number  | No       | 5                                                                                                                                        | Number of days after staleness before an issue is closed.         |
| stale-issue-label       | string  | No       | "state: stale"                                                                                                                           | Label applied to stale issues.                                    |
| close-issue-label       | string  | No       | "resolution: closed"                                                                                                                     | Label applied to issues closed due to staleness.                  |
| exempt-issue-labels     | string  | No       | "state: blocked,state: keep"                                                                                                             | Comma-separated list of labels that exempt issues from staleness. |
| stale-pr-message        | boolean | No       | "This PR is stale because it has been open 45 days with no activity. Remove stale label or comment or this will be closed in 10 days."   | Message when a PR becomes stale.                                  |
| close-pr-message        | boolean | No       | "This PR was closed because it has been stalled for 10 days with no activity."                                                           | Message when a PR is closed as stale.                             |
| days-before-pr-stale    | number  | No       | 45                                                                                                                                       | Number of days before a PR is marked stale.                       |
| days-before-pr-close    | number  | No       | 10                                                                                                                                       | Number of days after staleness before a PR is closed.             |
| stale-issue-label       | boolean | No       | "state: stale"                                                                                                                           | Label applied to stale PRs.                                       |
| close-issue-label       | boolean | No       | "resolution: closed"                                                                                                                     | Label applied to PRs closed due to staleness.                     |
| exempt-issue-labels     | boolean | No       | "state: blocked,state: keep"                                                                                                             | Comma-separated list of labels that exempt PRs from staleness.    |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### CITATION File Validation

Runs the CICDToolbox validate-citations-file pipeline to validate CITATION.cff files, ensuring project citation metadata is present and correctly structured.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<br>
</details>

#### YAML Linting

Standard YAML linting workflow using the CICDToolbox yaml-lint pipeline and the shared .yamllint.yml configuration, enforcing consistent YAML style and spacing.

<details>
<summary><strong>Click to expand: Inputs Accepted by this workflow</strong></summary>
<br>

| Input         | Type    | Required | Default | Description                                                                                        |
| :------------ | :------ | :------: | :------ | :------------------------------------------------------------------------------------------------- |
| include_files | string  | No       |         | Comma-separated list of regex patterns to include. Empty = auto-discover files.                    |
| exclude_files | string  | No       |         | Comma-separated list of regex patterns to exclude from scanning.                                   |
| report_only   | boolean | No       | false   | If true, never fail the job – still report issues but exit with status 0.                          |
| show_errors   | boolean | No       | true    | If true, print per-file error details in the output.                                               |
| show_skipped  | boolean | No       | false   | If true, list files that were discovered but skipped (e.g. excluded by patterns).                  |
| no_color      | boolean | No       | false   | If true, disable ANSI colours in the pipeline output (useful for plain log parsers or CI systems). |

<br>
</details>

<details>
<summary><strong>Click to expand: Minimal usage example</strong></summary>
<br>

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

<hr style="width: 50%; height: 1px; margin: 1em auto 0.5em;">
<p align="center">
    <em>
        The Lupaxa Project — Open Source, Secure by Design, Guided by Integrity.
    </em>
</p>

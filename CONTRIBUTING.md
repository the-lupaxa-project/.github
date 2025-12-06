<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/org-logos/master/orgs/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" width="256" />
    </a>
</p>

<h1 align="center">The Lupaxa Project: How to Contribute</h1>

We welcome contributions of all kinds, whether it’s fixing a bug, improving documentation, or adding new functionality.

If you discover issues, have ideas for improvements, or would like to propose new features, please open an issue in the
relevant repository or submit a pull request.

Please follow the guidelines below when doing so.

<h2>Organisation-Wide Governance</h2>

This project is part of [**The Lupaxa Project**](https://github.com/the-lupaxa-project).

Organisation-level structure and decision-making are defined centrally in the [`.github` repository](https://github.com/the-lupaxa-project/.github):

- [Governance][1]
- [Maintainers][2]
- [Projects overview][3]

[1]: https://github.com/the-lupaxa-project/.github/blob/master/GOVERNANCE.md
[2]: https://github.com/the-lupaxa-project/.github/blob/master/MAINTAINERS.md
[3]: https://github.com/the-lupaxa-project/.github/blob/master/PROJECTS.md

Please review these documents for details on how decisions are made, who the maintainers are, and how repositories are grouped across the ecosystem.

<h2>Issue Reporting</h2>

Before submitting an issue:

- **Check the latest code**: the issue may already be fixed.
- **Check for duplicates**: search existing issues to ensure it hasn’t already been reported.
- **Be clear and concise**: describe the problem precisely and completely.
- **Use a descriptive title**: fill in all issue form fields in complete sentences.
- **Include details**: specify the version, environment, or configuration used.
- **Provide examples**: minimal code samples or reproduction steps help us diagnose faster.

<h2>Feature Requests</h2>

If you have an idea for a new feature or improvement that you’d like to see but don’t plan to implement yourself, please open an issue
using the **Feature Request** template.

Explain *why* the feature is valuable and include use cases or examples where possible.

<h2>Pull Requests</h2>

- Read [How to Properly Contribute to Open Source Projects on GitHub][4].
- Fork the project and create a **feature branch** (not `master`).
- Write [Good Commit Messages][5].
- Follow existing **code style, documentation, and testing conventions**.
- Include or update tests for any new code.
- Ensure all tests pass before submission.
- [Squash Related Commits Together][6] before opening your PR.
- Open a [Pull Request][7] focused on a single, clear change, with a descriptive title and full sentences.

[4]: http://gun.io/blog/how-to-github-fork-branch-and-pull-request
[5]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
[6]: http://gitready.com/advanced/2009/02/10/squashing-commits-with-rebase.html
[7]: https://help.github.com/articles/about-pull-requests/

> [!IMPORTANT]
> We reserve the right to request changes or reject pull requests that don’t meet these standards.
> We will always provide constructive feedback to help you align with our practices.

<h2>Signed Commits</h2>

All commits **must be GPG- or SSH-signed** to verify the developer’s identity.

To sign your commits:

```bash
git commit -S -m "Your descriptive commit message"
```

For details, see [GitHub’s Guide to Signing Commits](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits).

> [!IMPORTANT]
> **Unsigned commits will be rejected automatically.**

<h2>Labeling Guidelines</h2>

To maintain consistency across all repositories in **The Lupaxa Project**, we use a structured label system based on four categories:

<h3>1. Type: What is this?</h3>

Choose one label to describe the nature of the issue or PR:

| Label                  | Description                      |
| :--------------------- | :------------------------------- |
| type: bug              | Something is broken.             |
| type: feature          | New functionality.               |
| type: enhancement      | Improve existing functionality.  |
| type: documentation    | Documentation-only changes.      |
| type: maintenance      | Internal housekeeping.           |
| type: security         | Security-related issue or fix.   |
| type: tests            | CI/testing changes.              |
| type: refactor         | Internal code restructure.       |
| type: performance      | Speed or efficiency improvement. |
| type: breaking change  | Backwards-incompatible change.   |
| type: question         | General inquiry.                 |
| type: good first issue | Friendly for newcomers.          |
| type: duplicate        | Duplicate of an existing issue.  |
| type: dependencies     | Dependency updates.              |

<h3>2. Impact: How severe is it?</h3>

Choose one label indicating severity or urgency:

| Label                 | Description                                                                                            |
| :-------------------- | :----------------------------------------------------------------------------------------------------- |
| impact: critical      | Causes complete failure of the system, major security breach, or data loss. Immediate action required. |
| impact: high          | Seriously degrades functionality or security. Work cannot continue without a workaround or fix.        |
| impact: medium        | Noticeable issue that affects usability or reliability, but system remains functional.                 |
| impact: low           | Minor problem with limited effect on users or functionality; cosmetic or localized.                    |
| impact: informational | No direct impact, useful for tracking ideas, questions, clarifications, or non-actionable findings.    |
| impact: none          | Does not affect functionality, security, or user experience; administrative or meta-only change.       |

<h3>3. State: What state is it in?</h3>

Use these labels to track workflow state:

| Label                   | Description                               |
| :---------------------- | :---------------------------------------- |
| state: triage           | Needs evaluation.                         |
| state: confirmed        | Verified and reproducible.                |
| state: accepted         | Approved for work.                        |
| state: work in progress | Being actively worked on.                 |
| state: complete         | Work done but not released.               |
| state: blocked          | Blocked by dependency or external factor. |
| state: stale            | Inactive for a long period.               |
| state: keep             | Explicitly not to be auto-closed.         |
| state: help wanted      | External assistance welcome.              |

<h3>4. Resolution: How was it closed?</h3>

Added only when closing issues or PRs:

| Label                       | Description                                                                                                 |
| :-------------------------- | :---------------------------------------------------------------------------------------------------------- |
| resolution: released        | The issue has been fixed and the change is included in a released version.                                  |
| resolution: closed          | The issue has been addressed or is no longer relevant; no further action needed.                            |
| resolution: invalid         | The issue does not represent a problem (e.g., user error or misunderstanding).                              |
| resolution: can't replicate | The reported problem cannot be reproduced with available information.                                       |
| resolution: won't fix       | The issue is acknowledged but will not be resolved due to design choice, low value, or planned deprecation. |

<h3>Recommended Label Pattern</h3>

A well-labelled issue or PR typically has:

- 1× type
- 1× impact
- 1× state
- 1× resolution (added when closing)

Example

| Category   | Label                |
| :--------- | :------------------- |
| Type       | type: bug            |
| Impact     | impact: high         |
| State      | state: confirmed     |
| Resolution | resolution: released |

<h2>Code of Conduct</h2>

This organisation follows a [Code of Conduct](https://github.com/the-lupaxa-project/.github/blob/master/CODE_OF_CONDUCT.md).
By participating in any repository, discussion, or community under **The Lupaxa Project**, you agree to uphold these principles.

<h1>&nbsp;</h1>

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

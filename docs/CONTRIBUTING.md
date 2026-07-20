<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/brand-assets/master/logos/organisations/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" />
    </a>
</p>

<h1 align="center">How to Contribute</h1>

Thank you for your interest in contributing to **The Lupaxa Project**.

Whether you're fixing a bug, improving documentation, proposing a new feature, or contributing code, every contribution helps improve the project for
everyone. We welcome contributions from developers of all experience levels and encourage collaboration across our entire ecosystem.

This guide describes the contribution process followed throughout **The Lupaxa Project**. Individual repositories may include additional requirements or
project-specific guidance where appropriate.

## Before You Start

Before beginning work, we recommend that you:

- Read the repository's `README.md` and any documentation contained within the `docs/` directory.
- Search existing issues and pull requests to avoid duplicating work.
- Open an issue or discussion before starting significant new features or behavioural changes.
- Familiarise yourself with the organisation-wide documentation, including the Engineering Principles, Governance, Maintainers, and Security documents where relevant.

Taking a few minutes to understand the project's direction often saves time later and helps ensure your contribution aligns with the project's goals.

## Ways to Contribute

Contributions extend well beyond writing code. Valuable contributions include:

- Reporting bugs
- Suggesting new features or improvements
- Improving documentation
- Reviewing pull requests
- Improving tests or automation
- Answering questions from other users
- Helping improve examples and tutorials

Every contribution is appreciated and helps strengthen the wider Lupaxa ecosystem.

## Reporting Bugs

Before opening a bug report:

- Ensure you're using the latest released version where possible.
- Search existing issues to determine whether the problem has already been reported.
- Collect enough information for someone else to reproduce the problem.

A good bug report should include:

- A clear description of the issue.
- Steps required to reproduce it.
- Expected behaviour.
- Actual behaviour.
- Relevant versions, operating system, and environment details.
- Logs, screenshots, or error messages where appropriate.

Clear, reproducible bug reports help us resolve issues much more quickly.

## Requesting Features

Feature requests are always welcome.

When suggesting a new feature, please explain:

- The problem you're trying to solve.
- Why the feature would benefit users.
- Possible approaches or alternatives you've considered.
- Any relevant examples or prior art.

Well-considered feature requests often lead to productive discussions and better solutions.

## Contributing Code

If you intend to contribute code:

1. Fork the repository.
2. Create a dedicated feature branch from `master`.
3. Keep each branch focused on a single logical change.
4. Follow the project's existing coding style and conventions.
5. Add or update tests where appropriate.
6. Update documentation if your change affects behaviour or usage.

## Development Workflow

To help keep reviews straightforward and project history easy to understand, we recommend the following workflow for all contributions:

1. Synchronise your fork with the latest changes from the upstream repository.
2. Create a new feature branch from `master`.
3. Make focused, self-contained changes.
4. Run all relevant tests and quality checks.
5. Commit your work using clear, descriptive commit messages.
6. Push your branch to your fork.
7. Open a Pull Request against the `master` branch.

Keeping each Pull Request focused on a single logical change makes reviews easier and reduces the likelihood of merge conflicts.

## Pull Requests

Before opening a Pull Request, please ensure that:

- Your branch is up to date with `master`.
- All automated tests pass successfully.
- Documentation has been updated where necessary.
- New functionality includes appropriate tests.
- Existing functionality continues to behave as expected.

When creating a Pull Request:

- Provide a clear, descriptive title.
- Explain the purpose of the change.
- Reference any related issues or discussions.
- Keep the scope focused on a single feature, fix, or improvement.

Maintainers may request changes before a Pull Request is accepted. Feedback is intended to improve both the contribution and the long-term quality of the
project.

> [!IMPORTANT]
> We reserve the right to request changes or decline contributions that do not align with the project's standards or objectives. Where possible, constructive
> feedback will always be provided.

## Commit Standards

Meaningful commit history benefits everyone.

Please:

- Write clear, concise commit messages.
- Keep commits logically grouped.
- Avoid mixing unrelated changes into a single commit.
- Squash temporary "fix-up" commits before opening a Pull Request where appropriate.

Well-structured commits make reviews easier and simplify future maintenance.

## Signed Commits

All commits **must be signed** using either GPG or SSH signatures.

To create a signed commit:

```bash
git commit -S -m "Your descriptive commit message"
```

GitHub automatically verifies supported commit signatures.

> [!IMPORTANT]
> Unsigned commits may be rejected by repository rules and automated workflows.

For more information, see GitHub's documentation on commit signature verification.

## Testing Expectations

Before submitting a Pull Request, contributors should:

- Run the project's automated tests.
- Run any configured linters or formatters.
- Verify that documentation remains accurate.
- Ensure new functionality is appropriately covered by tests where practical.

Individual repositories may define additional testing or validation requirements.

## Issue &amp; Pull Request Labels

To maintain consistency across **The Lupaxa Project**, we use a common labelling scheme throughout our repositories.

Labels help contributors and maintainers understand:

- The type of work being tracked
- The impact or severity
- The current workflow state
- How an issue or Pull Request was resolved

### Type

Exactly one **type** label should normally be applied.

| Label                    | Description                                             |
| :----------------------- | :------------------------------------------------------ |
| `type: bug`              | Something is broken or behaving unexpectedly.           |
| `type: feature`          | Introduces new functionality.                           |
| `type: enhancement`      | Improves existing functionality.                        |
| `type: documentation`    | Documentation-only changes.                             |
| `type: maintenance`      | Repository or housekeeping tasks.                       |
| `type: security`         | Security-related work.                                  |
| `type: tests`            | Test or CI improvements.                                |
| `type: refactor`         | Internal code restructuring with no behavioural change. |
| `type: performance`      | Performance improvements.                               |
| `type: breaking change`  | Introduces backwards-incompatible changes.              |
| `type: question`         | General questions or clarification.                     |
| `type: good first issue` | Suitable for new contributors.                          |
| `type: duplicate`        | Duplicate of an existing issue.                         |
| `type: dependencies`     | Dependency updates.                                     |

### Impact

One impact label should normally be assigned.

| Label                   | Description                                    |
| :---------------------- | :--------------------------------------------- |
| `impact: critical`      | Immediate attention required.                  |
| `impact: high`          | Significant functional or security impact.     |
| `impact: medium`        | Noticeable impact with reasonable workarounds. |
| `impact: low`           | Minor issue or cosmetic improvement.           |
| `impact: informational` | Information, discussion, or tracking only.     |
| `impact: none`          | Administrative or organisational change.       |

### State

State labels indicate where work currently stands.

| Label                     | Description                                |
| :------------------------ | :----------------------------------------- |
| `state: triage`           | Awaiting initial review.                   |
| `state: confirmed`        | Confirmed and reproducible.                |
| `state: accepted`         | Approved for implementation.               |
| `state: work in progress` | Currently being worked on.                 |
| `state: blocked`          | Waiting on another dependency or decision. |
| `state: complete`         | Work completed but not yet released.       |
| `state: stale`            | Inactive for an extended period.           |
| `state: keep`             | Exempt from automatic stale handling.      |
| `state: help wanted`      | Additional contributors are welcome.       |

### Resolution

Resolution labels are applied when closing an issue or Pull Request.

| Label                         | Description                                     |
| :---------------------------- | :---------------------------------------------- |
| `resolution: released`        | Included in an official release.                |
| `resolution: closed`          | Completed or no longer applicable.              |
| `resolution: invalid`         | Not considered a defect or enhancement.         |
| `resolution: can't replicate` | Unable to reproduce with available information. |
| `resolution: won't fix`       | Intentionally not being addressed.              |

A typical issue will usually contain:

- One **type** label
- One **impact** label
- One **state** label
- One **resolution** label (when closed)

## Code of Conduct

By participating in any repository within **The Lupaxa Project**, you agree to follow our organisation-wide Code of Conduct.

Please treat fellow contributors with professionalism, respect, and courtesy at all times.

## Thank You

Every contribution—whether it's code, documentation, testing, design feedback, bug reports, feature ideas, or helping other users—helps improve
**The Lupaxa Project**.

Thank you for taking the time to contribute.

<a href="https://github.com/the-lupaxa-project">
    <img src="https://raw.githubusercontent.com/the-lupaxa-project/brand-assets/master/logos/components/footer.svg" alt="The Lupaxa Project Footer" width="100%" />
</a>

<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/org-logos/master/orgs/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" width="256" />
    </a>
</p>

<h1 align="center">The Lupaxa Project: Security Process</h1>

<h2>Overview</h2>

This document describes how The Lupaxa Project internally handles security-related work, including:

- Security-labelled issues and pull requests
- Workflow hardening
- Supply-chain safety practices
- Expectations for contributors and maintainers
- How we manage sensitive workstreams

This complements our public-facing vulnerability reporting policy in SECURITY.md.

<h2>1. Security-Related Issues</h2>

Issues that involve or touch security must be labelled using:

- type: security
- impact: high or impact: critical (as appropriate)
- state: triage, transitioning through:
- state: confirmed → state: work in progress → state: complete → resolution:*

We avoid discussing exploit details in public threads.
If more information is required, a maintainer may move discussion to a private channel.

<h2>2. Security-Related Pull Requests</h2>

Pull requests that modify anything security-sensitive must:

- be labelled type: security
- be opened from a trusted branch within the organisation
- include a clear explanation of the risk being mitigated
- pass all required GitHub Actions with SHA-pinned dependencies
- include tests where applicable

If a pull request touches cryptography, secrets management, workflow execution, or supply chain logic, a mandatory two-maintainer review is required.

<h2>3. Workflow Security</h2>

All reusable workflows are built with:

- Strict SHA pinning (no tags or unpinned actions)
- The Lupaxa security-hardening wrapper
- Minimal scoped permissions
- Pull request guardrails for forks and unknown contributors
- Reusable Slack notifications allowing internal validation

Maintainers must not introduce:

- unpinned GitHub Actions
- unreviewed third-party scripts
- secrets exposed to forked PRs
- writable permissions unless strictly necessary

<h2>4. Sensitive Areas</h2>

The following require heightened care:

- Token generation and usage
- GitHub Actions that access contents: write
- Release automation and signing
- Dependency update automation
- CI tools that dynamically execute code
- Any external integrations (Slack, PyPI, Docker Hub, etc.)

All such PRs must be reviewed by at least:

- one maintainer familiar with GitHub Actions
- one maintainer responsible for platform security

<h2>5. Responsible Review Expectations</h2>

Contributors must ensure:

- No unpinned actions appear in changes
- Steps accessing secrets include proper guardrails
- PRs from forks cannot leak organisation secrets
- All added dependencies are trusted and minimal

Where uncertain, maintainers should request a security review from the organisation owners.

<hr />

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

<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/org-logos/master/orgs/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" width="256" />
    </a>
</p>

<h1 align="center">The Lupaxa Project: Security Architecture</h1>

The Lupaxa Project applies a Security by Design architecture across all projects — prioritising defensive defaults, minimal trust boundaries, and secure development practices.

This document provides a high-level, public summary of our security architecture and guiding principles.

<h2>Core Principles</h2>

- Defensive by default — all code paths assume failure, compromise, or misuse.
- Least privilege — every workflow, token, permission and process is granted only what it requires.
- Zero implicit trust — no untrusted code, third-party script, or workflow step runs without explicit review.
- Supply-chain integrity — dependencies, GitHub Actions, versions, and artefacts must be validated and pinned.
- Secure automation — CI/CD is built to be resilient to tampering, compromise, and PR-based attacks.

<h2>GitHub Actions Security Architecture</h2>

The following rules apply to all public repositories:

- **SHA-pinning enforced** for all third-party actions.
- **Reusable hardening workflows** ensure permission minimisation and safe defaults.
- **No secrets are available to forks** or untrusted PR sources.
- **PR security guardrails** prevent workflow execution when the source is untrusted.
- **Slug and ref validation** protects against branch spoofing and malicious forks.
- **Secure Slack notifications** only run when guardrails permit.

<h2>Dependency and Supply-Chain Controls</h2>

All public repositories follow:

- Use of Dependabot for routine updates
- Mandatory review of dependency changes
- No introduction of remote-code-execution dependencies without approval
- Licence-aware dependency selection
- Validation of build tools and artefact integrity

<h2>Repository-Level Hardening</h2>

Across all public repos:

- Mandatory branch protection
- Required code reviews
- Signed commits
- Required PR checks
- Restriction on direct pushes
- Enforced secure workflows
- Standardised label taxonomy for prioritisation and impact assessment

<h2>Release Security Model</h2>

Public releases follow a predictable, secure pipeline:

- Reproducible builds
- SHA-pinned CI toolchain
- Changelog generation through pinned actions
- Verification with twine, npm, or language-specific tooling
- Use of GitHub’s secure release API
- No secret exposure or unverified script execution

<h2>Open Source Transparency</h2>

We believe security improves through:

- Reproducibility
- Peer review
- Public visibility of our process
- Clear guidance for reporters
- Transparency around mitigations and fixes

This architecture ensures the safety, trustworthiness, and longevity of Lupaxa’s open-source ecosystem.

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

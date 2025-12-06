<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/org-logos/master/orgs/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" width="256" />
    </a>
</p>

<h1 align="center">The Lupaxa Project: Security Policy</h1>

**The Lupaxa Project** is committed to building secure, reliable, and trustworthy open-source software.
This document outlines our **security principles, architecture, processes**, and the **responsible disclosure policy** for reporting vulnerabilities.

## 1. Security Philosophy

Security is a fundamental part of all Lupaxa tooling and services.

We follow a Security by Design approach based on:

- Least privilege
- Minimal trust boundaries
- Secure defaults
- Separation of duties
- Auditable automation
- Secure development lifecycle (SDL) practices

Our goal: a secure ecosystem where contributors, users, and automated systems interact safely.

## 2. Security Architecture Overview

**The Lupaxa Project** employs a layered security architecture across infrastructure, automation, and development workflows.

### 2.1 Organisational Structure & Isolation

To limit blast radius and maintain strong separation, we use:

- Multiple GitHub organisations (tooling, libraries, infrastructure, private repos)
- Strictly partitioned privileges across organisations
- No shared secrets or cross-organisation trust relationships
- Scoped permissions on all automation and API tokens

### 2.2 Governance and Stewardship

Security responsibilities and decision-making are aligned with the organisation-wide
governance model:

- [Governance][1]
- [Maintainers][2]

[1]: https://github.com/the-lupaxa-project/.github/blob/master/GOVERNANCE.md
[2]: https://github.com/the-lupaxa-project/.github/blob/master/MAINTAINERS.md

These documents describe who is responsible for security-related decisions and
how changes to security posture are approved across Lupaxa repositories.

### 2.3 Protected Branches & Workflow Security

All repositories enforce:

- Protected master branches
- Verified status checks
- Require-review policies
- Mandatory code review for dependency updates
- Reusable hardened workflows across organisations
- No secrets available to forked PRs

### 2.4 GitHub Actions Hardening

Our workflows implement defence-in-depth:

- SHA-pinned third-party actions
- Permission minimisation (token and job-level)
- Restricted trigger conditions
- Guardrails for forked PRs
- Slug/ref validation to protect from spoofing
- Secure notifications that avoid leaking metadata
- Reusable workflows for consistent security enforcement

### 2.5 Dependency & Supply-Chain Controls

We maintain strict control of our supply chain:

- Mandatory review of all dependency updates
- Dependabot monitoring across all repos
- No introduction of dynamic code execution dependencies without approval
- Licence scanning for new dependencies
- Integrity checks and reproducible builds where possible

### 2.6 Infrastructure & Secrets

- No secrets are stored in source control
- Secrets are scoped per repo and minimal privilege
- Automated rotation for short-lived tokens
- No plaintext secrets in automation logs
- Secrets never exposed to untrusted workflows
- Strong separation between public and private repositories

## 3. Secure Development Practices

All contributors are expected to follow:

### 3.1 Coding Standards

- Prefer safe, explicit patterns
- Validate all input and external data
- Avoid unnecessary complexity, implicit behaviour, or side effects
- Use modern secure language features (e.g., Python 3.13, strict typing, safe defaults)

### 3.2 Peer Review Requirements

Every change must undergo review, including:

- Dependency updates
- Security-relevant code paths
- Configuration changes
- GitHub Actions or workflow updates
- Documentation that affects operational behaviour

### 3.3 Static Analysis & Testing

We employ:

- Ruff for linting
- Mypy for type-checking
- Pytest for tests
- Security-focused CI gating
- Automated test coverage for core logic

## 4. Incident Response & Security Process

If a security issue is suspected, observed, or confirmed, we follow the structured incident response workflow below.

### 4.1 Initial Classification

All incidents are classified into severity levels:

- Critical: Active exploitation or remote unauthenticated impact
- High: Privilege escalation or major information exposure
- Medium: Limited-scope exposure or misuse potential
- Low: Hardening gaps, misconfigurations, or informational issues

### 4.2 Containment

Depending on severity:

- Disable affected workflows
- Revoke exposed tokens
- Quarantine affected infrastructure
- Freeze releases or merges
- Patch vulnerable components

### 4.3 Eradication & Recovery

- Apply fixes or remove compromised components
- Rebuild from trusted sources
- Rotate keys/tokens
- Validate via testing and review
- Resume normal operations

### 4.4 Post-Incident Review

We conduct a blameless review covering:

- What happened
- How it happened
- How it was detected
- Why controls permitted it
- Improvements for prevention

A summary may be published for transparency if appropriate.

## 5. Reporting a Vulnerability (Responsible Disclosure)

We greatly appreciate responsible disclosures from the security community.

If you discover a vulnerability:

**Please email us directly:** [security@thelupaxaproject.org](mailto:security@thelupaxaproject.org)

Include:

- A clear description of the vulnerability
- Steps to reproduce
- Potential impact
- Any proof-of-concept or logs
- Whether the issue is public or privately disclosed

Do not create a public GitHub issue.

This protects users from premature exposure.

### 5.1 Response Timeline

We aim to:

- Acknowledge within 48 hours
- Provide an initial assessment within 5 working days
- Deliver a remediation plan shortly after triage
- Coordinate public disclosure (if applicable) once a fix is available

### 6. Security Expectations for Contributors

All contributors should:

- Use 2FA on GitHub
- Avoid committing secrets
- Use signed commits when possible
- Keep dependencies updated locally
- Run tests before pushing
- Follow coding standards and review expectations

## 7. Limitations & Use at Your Own Risk

While we take security extremely seriously, **The Lupaxa Project** provides software "as-is" with no warranties.

Users deploying our tools in production are responsible for:

- Hardening their environment
- Managing secrets
- Performing their own security assessments
- Ensuring compliance with organisational or regulatory requirements

### 8. Contact

For all security enquiries, disclosures, or concerns:

Email: [security@thelupaxaproject.org](mailto:security@thelupaxaproject.org)

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

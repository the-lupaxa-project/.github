<p align="center">
    <a href="https://github.com/the-lupaxa-project">
        <img src="https://raw.githubusercontent.com/the-lupaxa-project/brand-assets/master/logos/organisations/the-lupaxa-project/readme-logo.png" alt="The Lupaxa Project Logo" />
    </a>
</p>

<h1 align="center">Security Policy</h1>

Security is a fundamental part of **The Lupaxa Project**.

From the software we write to the automation that builds and releases it, we aim to apply secure engineering practices throughout the project lifecycle.
This document describes our security principles, contributor expectations, and responsible disclosure process.

## Security Principles

Our approach to security is guided by a number of core principles:

- Security by design
- Least privilege
- Secure defaults
- Defence in depth
- Transparency and responsible disclosure
- Continuous improvement

Security is considered throughout the design, implementation, review, testing, and maintenance of every project.

## Secure Development

Contributors are encouraged to follow secure development practices, including:

- Validate all external input.
- Keep implementations simple and maintainable.
- Avoid unnecessary dependencies.
- Prefer well-supported libraries and frameworks.
- Keep dependencies up to date.
- Consider security implications when introducing new features.
- Document security-relevant behaviour where appropriate.

Security reviews are encouraged for changes that affect authentication, authorisation, cryptography, networking, or other security-sensitive functionality.

## Repository Security

Repositories across **The Lupaxa Project** may make use of security controls including:

- Protected branches.
- Required reviews.
- Signed commits.
- Automated security scanning.
- Dependency monitoring.
- SHA-pinned GitHub Actions.
- Principle of least privilege for automation.

The exact controls applied may vary between repositories depending on their purpose.

## Responsible Disclosure

If you believe you have discovered a security vulnerability, please report it privately.

Please include:

- A description of the issue.
- Steps required to reproduce it.
- The potential impact.
- Any proof-of-concept or supporting information.

Please do **not** disclose security vulnerabilities publicly until they have been investigated and, where appropriate, resolved.

Responsible disclosure helps protect users while giving maintainers time to investigate and prepare a fix.

## Security Reporting

Security reports should be submitted by email to: [security@thelupaxaproject.org](mailto:security@thelupaxaproject.org)

When reporting a vulnerability, please include:

- A clear description of the issue.
- Steps to reproduce the problem.
- The affected project or repository.
- The potential impact.
- Any relevant logs, screenshots, or proof-of-concept material.

We ask that vulnerabilities remain confidential until they have been investigated and, where appropriate, remediated.

## Our Commitment

When a security report is received, we will:

- Acknowledge receipt as soon as reasonably practical.
- Investigate the reported issue.
- Assess its impact and severity.
- Develop and test an appropriate fix where required.
- Coordinate disclosure with the reporter whenever possible.

We value responsible disclosure and appreciate the time and effort taken by members of the security community to help improve our projects.

## Security Expectations for Contributors

Contributors are expected to:

- Avoid committing secrets, credentials, or sensitive information.
- Use signed commits where required by repository policy.
- Run appropriate tests before submitting changes.
- Follow repository coding standards.
- Raise potential security concerns during code review.

Security is a shared responsibility. Every contribution should strive to improve the overall safety and reliability of **The Lupaxa Project**.

## Disclaimer

While we make every reasonable effort to develop secure software, no software can ever be considered completely free from defects.

Users remain responsible for evaluating the suitability of our software for their own environments and should implement appropriate security controls when
deploying it.

<a href="https://github.com/the-lupaxa-project">
    <img src="https://raw.githubusercontent.com/the-lupaxa-project/brand-assets/master/logos/components/footer.svg" alt="The Lupaxa Project Footer" width="100%" />
</a>

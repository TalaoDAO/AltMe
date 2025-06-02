# ALTME & TALAO — EU Digital Identity Wallet Implementations for Holders

![Global Architecture](docs/architecture.png)

## Overview

**ALTME** and **TALAO** are open-source implementations of the **EU Digital Identity Wallet Architecture and Reference Framework (ARF)**, focused on the **Holder** role. These wallet solutions are aligned with the vision of **eIDAS 2.0** and aim to support trusted, privacy-preserving digital identity credentials within the European ecosystem.

They are designed to facilitate secure, interoperable credential issuance and presentation, according to the current ARF specifications.

---

## Conformance with ARF

ALTME and TALAO implement the key components required by the [ARF 1.10.0](https://eu-digital-identity-wallet.github.io/eudi-doc-architecture-and-reference-framework/1.10.0/architecture-and-reference-framework-main/):

- **Wallet Instance (WI)** for secure credential handling
- **Wallet Provider (WP)** and **Wallet Provider Backend (WPB)** for distribution, support, and maintenance
- **Wallet Secure Cryptographic Application (WSCA)** and **Wallet Secure Cryptographic Device (WSCD)** for compliant cryptographic operations
- Standardized interfaces with:
  - **Attestation Providers (AP)**
  - **PID Providers (PP)**
  - **Remote QES Providers (QP)**
  - **Authentic Sources (AS)**
  - **Relying Party Instances (RPI)**

These components are developed to reflect the modular and interoperable design mandated by the ARF.

> ℹ️ **Note:** ISO/IEC 18013-5 support (mobile driving license presentation) is **not currently implemented**.

---

## Supported Standards

ALTME and TALAO implement the following standards to ensure interoperability and data integrity:

| Specification                                | Description |
|---------------------------------------------|-------------|
| [W3C VC Data Model 2.0](https://www.w3.org/TR/vc-data-model-2.0/) | Data model for interoperable, tamper-evident verifiable credentials |
| **SD-JWT-based Verifiable Credentials**      | Privacy-preserving credentials with selective disclosure, based on IETF SD-JWT |
| **OpenID for Verifiable Credential Issuance (OpenID4VCI)** | Standard for secure credential issuance |
| **OpenID for Verifiable Presentations (OpenID4VP)** | Protocol for credential presentation |
| **eIDAS 2.0 Article 5a**                     | Legal framework for qualified European Digital Identity Wallets |

---

## Architecture

The image above presents the architecture as defined by the ARF, showing how ALTME and TALAO implement:

- The **User Device** and **Wallet Instance (WI)** for credential management
- A **Secure Cryptographic Interface (SCI)** to a pluggable secure element (HSM, eSIM, smart card)
- Standardized flows for issuance and presentation
- Interfaces to external trusted parties (e.g., PID/QES/Attestation/Authentic Sources)

This architecture ensures compliance and readiness for regulatory evaluation.

---

## Licensing

This project is released under the **Apache License 2.0**. See [LICENSE](LICENSE) for details.

---

## Learn More

- [EU Digital Identity Wallet ARF Documentation](https://eu-digital-identity-wallet.github.io/eudi-doc-architecture-and-reference-framework/)
- [W3C Verifiable Credentials](https://www.w3.org/TR/vc-data-model-2.0/)
- [SD-JWT Specification (IETF)](https://www.ietf.org/archive/id/draft-ietf-oauth-selective-disclosure-jwt-07.html)

---

*ALTME and TALAO are maintained by [Talao](https://github.com/TalaoDAO), a contributor to decentralized identity technologies across Europe.*

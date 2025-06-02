# ALTME & TALAO — EU Digital Identity Wallet Implementations for Holders
**ALTME** = **TALAO** + **crypto wallet**

![Global Architecture](docs/architecture.png)

## Overview

**ALTME** and **TALAO** are open-source implementations of the **EU Digital Identity Wallet Architecture and Reference Framework (ARF)**, focused on the **Holder** role. These wallets are developed to align with **eIDAS 2.0**, enabling secure and privacy-preserving identity credential management within the European regulatory framework.

They are designed to support standardized credential issuance, presentation, and cryptographic operations as required for ARF compliance.

---

## Conformance with ARF

ALTME and TALAO implement all major holder-side components defined by [ARF 1.10.0](https://eu-digital-identity-wallet.github.io/eudi-doc-architecture-and-reference-framework/1.10.0/architecture-and-reference-framework-main/):

- **Wallet Instance (WI)** — Core logic for credential storage and usage
- **Wallet Provider (WP)** and **Wallet Provider Backend (WPB)** — Distribution, support, and app maintenance
- **Wallet Secure Cryptographic Application (WSCA)** and **Wallet Secure Cryptographic Device (WSCD)** — Secure cryptographic environment
- Secure communication with:
  - **Authentic Sources (AS)**
  - **Attestation Providers (AP)**
  - **PID Providers (PP)**
  - **Remote QES Providers (QP)**
  - **Relying Parties (RPIs)**

> ⚠️ **Note:** The ISO/IEC 18013-5 standard (mDL presentation) is **not yet implemented**.

---

## Supported Standards

| Specification                                | Purpose |
|---------------------------------------------|---------|
| [W3C VC Data Model 2.0](https://www.w3.org/TR/vc-data-model-2.0/) | Model for interoperable, tamper-evident verifiable credentials |
| **SD-JWT-based Verifiable Credentials**      | Credentials enabling selective disclosure and privacy preservation |
| **OpenID4VCI**                               | Credential issuance protocol |
| **OpenID4VP**                                | Credential presentation protocol |
| **eIDAS 2.0 (Article 5a)**                   | Interoperability and legal compliance within the EU digital identity ecosystem |

---

## Architecture

The architecture shown above describes the full integration of components as specified in the ARF:

- **Wallet Instance (WI)** runs securely on the user’s device
- **Secure Cryptographic Interface (SCI)** connects to hardware security modules or secure elements (HSM, smartcard, eSIM, native)
- Trust relationships with issuing and verifying parties are built through standardized, open protocols
- The **User Interface (UI)** allows the holder to manage credentials and consent to transactions

This modular design ensures both **compliance** and **interoperability** with EU digital identity infrastructure.

---

## Project Installation

Please follow the step-by-step installation guide here:  
👉 [Installation Guide](https://github.com/TalaoDAO/AltMe/blob/master/doc/installation.md)

---

## License

This project is released under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for full terms.

---

## Further Reading

- [EU Digital Identity Wallet ARF](https://eu-digital-identity-wallet.github.io/eudi-doc-architecture-and-reference-framework/)
- [W3C VC Data Model 2.0](https://www.w3.org/TR/vc-data-model-2.0/)
- [SD-JWT Draft (IETF)](https://www.ietf.org/archive/id/draft-ietf-oauth-selective-disclosure-jwt-07.html)

---

**Maintained by [TalaoDAO](https://github.com/TalaoDAO) — Contributor to decentralized identity standards and European digital identity infrastructure.**

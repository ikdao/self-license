# Self License - README

A minimal, simple, self-applicable and self-declarative license standard, stack, and set.  
**Visit:**
 [https://legal.ikdao.org/license/](https://legal.ikdao.org/license/)

[https://legal.ikdao.org/self-license/](https://legal.ikdao.org/self-license/)


---

## 📘 Introduction

As human artifacts—particularly digital ones—have evolved across countless domains, the need for licenses to address issues like terms, rights, authorship, and ownership has grown significantly. Unfortunately, licensing has become unnecessarily complex, especially for developers, artists, and creators trying to quickly find suitable terms for their work.

Self License (SL) was created to simplify and minimize this process. It provides a **bitwise, self-attested** way to declare licensing terms for any creative output—digital or otherwise. It's particularly relevant for creators in India and South Asia, but not limited to them.

---

## ⚙️ Meaning & Philosophy

A **Self License** is one you attach yourself, based on a simple bitstring that expresses the conditions of use. "Self" refers to self-declaration and self-responsibility. Like nature or reality, there is no ownership or restriction unless explicitly declared.

---

## 🎯 Purpose

To simplify licensing through an easy-to-use and semantically readable standard—similar to Semantic Versioning (semver)—especially familiar to developers and digital creators.

---

## 🔢 Bitwise Structure

Each Self License is based on a **bitstring of up to 6 bits** (positions 0–5), written in order of **increasing specificity**.

- Each bit is either:
  - `1` (true, exists/enabled)
  - `0` (false, not present/disabled)
  - `x` (undefined)

**Positions:**

| Bit | Position | Meaning                     |
|-----|----------|-----------------------------|
| 0   | Terms & Conditions | If `1`, the license includes explicit terms (custom or predefined). |
| 1   | Attribution         | If `1`, attribution to the creator is required. |
| 2   | Accountability      | If `1`, traceable contribution or relicensing must be maintained. |
| 3   | Source Openness     | If `1`, source is open and inspectable. |
| 4   | Modifications       | If `1`, modifications are allowed. |
| 5   | Commercial Use      | If `1`, reselling and commercial use is permitted. |

### 🧠 Bitwise Example

```
License Code: 101011
  Bit 0 (T&C):      1 → Terms exist
  Bit 1 (Attribution): 0 → No attribution required
  Bit 2 (Accountability): 1 → Accountability required
  Bit 3 (Source):      0 → Source is closed
  Bit 4 (Modification): 1 → Modifications allowed
  Bit 5 (Commercial):   1 → Commercial use allowed
```

> This results in:  
> `Self License - 101011SL`  
> The license reflects custom terms, accountability, permission to modify, and allow commercial use, without attribution or open source.

---

## 📄 License Naming Convention

- The license name is derived from the **bitstring** + suffix `SL`:
  - `0SL`, `1SL`, `10SL`, `111SL`, `101011SL`, etc.
- The shorter the bitstring, the more general the license.
- Omitted (undefined) bits are considered unspecified (`x`) and should **not** be interpreted as either true or false.

---

## 🗂️ License Text Examples

### 🟢 Zero Self License - `0SL`

```
Self License - 0SL
Work Name - Creator Name
A short description

I/We hereby declare:
No terms and conditions exist or made.

This work is open, free and can be taken as in public domain.
Made by, for, of, in common faith.
Any or all permissions can be implicitly taken as granted.

To know more: https://legal.ikdao.org/license/0sl
```

### 🔒 One Self License - `1SL`

```
Self License - 1SL
Work Name - Creator Name
A short description

I/We hereby declare:
Terms and conditions exist or made.

[Optional list of custom terms...]

This work is reserved.

To know more: https://legal.ikdao.org/license/1sl
```

---

## 🌤️ Declared Values

| Value | Meaning               |
|-------|------------------------|
| `0`   | false / not present    |
| `1`   | true / present         |
| `x`   | undefined / not stated |

---

## ⚖️ Usage Guidelines

- Use only the bits you need. The **more bits**, the more specific the license.
- Prior bits **must be declared before** declaring later ones. (e.g., you cannot define position 4 if 0–3 are undefined.)
- **Custom terms** are only valid if bit 0 is `1`.
- Use the [`make.sh`](./make.sh) script to generate a license interactively or via CLI.

---

# 🦙 llama-cpp-python: Multi-Architecture Wheel Builder

This repository automatically builds and publishes **Python wheels** for [abetlen/llama-cpp-python](https://github.com/abetlen/llama-cpp-python) across **all major platforms and architectures** using GitHub Actions and [cibuildwheel](https://github.com/pypa/cibuildwheel).

> ✅ Wheels are uploaded to the **GitHub Releases** section of this repo — ready to download!

---

## 🚀 Supported Platforms

This build system supports:

| OS      | Architecture        |
| ------- | ------------------- |
| Linux   | `x86_64`, `aarch64` |
| macOS   | `arm64`, `x86_64`   |
| Windows | `x86_64`            |

---

## 🧪 Supported Python Versions

Wheels are built for:

* Python **3.8 → 3.13**

> This means all of the following tags will be available:
>
> `cp38`, `cp39`, `cp310`, `cp311`, `cp312`, `cp313`

---

## 🛠️ How It Works

### 1. `watch-upstream.yml` – Scheduled Trigger (Every 12h)

* Fetches the latest release tag from the [llama-cpp-python GitHub API](https://api.github.com/repos/abetlen/llama-cpp-python/releases/latest)
* Extracts the base tag (e.g., `v0.3.14` from `v0.3.14-cu124`)
* If the release hasn’t been built yet:

  * Triggers `build-wheels.yml` with that version

### 2. `build-wheels.yml` – Cross-Platform Builder

* Uses `cibuildwheel` and `docker buildx` to build wheels
* Supports:

  * 🐧 Linux (QEMU for `aarch64`)
  * 🍎 macOS (Intel + Apple Silicon)
  * 🪟 Windows (MSVC toolchain)
* Builds wheels for Python 3.8 through 3.13
* Uploads wheels to a **GitHub Release** matching the tag

---

## 📦 Example Wheel Names

```text
llama_cpp_python-0.3.14-cp38-cp38-manylinux_x86_64.whl
llama_cpp_python-0.3.14-cp310-cp310-manylinux_aarch64.whl
llama_cpp_python-0.3.14-cp313-cp313-macosx_11_0_arm64.whl
llama_cpp_python-0.3.14-cp311-cp311-win_amd64.whl
```

---

## 🔧 Manual Trigger

You can manually build a specific version:

1. Go to the `Actions` tab
2. Select `build-wheels.yml`
3. Click **"Run workflow"**
4. Enter the desired tag (e.g., `v0.3.14-cu124`)

---

## ⏰ Schedule

The `watch-upstream.yml` workflow runs every **12 hours** via cron:

```yaml
schedule:
  - cron: '0 */12 * * *'  # Every 12 hours
```

---

## 📤 Release Output

All built `.whl` files are published as release assets under the **Releases** tab for the corresponding version tag.

---

## 🔐 Security Notes

* GitHub-hosted runners with ephemeral environments
* Isolated builds using Docker and `cibuildwheel`
* Sources pulled directly from upstream: [abetlen/llama-cpp-python](https://github.com/abetlen/llama-cpp-python)

---

## 🙋 FAQ

**Q: Does this build support CUDA or Metal?**

**A:** Currently, only **CPU-only** builds are supported. CUDA and Metal require custom runners and are not compatible with GitHub-hosted environments.

**Q: Why do wheels include `cu124` in the tag?**

**A:** That part comes from the upstream release tag. We extract the base tag (e.g., `v0.3.14`) for organizing releases.

**Q: How do I change supported Python versions?**

**A:** Edit the `CIBW_BUILD` value in `build-wheels.yml`. This repo is already set to build for **Python 3.8–3.13**.

---

## 📄 License

MIT © eswarthammana – Built on top of open source contributions from [abetlen](https://github.com/abetlen) and [pypa/cibuildwheel](https://github.com/pypa/cibuildwheel).

---
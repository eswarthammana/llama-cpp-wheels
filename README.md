# 🦙 llama-cpp-python: Multi-Architecture Wheel Builder

This repository automatically builds and publishes **Python wheels** for [abetlen/llama-cpp-python](https://github.com/abetlen/llama-cpp-python) across **all major platforms and architectures** using GitHub Actions and [cibuildwheel](https://github.com/pypa/cibuildwheel).

> ✅ Wheels are uploaded to the **GitHub Releases** section of this repo — ready to download!

---

## 🚀 Supported Platforms

This build system supports:

| OS       | Architecture |
|----------|--------------|
| Linux    | `x86_64`, `aarch64` |
| macOS    | `arm64`, `x86_64`   |
| Windows  | `x86_64`            |

All builds are for **Python 3.12.9**.

---

## 🛠️ How It Works

### 1. `auto-trigger.yml` – Scheduled Trigger (Every 12h)
- Fetches the latest release tag from the [llama-cpp-python GitHub API](https://api.github.com/repos/abetlen/llama-cpp-python/releases/latest)
- Extracts the base tag (e.g., `v0.3.14` from `v0.3.14-cu124`)
- If the release tag hasn’t been built yet:
  - Triggers the `build-wheels.yml` workflow with that version

### 2. `build-wheels.yml` – Cross-Platform Builder
- Uses `cibuildwheel` and `docker buildx` to build wheels
- Supports:
  - 🐧 Linux (with QEMU for `aarch64`)
  - 🍎 macOS (Intel + Apple Silicon)
  - 🪟 Windows
- Builds all wheels and pushes them to a **GitHub Release** matching the tag

---

## 📦 Example Wheel Names

```text
llama_cpp_python-0.3.14-cp312-cp312-manylinux_x86_64.whl
llama_cpp_python-0.3.14-cp312-cp312-manylinux_aarch64.whl
llama_cpp_python-0.3.14-cp312-cp312-macosx_11_0_arm64.whl
llama_cpp_python-0.3.14-cp312-cp312-win_amd64.whl
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

The `auto-trigger.yml` workflow runs every **12 hours** via cron:

```yaml
schedule:
  - cron: '0 */12 * * *'  # Every 12 hours
```

---

## 📤 Release Output

Built wheels are pushed as release assets to this repo's **Releases** tab.

---

## 🧪 Python Compatibility

This repo currently targets:
- Python: `3.12.9` (customizable in the workflow)

You can extend support to other Python versions by modifying the `CIBW_BUILD` environment variable in `build-wheels.yml`.

---

## 🔐 Security Notes

- Each run uses GitHub-hosted runners
- Isolated builds per platform using Docker and cibuildwheel
- Relies on official llama-cpp-python repo for source fetching

---

## 🙋 FAQ

**Q: Does this build support CUDA or Metal?**  
A: We currently build **CPU-only** wheels. CUDA and Metal variants require specialized runners and environments not supported in the GitHub-hosted runners.

**Q: Why do wheels include `cu124` in the tag?**  
A: That reflects the upstream release tag. We strip it to find the base version for naming the release and wheel files.

**Q: How do I change the Python version?**  
A: Modify the `CIBW_BUILD` and `CIBW_PYTHON_VERSION` fields in `build-wheels.yml`.

---

## 📄 License

MIT © eswarthammana – Built on top of open source contributions from [abetlen](https://github.com/abetlen) and [pypa/cibuildwheel](https://github.com/pypa/cibuildwheel).
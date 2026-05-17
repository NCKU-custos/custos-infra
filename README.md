# custos-infra

Shared CI infrastructure for the Custos drone stack.

Contents:

- **Reusable GitHub Actions workflows** (`.github/workflows/`) — `ros2-build`, `lint`, `interfaces-consumers`. Every other Custos repo calls into these via `uses: NCKU-custos/custos-infra/.github/workflows/<name>@<ref>`.
- **Docker base images** (`docker/`) — Ubuntu 26.04 + ROS2 Lyrical images published to `ghcr.io/ncku-custos/`.
- **Shared lint configs** (`lint/`) — `.clang-format`, `ruff.toml`, `ament_lint_config/`. Symlinked or referenced from each repo.

This repo is **created first** in the org so other repos have something to reference. Bootstrap caveat: the first commit can't call its own reusable workflows; initial CI is inline, refactored to reusables once they exist.

For the system overview and full repo list, see [`custos-bringup`](https://github.com/NCKU-custos/custos-bringup).

<!-- bootstrap CI observe: 2026-05-17T14:11:14Z -->

# custos-infra — CLAUDE.md

Shared CI workflows, Docker base images, and lint configs for the Custos drone stack. Every other Custos repo consumes from here.

Workspace-wide rules and state caveats live at `../CLAUDE.md` (= `/space/drone/CLAUDE.md`). Read it before making cross-repo changes. If you are in a standalone clone, note that this repo is the cascade source — a change here can break every other repo's CI on the next workflow run.

## State of this repo

- Reusable workflows in `.github/workflows/`: `ros2-build.yml`, `lint.yml`, `interfaces-consumers.yml`, `release-please.yml`, `build.yml`. All scaffolded; consumers' `build.yml` now references them, but no end-to-end run has gone green yet — see workspace caveats (GHCR image not pushed; Lyrical apt packages land 2026-05-22).
- Docker base at `docker/base/Dockerfile` (Ubuntu 26.04 + ROS2 Lyrical) plus `entrypoint.sh`. **Not yet pushed to GHCR** as `ghcr.io/ncku-custos/ros-base:lyrical-26.04`; the devcontainer and most workflows assume it exists.
- Lint configs at `lint/`: `.clang-format`, `ruff.toml`, `ament_lint_config/`. Symlinked or referenced from every consumer repo.
- `release-please-config.json` + `.release-please-manifest.json` are simple-package mode (this repo's own version line).
- No ROS package — not a `colcon` target. There is no `package.xml`.

## Cross-repo edges

- **Depends on:** nothing — leaf of the dependency graph.
- **Depended on by:** every other Custos repo via `uses: NCKU-custos/custos-infra/.github/workflows/<name>@<ref>` (workflow consumption) and via `FROM ghcr.io/ncku-custos/ros-base:lyrical-26.04` (image consumption).
- **GitHub App reference:** `interfaces-consumers.yml` consumes the org secrets `CUSTOS_CI_APP_ID` and `CUSTOS_CI_PRIVATE_KEY` (ADR 0009). App `custos-ci` (ID: 3744266) is registered, installed org-wide, and secrets are set.

## Repo-specific hard rules

- **Reusable workflows are public API.** A breaking change here (renamed input, removed output, changed default) cascades across every consumer that pins `@main`. Pin behavior changes by tagging this repo and asking consumers to bump their `@<ref>`. Never silently change a workflow's contract on `main`.
- **Docker base image tag must match the ROS2 distro** (ADR 0011). The tag scheme is `<distro>-<ubuntu>` (e.g., `lyrical-26.04`). If you add a Tier 3 fallback (Ubuntu 24.04), add a sibling tag rather than redefining the existing one.
- **Lint configs are canonical.** Do not let any consumer repo define a divergent `.clang-format` or `ruff.toml`. If a repo needs an exception, capture it as an ADR — see ADR 0006 for the "consistent across repos" principle.
- **Bootstrap caveat (ADR 0001/0009 fallout):** This repo's own CI cannot dogfood its reusable workflows on the very first commit, because the workflows reference themselves via `NCKU-custos/custos-infra/...@main`. Initial CI here is inline; refactor to `uses:` once the workflows actually exist on `main`.

## Build / test cheat sheet

```bash
# Build the Docker base locally (the GHCR push has not happened yet).
docker build -t ghcr.io/ncku-custos/ros-base:lyrical-26.04 docker/base/

# Validate workflow YAML.
yamllint .github/workflows/

# There is no colcon build target.
```

To exercise a workflow end-to-end before changing it, push a no-op PR in a consumer repo and watch the run.

## Pointers specific to this repo

- Reusable workflows: `.github/workflows/`
- Docker base: `docker/base/Dockerfile`
- Lint configs: `lint/`
- Cross-repo CI policy: ADR 0009 (`custos-bringup/docs/adr/0009-pre-merge-cross-repo-ci.md`)
- Distro / OS choice: ADR 0011

> TODO(post-GHCR-push): drop the "image not yet pushed" notes above.
> TODO(post-custos-ci-App): record the App's installation ID and the org-secret rotation procedure.
> TODO(post-first-commit): replace the bootstrap inline CI with `uses:` references once the reusable workflows actually live on `main`.
> TODO(post-active): document common lint failures and their fixes once consumer repos start hitting them.

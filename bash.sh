git branch -m codex/add-pull-request-template codeX
git fetch origin
git branch -u origin/codeX codeX
git remote set-head origin -a
# Stage the modified window manager adapter binary
git add computer-use-linux/src/bin/codex-computer-use-cosmic.rs

# Commit changes using standard lint-friendly annotations
git commit -m "fix(computer-use): resolve COSMIC state parsing Clippy lint"

# Deploy local branch state upstream
git push origin codeX/issue-710-cli-optional-deps
bash -n install.sh
bash -n scripts/lib/*.sh
bash -n launcher/start.sh.template
bash -n scripts/build-deb.sh scripts/build-rpm.sh scripts/build-pacman.sh scripts/build-appimage.sh
node --test scripts/patch-linux-window-ui.test.js
node --test linux-features/*/test.js
bash tests/scripts_smoke.sh
cargo check -p codex-update-manager
cargo test -p codex-update-manager

# 1. Remove the system package based on your distribution
sudo apt remove codex-desktop      # Debian/Ubuntu
sudo dnf remove codex-desktop      # Fedora

# 2. Kill and dismantle background services if active
systemctl --user disable --now codex-update-manager.service

# 3. Wipe application runtime caches and operational paths
rm -rf ~/.config/codex-desktop ~/.cache/codex-desktop ~/.config/codex-update-manager

git checkout codex/issue-710-cli-optional-deps
python3 - <<'PY'
from pathlib import Path

path = Path("computer-use-linux/src/bin/codex-computer-use-cosmic.rs")
text = path.read_text()

old = """                for value in state.chunks_exact(4) {
                    if let Ok(parsed) = zcosmic_toplevel_handle_v1::State::try_from(
                        u32::from_ne_bytes(value.try_into().unwrap()),
                    ) {
"""

new = """                let (state_values, _remainder) = state.as_chunks::<4>();
                for value in state_values {
                    if let Ok(parsed) = zcosmic_toplevel_handle_v1::State::try_from(
                        u32::from_ne_bytes(*value),
                    ) {
"""

if old not in text:
    raise SystemExit("target code was not found")

path.write_text(text.replace(old, new))
PY

cargo fmt --check
cargo clippy --workspace --all-targets -- -D warnings
git add computer-use-linux/src/bin/codex-computer-use-cosmic.rs
git commit -m "Fix COSMIC state parsing Clippy lint"
git push origin codex/issue-710-cli-optional-deps
git clone https://github.com/web4hub/codex.git
cd codexbash scripts/ci/update-nix-hashes.sh
git add flake.nix nix/native-modules/package.json nix/native-modules/package-lock.json
git commit -m "fix(nix): refresh upstream DMG pins"
git push

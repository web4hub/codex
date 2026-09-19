# Switch to the correct issue-driven development branch
git checkout codex/issue-710-cli-optional-deps

# Apply the safe slice parsing optimization
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
    raise SystemExit("Target COSMIC parsing slice pattern was not found.")

path.write_text(text.replace(old, new))
print("Successfully applied array optimization patch.")
PY

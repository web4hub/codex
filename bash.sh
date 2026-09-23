git branch -m codex/add-pull-request-template codeX
git fetch origin
git branch -u origin/codeX codeX
git remote set-head origin -a
# Stage the modified window manager adapter binary
git add computer-use-linux/src/bin/codex-computer-use-cosmic.rs

# Commit changes using standard lint-friendly annotations
git commit -m "fix(computer-use): resolve COSMIC state parsing Clippy lint"

# Deploy local branch state upstream
git push origin codex/issue-710-cli-optional-deps

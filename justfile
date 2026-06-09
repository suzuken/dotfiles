# Tasks for this PUBLIC dotfiles repo. See also Makefile (chezmoi install).

# List available tasks.
default:
    @just --list

# Wire git to use the repo's hooks/ (run once after clone).
install-hooks:
    chmod +x hooks/*
    git config core.hooksPath hooks
    @echo "core.hooksPath -> hooks/ (pre-push leak check active)"

# Scan the whole working tree (incl. untracked) for secrets + confidential content.
check:
    gitleaks detect --no-git --config .gitleaks.toml --redact --no-banner -v

# Scan committed history (what's actually pushable).
check-history:
    gitleaks detect --config .gitleaks.toml --redact --no-banner -v

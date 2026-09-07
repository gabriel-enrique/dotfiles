#!/bin/bash
# Dotfiles installation script
# Creates symlinks from ~ to dotfiles repository
# Usage: ./install.sh [categories...]
#   ./install.sh              # Install all categories
#   ./install.sh bash git     # Install only bash and git
#   ./install.sh --list       # Show available categories
#   ./install.sh --force      # Repoint symlinks owned by another checkout
#   ./install.sh --help       # Show this help message
#
# Symlinks already pointing at a different checkout are reported and left
# alone, so running this from a development clone cannot silently take over
# the dotfiles in use. Pass --force to repoint them on purpose.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR/.backup"
HOME_DIR="$HOME"
FORCE=false
FAILED=0

# Define available categories and their files to symlink
declare -A CATEGORIES=(
    [bash]=".bashrc .bash_profile .bash_prompt .bash_logout .inputrc"
    [zsh]=".zshrc .zprofile .zsh_prompt"
    [shell]=".shell_aliases"
    [git]=".gitconfig .gitignore_global"
    [nvim]=".config/nvim/init.lua"
    [vim]=".vimrc"
    [tmux]=".tmux.conf"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_help() {
    # Print the header comment block as help text: skip the shebang, strip the
    # leading "# ", and stop at the first line that is not a comment, so the
    # help can never drift into printing code the way a fixed line count did.
    awk 'NR == 1 { next } /^#/ { sub(/^# ?/, ""); print; next } { exit }' "$0"
}

list_categories() {
    echo "Available categories:"
    for category in "${!CATEGORIES[@]}"; do
        echo "  - $category"
    done
}

print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

create_backup() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        local filename=$(basename "$target")
        local backup_file="$BACKUP_DIR/$filename.$(date +%s)"
        mv "$target" "$backup_file"
        print_warn "Backed up existing $filename to $backup_file"
    fi
}

# Report targets that are symlinks into a different checkout. Repointing them
# would move the dotfiles in use to this clone, so it has to be asked for.
check_conflicts() {
    local conflicts=()

    for category in "${SELECTED_CATEGORIES[@]}"; do
        for file in ${CATEGORIES[$category]}; do
            local source="$SCRIPT_DIR/$category/$file"
            local target="$HOME_DIR/$file"

            if [[ -L "$target" && "$(readlink "$target")" != "$source" ]]; then
                conflicts+=("$target → $(readlink "$target")")
            fi
        done
    done

    if [[ ${#conflicts[@]} -gt 0 ]]; then
        print_error "${#conflicts[@]} file(s) already point at another checkout:"
        printf '        %s\n' "${conflicts[@]}"
        print_error "Re-run with --force to repoint them at $SCRIPT_DIR"
        return 1
    fi
}

install_category() {
    local category="$1"
    local files="${CATEGORIES[$category]}"

    if [[ -z "$files" ]]; then
        print_error "Unknown category: $category"
        return 1
    fi

    print_info "Installing $category..."

    for file in $files; do
        local source="$SCRIPT_DIR/$category/$file"
        local target="$HOME_DIR/$file"
        local target_dir=$(dirname "$target")

        # Check if source exists. Record the skip so the run cannot report
        # success afterwards. Plain assignment, not ((FAILED++)), which
        # returns non-zero on the first increment and would trip set -e.
        if [[ ! -e "$source" ]]; then
            print_error "Source file not found: $source"
            FAILED=$((FAILED + 1))
            continue
        fi

        # Create parent directory if needed
        if [[ ! -d "$target_dir" ]]; then
            mkdir -p "$target_dir"
            print_info "Created directory: $target_dir"
        fi

        # Back up existing file if it exists and is not a symlink
        create_backup "$target"

        # Create symlink
        ln -sf "$source" "$target"
        print_info "Symlinked: $target → $source"
    done
}

main() {
    # Process arguments
    for arg in "$@"; do
        case "$arg" in
            --help|-h)
                print_help
                exit 0
                ;;
            --list|-l)
                list_categories
                exit 0
                ;;
            --force|-f)
                FORCE=true
                ;;
            *)
                if [[ -n "${CATEGORIES[$arg]}" ]]; then
                    SELECTED_CATEGORIES+=("$arg")
                else
                    print_error "Unknown option or category: $arg"
                    exit 1
                fi
                ;;
        esac
    done

    # No category named: install all of them. Flags alone still mean "all",
    # so `--force` on its own works the same as a bare run.
    if [[ ${#SELECTED_CATEGORIES[@]} -eq 0 ]]; then
        SELECTED_CATEGORIES=("${!CATEGORIES[@]}")
    fi

    if [[ "$FORCE" != true ]]; then
        check_conflicts || exit 1
    fi

    echo "Dotfiles installation starting..."
    echo "Repository: $SCRIPT_DIR"
    echo "Home directory: $HOME_DIR"
    echo "Categories to install: ${SELECTED_CATEGORIES[@]}"
    echo ""

    # Install each category
    for category in "${SELECTED_CATEGORIES[@]}"; do
        install_category "$category" || {
            print_error "Failed to install $category"
            exit 1
        }
    done

    echo ""
    if [[ $FAILED -gt 0 ]]; then
        print_error "Installation incomplete: $FAILED file(s) missing from $SCRIPT_DIR"
    else
        print_info "Installation complete!"
    fi

    if [[ -d "$BACKUP_DIR" ]]; then
        print_info "Backups saved to: $BACKUP_DIR"
    fi

    [[ $FAILED -eq 0 ]] || exit 1
}

main "$@"

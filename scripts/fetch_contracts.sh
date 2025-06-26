#!/usr/bin/env bash

# WARNING: This script does not automate all of the work. It just fetches new contracts from era-contracts
# without filtering out non-public files (i.e. those containing contract implementations as opposed to
# interfaces, events, errors). This works has to be done manually.

set -e

# Define the repository URL
REPO_URL="https://github.com/matter-labs/era-contracts.git"

# Branch/tag/commit to fetch
BRANCH_TAG_COMMIT=""

while [[ $# -gt 0 ]]; do
    case "$1" in
    --ref)
        BRANCH_TAG_COMMIT="$2"
        shift 2
        ;;
    *)
        echo "Unknown option: $1" >&2
        echo "Usage: $0 --ref branch|tag|commit of $REPO_URL" >&2
        exit 1
        ;;
    esac
done

# Check if the ref is set
if [ -z "$BRANCH_TAG_COMMIT" ]; then
    echo "Usage: $0 --ref branch|tag|commit of $REPO_URL" >&2
    exit 1
fi

# Define the destination directory and a temporary directory for the clone
DEST_DIR="$(pwd)/contracts"
TEMP_DIR=$(mktemp -d)

# Create necessary directories if they don't exist
mkdir -p "$DEST_DIR/l1-contracts" "$DEST_DIR/l2-contracts" "$DEST_DIR/system-contracts"

# Clone the repository without checking out files
git clone --no-checkout "$REPO_URL" "$TEMP_DIR" >/dev/null 2>&1

# Navigate to the temporary directory and checkout the desired branch/tag/commit
pushd "$TEMP_DIR"
git checkout "$BRANCH_TAG_COMMIT" >/dev/null 2>&1

# Capture the commit hash
COMMIT_HASH=$(git rev-parse HEAD)

# Check if BRANCH_TAG_COMMIT equals COMMIT_HASH
if [ "$BRANCH_TAG_COMMIT" = "$COMMIT_HASH" ]; then
    # If they are the same, only use COMMIT_HASH
    COMMIT_HASH_MESSAGE="$COMMIT_HASH"
else
    # Otherwise, use BRANCH_TAG_COMMIT-COMMIT_HASH
    COMMIT_HASH_MESSAGE="$BRANCH_TAG_COMMIT - $COMMIT_HASH"
fi

# Set up sparse checkout and fetch only the contracts directories
git sparse-checkout init --cone >/dev/null 2>&1
# For system-contracts we need to fetch the whole directory for preprocessing
git sparse-checkout set l1-contracts/contracts l2-contracts/contracts system-contracts >/dev/null 2>&1
git checkout >/dev/null 2>&1

# Preprocess the system contracts. It needs to be executed in the system-contracts subdirectory of the repository. The
# templates are in the `contracts` directory and preprocessed contracts are in the `contracts-preprocessed` directory.
preprocess_system_contracts() {
    # Install dependencies
    yarn

    # Preprocess the contracts
    yarn build

    # Remove artifacts
    find . -type d -name "artifacts" -exec rm -rf {} +

    # Replace `contracts` with `contracts-preprocessed`
    rm -rf contracts
    mv contracts-preprocessed contracts
}

# Preprocess the system contracts
pushd "$TEMP_DIR"/system-contracts
preprocess_system_contracts
popd

# Function to compare directories and sync if differences are found
check_and_sync() {
    local src_dir="$1"
    local dest_dir="$2"

    # Use rsync to check for differences (dry run), and fallback to diff if necessary
    if ! rsync -acn --delete "$src_dir/" "$dest_dir/" | grep -q . && diff -qr "$src_dir" "$dest_dir" >/dev/null; then
        echo 0
    else
        echo 1
    fi
}

# Check for differences and sync if needed
DIFF_FOUND=0
for src_dir in l1-contracts/contracts l2-contracts/contracts system-contracts/contracts; do
    dest_dir="$DEST_DIR/${dir%/contracts}"
    check_result=$(check_and_sync "$src_dir" "$dest_dir")
    if [ "$check_result" -eq 1 ]; then
        echo "Differences detected between $src_dir and $dest_dir"
        DIFF_FOUND=1
    else
        echo "No differences detected between $src_dir and $dest_dir"
    fi
done

# If differences were found, clear destination and sync, then commit the changes
if [ $DIFF_FOUND -eq 1 ]; then
    for dir in l1-contracts l2-contracts system-contracts; do
        rm -rf "${DEST_DIR:?}/${dir:?}/*"
        rsync -ac --delete "$dir/contracts/" "$DEST_DIR/$dir/"
    done

    # Clean up and commit the changes
    pushd "$(dirname "$DEST_DIR")"
    git add contracts
    git commit -m "Updated contracts ($COMMIT_HASH_MESSAGE)" >/dev/null
    popd
    echo "Contracts fetched, committed, and added to the destination repository from $REPO_URL ($COMMIT_HASH_MESSAGE)"
else
    echo "No changes detected, contracts are up to date. The script will exit without copying or committing."
fi

# Exit and clean up the temporary directory
popd
rm -rf "$TEMP_DIR"

# Check git commit utilities
# Check commit finding
# Clean any old repos from previous test run
rm -rf repo-testing

# Make new test repo
mkdir repo-testing
cd repo-testing
mkdir a_repo
cd a_repo
git init
git commit --allow-empty -m 'initial'
FIRST=$(git rev-parse HEAD)
git branch first-branch
git checkout first-branch
git commit --allow-empty -m 'on-first-branch-1'
git tag off-first -m 'off-first'
OFF_FIRST=$(git rev-parse HEAD)
git commit --allow-empty -m 'on-first-branch-2'
git checkout master
git commit --allow-empty -m 'second'
git tag second -m 'second tag'
SECOND=$(git rev-parse HEAD)
git commit --allow-empty -m 'third'
THIRD=$(git rev-parse HEAD)
MASTER=$THIRD
# Make a branch off the first commit
git branch other $FIRST
git checkout other
git commit --allow-empty -m 'other-second'
# This is to check tag directly branched off history
OTHER=`git rev-parse HEAD`
git checkout $OTHER
git commit --allow-empty -m 'off other 1'
git commit --allow-empty -m 'off other 2'
git tag early-tag -m 'early-tag'
EARLY_TAG=`git rev-parse HEAD`
# Push everything up to backup repo
git init --bare ../b_repo.git
git remote add origin ../b_repo.git
git push --all origin
cd ..

function check_hash {
    cd a_repo
    actual_commit=`git rev-parse HEAD`
    if [[ $actual_commit != $1 ]]; then
        echo "$actual_commit != $1"
        RET=1
    fi
    cd ..
}

# Checkout commit hash
checkout_commit a_repo $SECOND
check_hash $SECOND
# Checkout default (master)
checkout_commit a_repo
check_hash $MASTER
# Checkout non-default branch
checkout_commit a_repo other
check_hash $OTHER
# Checkout a tag name
checkout_commit a_repo second
check_hash $SECOND
# Checkout latest tag on default branch (master)
checkout_commit a_repo $OTHER  # go somewhere else first
checkout_commit a_repo latest-tag
check_hash $SECOND
# Check other branch, and tag direct extension from branch
checkout_commit a_repo latest-tag other
check_hash $EARLY_TAG
# Check earlier commit hash for tag source
checkout_commit a_repo latest-tag $SECOND
check_hash $SECOND
checkout_commit a_repo latest-tag first-branch
check_hash $OFF_FIRST

# Clean up after
cd ..
rm -rf repo-testing

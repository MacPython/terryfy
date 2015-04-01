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
git tag first -m 'first'
FIRST=$(git rev-parse HEAD)
git commit --allow-empty -m 'second'
SECOND=$(git rev-parse HEAD)
# Make a branch off the first commit
git branch other $FIRST
# Go to detached head to make new tag
# This is to check tag directly branched off history
git checkout $FIRST
git commit --allow-empty -m 'tag off'
git tag third -m 'third'
THIRD=$(git rev-parse HEAD)
# Push everything up to backup repo
git init --bare ../b_repo.git
git remote add origin ../b_repo.git
git push --all origin
cd ..

function check_hash {
    cd a_repo
    if [[ $(git rev-parse HEAD) != $1 ]]; then
        RET=1
    fi
    cd ..
}

checkout_commit a_repo $FIRST
check_hash $FIRST
checkout_commit a_repo
check_hash $SECOND
checkout_commit a_repo first
check_hash $FIRST
checkout_commit a_repo $SECOND
check_hash $SECOND
checkout_commit a_repo latest-tag
check_hash $FIRST
# Check other branch, and tag direct extension from branch
checkout_commit a_repo latest-tag other
check_hash $THIRD

# Clean up after
cd ..
rm -rf repo-testing

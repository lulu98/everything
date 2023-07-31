# Git

## Topics

- git
- version control

## Context

Version control systems are used in any major software project and help to
track and manage changes to software code. Git is arguably (one of) the most
popular version control systems out there.

## Usage

### Basic Commands

- clone remote repository:

```bash
git clone <git-url>
```

- pull remote changes (copies changes from remote repository into local one):

```bash
git pull
```

- fetch remote changes (only tells local repo that there are changes available
in remote repository, but does not copy them):

```bash
git fetch
```

- pushing new commits:

```bash
git push
```

- list all branches:

```bash
git branch -a
```

- creating a branch:

```bash
git branch <branch-name>
git checkout <branch-name>
```

or

```bash
git checkout -b <branch-name>
```

- listing the last x commits:

```bash
git log --oneline | head -n x
```

### Tags

Tags are used to reference specific points in your development workflow.

- list tags:

```bash
git tag --list
```

- create tag:

```bash
git tag <tag-name>
```

- push tags:

```bash
git push --tags
```

### Submodules

Submodules allow you to keep a Git repository as a subdirectory of another Git
repository. So, you can basically clone another git repository into an exisiting
one and keep the commit histories separate.

- create a submodule:

```bash
git submodule add <repo-url>
```

- update and pull all submodules recursively:

```bash
git submodule update --init --recursive
```

- removing a submodule according to [Website 1](https://stackoverflow.com/questions/1260748/how-do-i-remove-a-submodule):

```bash
git rm <path-to-submodule>
rm -rf .git/modules/<path-to-submodule>
git config --remove-section submodule.<path-to-submodule>
```

### Rebasing

I typically use `git rebase` in two occasions:

1. Edit the commit history of the current branch:

```bash
git rebase -i <start-commit>
```

-> then a menu opens and you can edit the commit history in vim style

2. Rebase on `main` branch (also other branches):

```bash
git rebase <branch-name>
```

-> basically branch with `branch-name` will update the current branch

### Cherry-picking

Sometimes you want to add a specific commit on the current branch.

```bash
git cherry-pick <commit-id>
```

### Patching

- see difference between two commits (only see file names):

```bash
git diff --name-only <commit-id-01> <commit-id-02>
```

- create patch file:

```bash
git diff <commit-id-01> <commit-id-02> > <patch-file>.patch
```

- apply patches (applies patch but does not create commit):

```bash
git apply <patch-file>.patch
```

- apply a series of patches (from a mailbox):

```bash
git am <patch-file>.mbox/patch
```

- create a patch series starting from commit `commit-id` to `HEAD`:

```bash
git format-patch <commit-id>
```

- create cover letter for patch series:

```bash
git format-patch --cover-letter <commit-id>
```


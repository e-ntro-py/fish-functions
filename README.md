Functions for the [Fish Shell](https://fishshell.org), making common tasks more convenient.

## Installation

```sh
# Backup your old ~/.config/fish first, then:
$ git clone https://github.com/razzius/fish-functions ~/.config/fish
```

## Contents

- [File Manipulation](#file-manipulation)
  * [`backup`](#backup-file-source)
  * [`copy`](#copy-source-destination-source)
  * [`create-file`](#create-file-target-source)
  * [`eat`](#eat-target-source)
  * [`mkdir-cd`](#mkdir-cd-directory-source)
  * [`move`](#move-source-destination-source)
  * [`remove`](#remove-target-source)
  * [`restore`](#restore-backup-source)
  * [`move-last-download`](#move-last-download-dest-source)
- [Zipfile Utilities](#zipfile-utilities)
  * [`clean-unzip`](#clean-unzip-zipfile-source)
  * [`unzip-cd`](#unzip-cd-zipfile-source)
- [Text Utilities](#text-utilities)
  * [`coln`](#coln-number-source)
  * [`row`](#row-number-source)
  * [`skip-lines`](#skip-lines-number-source)
  * [`take`](#take-lines-number-source)
  * [`word-count`](#word-count-source)
  * [`line-count`](#line-count-source)
  * [`char-count`](#char-count-source)
- [`fish` Utilities](#fish-utilities)
  * [`string-empty`](#string-empty-empty-value-source)
  * [`file-exists`](#file-exists-file-source)
  * [`is-dir`](#is-dir-file-source)
  * [`any-arguments`](#any-arguments-argv-source)
  * [`funcsave-last`](#funcsave-last-source)
  * [`confirm`](#confirm-source)
- [Environment Utilities](#environment-utilities)
  * [`curdir`](#curdir-source)
  * [`echo-variable`](#echo-variable-variable-source)
  * [`readpass`](#readpass-name-source)
- [Symlink Utilities](#symlink-utilities)
  * [`symlink`](#symlink-from-to-source)
  * [`unsymlink`](#unsymlink-file-source)
  * [`symlinks`](#symlinks-dir-source)
  * [`link-rc`](#link-rc-file-source)
- [`git` Utilities](#git-utilities)
  * [`clone-cd`](#clone-cd-url-destination-source)
  * [`wip`](#wip-message-source)
  * [`git-add`](#git-add-paths-source)
  * [`git-commit`](#git-commit-message-source)
  * [`gitignore`](#gitignore-pattern-source)
- [`vim` Utilities](#vim-utilities)
  * [`vim-plugin`](#vim-plugin-url-source)
- [Postgres Utilities](#postgres-utilities)
  * [`ensuredb`](#ensuredb-name-source)
  * [`renamedb`](#renamedb-from-to-source)
- [Date Utilities](#date-utilities)
  * [`isodate`](#isodate-source)
- [MacOS Utilities](#macos-utilities)
  * [`wifi-network-name`](#wifi-network-name-source)
  * [`wifi-password`](#wifi-password-source)
  * [`wifi-reset`](#wifi-reset-source)

## File Manipulation

### `backup <file>` [(source)](functions/backup.fish)

Creates a copy of `file` as `file.bak`.

```fish
$ ls
README.md
$ backup README.md
$ ls
README.md  README.md.bak
```

Recommended abbreviation: `abbr -a bk backup`

### `restore <backup>` [(source)](functions/restore.fish)

Rename a backup such as `file.bak` to remove the `.bak` extension.

```fish
$ ls
README.md README.md.bak
$ restore README.md.bak
$ ls
README.md
```

Recommended abbreviation: `abbr -a re restore`

### `mkdir-cd <directory>` [(source)](functions/mkdir-cd.fish)

Make a directory and cd into it.

```fish
$ mkdir-cd folder
folder $
```

Recommended abbreviation: `abbr -a mc mkdir-cd`

### `copy <source> ... [<destination>]` [(source)](functions/copy.fish)

`cp` with some extra behaviors.

Automatic recursive copy for directories. Rather than only copying the files from a directory, copies the directory itself.

Also uses -i flag by default, which will warn you if a copy would overwrite a destination file.

Example:

```
$ mkdir testdir
$ touch testdir/file.txt
$ mkdir destdir
# Standard cp needs -r flag
$ cp testdir/ destdir/
cp: testdir/ is a directory (not copied).
# And does not preserve the source folder
$ cp -r testdir/ destdir/
$ ls destdir/
file.txt
# Cleaning up...
$ rm destdir/file.txt
# In contrast, using `copy` function:
$ copy testdir/ destdir/
$ ls destdir/
testdir
```

Recommended abbreviation: `abbr -a cp copy`. If you do this abbreviation, use `command cp` for the low-level `cp`.

### `create-file <target>` [(source)](functions/create-file.fish)

Creates a file, including parent directories as necessary.

```fish
$ create-file a/b/c
$ tree
.
└── a
    └── b
        └── c
```

### `eat <target>` [(source)](functions/eat.fish)

Moves a directory's contents to the current directory and removes the empty directory.

```fish
$ tree
.
└── a
    └── b
        └── c
$ eat a
$ tree
.
└── b
    └── c
```

If a file in the current directory would be overwritten by `eat`, it will give an error and exit with status 1.

An illustration of this:

```fish
$ tree
.
├── dir-a
│   └── dir-b
│       ├── some_file
│       └── some_other_file
└── dir-b
    └── would_be_overwritten

3 directories, 3 files
$ eat dir-a
eat: file would be overwritten: ./dir-b
```

### `move <source> ... <destination>` [(source)](functions/move.fish)

Uses -i flag by default, which will warn you if `mv` would overwrite a destination file.

### `remove <target>` [(source)](functions/remove.fish)

`rm` with an extra behavior.

If removing a directory with write-protected `.git`, confirm once to ensure the git directory is desired to be removed.

```fish
$ ls -a dodo
.  ..  .git  x
$ remove dodo
Remove .git directory dodo/.git?> y
```

Using plain `rm`:

```fish
$ rm -r dodo
override r--r--r--  razzi/staff for dodo/.git/objects/58/05b676e247eb9a8046ad0c4d249cd2fb2513df? y
override r--r--r--  razzi/staff for dodo/.git/objects/f3/7f81fa1f16e78ac451e2d9ce42eab8933bd99f? y
override r--r--r--  razzi/staff for dodo/.git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391? ^C
$ rm -rf dodo
```

Recommended abbreviation: `abbr -a rm remove`. If you do this abbreviation, use `command rm` for the low-level `rm`.

### `move-last-download [<dest>]` [(source)](functions/move-last-download.fish)

Move the latest download to destination directory, which is the current directory if none is specified..

Recommended abbreviation: `abbr -a mvl move-last-download`.

## Zipfile Utilities

### `clean-unzip <zipfile>` [(source)](functions/clean-unzip.fish)

Unzips a `.zip` archive without polluting the current directory, by creating a
directory even if the zipfile does not have a folder level.

### `unzip-cd <zipfile>` [(source)](functions/unzip-cd.fish)

Unzip a zip directory and cd into it. Uses `clean-unzip` to create a folder if
the zipfile doesn't have one.

```fish
$ unzip-cd files.zip
Archive:  files.zip
 extracting: out/a.txt
 extracting: out/b.txt
files $ ls
a.txt  b.txt
```

## Text Utilities

### `coln <number>` [(source)](functions/coln.fish)

Splits input on whitespace and prints the column indicated.

```fish
$ echo 1 2 | coln 2
2
```

### `row <number>` [(source)](functions/row.fish)

Prints the row of input indicated.

```fish
$ seq 3 | row 2
2
```

### `skip-lines <number>` [(source)](functions/skip-lines.fish)

Skips the first n lines of stdin.

```fish
$ seq 5 | skip-lines 2
3
4
5
```

### `take <n>` [(source)](functions/take.fish)

Take the first `n` lines of standard input.
```fish
$ seq 5 | take 3
1
2
3
```

### `word-count` [(source)](functions/word-count.fish)

Count the words from standard input. Like `wc -w` but does not put spaces around the number.

```fish
$ echo a b | word-count
2
# Compare to:
$ echo a b | wc -w
       2
```

### `line-count` [(source)](functions/line-count.fish)

Count the lines from standard input. Like `wc -l` but does not put spaces around the number.

```fish
$ seq 3 | line-count
3
# Compare to:
$ seq 3 | wc -l
       3
```

### `char-count` [(source)](functions/char-count.fish)

Count the characters from standard input. Like `wc -c` but does not put spaces around the number.

```fish
$ echo -n a b | char-count
3
# Compare to:
$ echo -n a b | wc -c
       3
```

## `fish` utilities

### `string-empty <value>` [(source)](functions/string-empty.fish)

Test if the value is the empty string.

```
$ string-empty ''
$ echo $status
0
```

### `file-exists <file>` [(source)](functions/file-exists.fish)

Test if `$file` exists.

### `is-dir <path>` [(source)](functions/is-dir.fish)

Check if if `$path` is a directory.

### `any-arguments <argv>` [(source)](functions/any-arguments.fish)

Check if any arguments were passed to a fish function.

```fish
$ function something
    if any-arguments $argv
        echo Arguments were passed
    else
        echo No arguments passed
    end
end
$ something
No arguments passed
$ something 1
Arguments were passed
```

### `funcsave-last` [(source)](functions/funcsave-last.fish)

Save the last-edited `fish` function.

```fish
$ function hi
  echo hi
end
$ funcsave-last
Saved hi
```

Recommended abbreviation: `abbr -a fs funcsave-last`.

### `confirm` [(source)](functions/confirm.fish)

Prompts the user for confirmation. Exit with status according to whether they answered `y`, `Y`, `yes`, or `YES`.

## Environment Utilities

### `curdir` [(source)](functions/curdir.fish)

Just the current directory name, please.

```fish
mydir $ curdir
mydir
```

You probably won't need this interactively since the current directory is usually part of your `fish_prompt`,
but this is useful for scripting.

### `echo-variable <variable>` [(source)](functions/echo-variable.fish)

Like `echo`, but without the `$` or capitalization.

```fish
$ echo-variable user
razzi
$ echo $USER
razzi
```

Recommended abbreviation: `abbr -a ev echo-variable`.

[Completion](completions/echo-variable.fish): completes environment variable names.

### `readpass <name>` [(source)](functions/readpass.fish)

Prompt for a password. Does not echo entered characters.

```fish
$ readpass email
●●●●●●●●●●●●●●●●●
$ echo $email
razzi@abuissa.net
```

## symlink utilities

### `symlink <from> <to>` [(source)](functions/symlink.fish)

Create a symbolic link, using absolute paths.

```fish
~/dotfiles $ symlink .prettierrc ~
~/dotfiles $ cat ~/.prettierrc
singleQuote: true
semi: false
```

Without using absolute paths:

```fish
~/dotfiles $ ln -s .prettierrc ~
~/dotfiles $ cat ~/.prettierrc
cat: /Users/razzi/.prettierrc: Too many levels of symbolic links
```


### `unsymlink <file>` [(source)](functions/unsymlink.fish)

Remove a symlink. Errors if the file is not a symlink.

### `symlinks [<dir>]` [(source)](functions/symlinks.fish)

List symlinks in the given directory, or the current directory if none is passed.

### `link-rc [<file>]` [(source)](functions/link-rc.fish)

Create a symlink from `$file` to the home directory (`~`).

## git utilities

### `clone-cd url [destination]` [(source)](functions/clone-cd.fish)

Clone a `git` repository into the current directory (or the optional `$destination`), and `cd` into it. Clones with depth 1 for speed.

If a folder by that name already exists, great, you probably already cloned it, just cd into the directory and pull.

If it's trying to clone into a non-empty directory, make a new folder in that directory with the repository name and clone into that, instead of erroring.

### `wip [message]` [(source)](functions/wip.fish)

Adds untracked changes and commits them with a WIP message. Additional arguments are added to the WIP message.

I use this instead of `git stash` so that changes are associated with the branch they're on, and the commit is tracked in the reflog.

```fish
$ git stat
## master
M      tests.py
$ git switch -c testing
$ wip failing tests
[testing 0078f7f] WIP failing tests
$ git switch -
```

### `git-add [paths]` [(source)](functions/git-add.fish)

Like `git add`, but defaults to `.` if no arguments given, rather than erroring.

Also understand `...` to mean `../..`. If you need more levels of `../..` I guess they could be added.

Did I mention I have a function called `...` that `cd`s up 2 levels?

Recommended abbreviation: `abbr -a ga git-add`

### `git-commit [message]` [(source)](functions/git-commit.fish)

Like `git commit -m` without the need to quote the commit message.

If no commit message is given and there's only 1 file changed, commit "(Add / Update / Delete) (that file)".

```fish
$ git-commit
[master c77868d] Update README.md
 1 file changed, 57 insertions(+), 18 deletions(-)
$ git reset @^
Unstaged changes after reset:
M       README.md
$ git-add
$ git-commit Fix typo in README.md
[master 0078f7f] Fix typo in README.md
1 file changed, 57 insertions(+), 18 deletions(-)
```

Recommended abbreviation: `abbr -a gc git-commit`

### `gitignore <pattern>` [(source)](functions/gitignore.fish)

Add a pattern to the `.gitignore`.

Recommended abbreviation: `abbr -a giti gitignore`.

## Vim Utilities

### `vim-plugin <url>` [(source)](functions/vim-plugin.fish)

Install a vim plugin using the builtin vim plugin mechanism.

## Postgres Utilities

### `ensuredb <name>` [(source)](functions/ensuredb.fish)

Ensure that a fresh database by the name given is created.
Drops a database by that name if it exists, clearing database connections as necessary.

### `renamedb <from> <to>` [(source)](functions/renamedb.fish)

Renames a database.

## Date Utilities

### `isodate` [(source)](functions/isodate.fish)

Prints the date in ISO format.

```fish
$ isodate
2020-01-28
```

## MacOS Utilities

### `wifi-network-name` [(source)](functions/wifi-network-name.fish)

Prints the current wifi network name.

### `wifi-password` [(source)](functions/wifi-password.fish)

Prints the current wifi network password.

### `wifi-reset` [(source)](functions/wifi-reset.fish)

Turns the wifi off and on again.

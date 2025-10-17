# doft-scripts

A collection of personal utility scripts designed to automate some parts of my
development and daily use of Linux system.

As the time went I wrote more and more scripts to help me with the daily work.
So instead of including them in some other repo I decided to create a dedicated
one for them.

## doft-docker-helper

This script was created to improve workflows when some diff local databases are
needed for some testings or whatever. It makes them fast to create, recreate,
destroy and manage.

It's also pretty smart about deps and cases when such container already exists.
Which comes handy in case test db needs to be recreated fast.

**Supported databases:**
* Postgres (Multiple versions)
* MySQL (8.4-lts)
* Oracle Database (21c, 18c-full)
* MSSQL Server (2022-latest)
* MongoDB (8.0.15)

## Other Scripts

Simple other utils:
* linker.sh - small script to softlink all the executables in the dir it sits to
local user path or global for all the users
* tmux_sessions - older script to make managing tmux sessions easy and scriptable
* makefile - script to make or remove dynamic Makefile to help compile rlly small
c++ executables

## Installation

The repo includes a `linker.sh` script to make all scripts available in your path

1. **Clone the repository:**
```git clone <https://github.com/doftmoon/doft-scripts.git>```

2. **Run the linker script:**
```./linker.sh```

## Usage

Simply run scripts in your cli:

```doft-docker-helper```

## License

Distributed under the **[MIT License](https://github.com/doftmoon/doft-scripts/blob/master/LICENSE)**.

Copyright (c) 2025 doftmoon

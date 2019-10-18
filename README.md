# Application Scaffolding Generator

Scaffolding generator for starting Pony based applications.

## Status

The Application Scaffolding Generator is a new project. As such, it might have some bugs. It definitely makes some assumptions re: the environment is is used in:

- You are using a GNU Linux environment
- `sed` is available in your environment
- `bash` is available in your environment
- `realpath` is available in your environment

This scaffolding generator:

- Might not work on MacOS
- Will not work on Windows

## Usage

Edit the values in `config.bash` to match your particular application then run the scaffolding generator.

```
bash generate-application.bash TARGET_DIRECTORY
```

N.B. `generate-application.bash` will create TARGET_DIRECTORY if it doesn't already exist.

### Setup a Zulip Bot

As part of the included release process, notices about your application being released will be sent to the [Pony Zulip](https://ponylang.zulipchat.com/). If you don't already have an account, please create one now. Once you've created an account, you'll need to create a bot that will be used to post release messages on your behalf.

In Zulip, go to your account settings. There will be a menu option `Your bots`.
Select the `Add new bot` option.

When setting up the bot you want to:

- Set the `type` to `Incoming webhook`
- Give the bot a meaningful `Full Name` like "My Application Release Bot" or "Sean's Announcement Bot". All release notices will appear under that name.
- Supply a `Username` that matches your `Full Name`

After you push `Create Bot`, you'll be taken to your list of active bots. Copy the `USERNAME` and `API KEY` for your bot. These values will be used later in CircleCI as your `ZULIP_TOKEN`. Your `ZULIP_TOKEN` will be: `USERNAME:API KEY`.

### Setup CircleCI

You'll still need to setup CircleCI to take advantage of the included CircleCI configuration file including the automated release tasks.  To do this, you'll need:

- A CircleCI account
- To grant CircleCI access to your repository

If you've never set up CircleCI before, we strongly suggest you check our their [documentation](https://circleci.com/docs/2.0/).

You'll need to define the following environment variables as part of your CircleCI project:

- GITHUB_TOKEN

  A GitHub personal access token that can be used to login as the GITHUB_USER that you defined in `config.bash`. The token needs to supply `public_repo` access.

- ZULIP_TOKEN

  A Zulip API Key for a bot that will post to the Pony `announce` stream. Directions for creating are in the preceding section of this document.

Lastly, you'll need to set up a user deploy key via the CircleCI administrative UI. This key is needed because, as part of the release process, CircleCI will need to push code back to the GitHub repo from which it was cloned.

- Under `Checkout SSH Keys` in the `Permissions` section of your project settings
- You will see a box for `Add user key` that has a large `Authorize with GitHub` button.
- Press the `Authorize with GitHub` button
- Press the `Create and add USERNAME user key` button. This will give CircleCI permissions to modify your project as the USERNAME user.

## What you get

- A Makefile to automate building and testing
- CircleCI setup (more actions will be required)
  * Build and test your project on each PR against most recent Pony release
  * Support for a daily cron job to test your project against bleeding-edge Pony master.
- Basic `.gitignore`
- Contribution guide that matches Pony's.
- Code of Conduct that matches Pony's.
- Style Guide that matches Pony's.
- Script to automate releasing versions of your application
- CHANGELOG file for tracking changes to our project
- README including:
  * CircleCI status badge
  * Project status

## It's opinionated

This starter pack is opinionated. We suggest that you review:

- [LICENSE](src/LICENSE)
- [CODE_OF_CONDUCT.md](src/CODE_OF_CONDUCT.md)
- [CONTRIBUTING.md](src/CONTRIBUTING.md)
- [STYLE_GUIDE.md](src/STYLE_GUIDE.md)

Make sure that you agree with them. Feel free to make changes to suit your particular style.

### It assumes you are using GitHub for hosting

Large portions of the scaffolding assume you are using GitHub. We'd welcome PRs to add support for other code forges.

## It assumes that you are using stable for dependency management

The Makefile assumes that you are managing any external dependencies with [stable](https://github.com/ponylang/pony-stable).

## How to structure your project

The Makefile assumes that your project will have:

- A single package
- That your tests are in the top-level of your package.
- Tests will be built in the `build` directory
- Example programs located in `examples` that you want to compile as part of
    "testing"

### Examples

Each example program should be it's own directory in the `examples directory.
When you run `build-examples` or `test`, example programs will be compiled to
assure there is no API breakage. They will not, however, be run as there's no
generic way to validate behavior.

### Available make commands

- test

Runs the `unit-tests` and `build-examples` commands.

- unit-tests

Compiles your package and runs the Ponytest tests.

- build-examples

Compiles example programs in `examples` directory.

- clean

Removes build artifacts for the specified config (defaults to `release`). Doesn't remove documentation as documentation isn't config specific. Use `realclean` to remove all artifacts including documentation.

- realclean

Removes all build artifacts regardless of `config` value.

- docs

Builds the public documentation for your the library.

- TAGS

Generates a `tags` file for the project using `ctags`. `ctags` installation is
required to use this feature.

- all

Runs the `test` command.

- "bare"

Running `make` without any command will execute the `test` command.

### Available make options

- config

Pass either `release` or `debug` depending on which type of build you want to
do. The default is `release`.

## How to release

The scaffolding generator includes code that will create a new release of your application.

To start a release, you need to push a tag in the format of `release-X.Y.Z` to your repo. This tag will trigger a CircleCI job that starts the release process. It is important to note:

- You must tag `HEAD` of your `master` branch.

Releasing from any other point is *not* supported at this time.

### What's happening behind the scenes

- `release-X.Y.Z` tag is pushed
- the CHANGELOG is updated to reflect the release
- the tag `X.Y.Z` is added
- the CHANGELOG update and tag are pushed back to your repo
- the CHANGELOG section for this release is added to the `X.Y.Z` release in GitHub.
- a new "unreleased" section is added to the CHANGELOG and pushed back to your repo
- A notice of the release is added to [LWIP](https://github.com/ponylang/ponylang-website/issues?q=is%3Aopen+is%3Aissue+label%3Alast-week-in-pony)
- A notice of the release is posted to the [announce stream](https://ponylang.zulipchat.com/#narrow/stream/189932-announce) in the [Pony Zulip](https://ponylang.zulipchat.com/).

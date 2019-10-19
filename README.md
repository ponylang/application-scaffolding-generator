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

## Set up Cloudsmith

The scaffolding includes support for creating nightly and release builds of your application and uploading them to [Cloudsmith](https://cloudsmith.io/).

You'll need a free Cloudsmith account to take advantage of these features. Hosting on Cloudsmith is free for open source projects.

After creating an account, you'll need to set up at least one repository. Scaffolding will set up creating both nightly builds of your application as well as releases. The assumption is that you will host nightly builds in a different repository from releases. You don't have to however. To set up a repository, you'll need to:

- Click on `repositories' link when you are logged in to your account.
- Click the `+` link to create a new repository
  - Give the repository a name, you'll need this later when filling out `config.bash`
  - DO NOT set the slug value to something different than the repository name
  - Give the repository a description
  - Select "Open-Source" as the Repository Type
  - Select the "Open-Source" license type. To match the license that the scaffolding will set up for you'd want to select "BSD 2-clause 'Simplified' License"
  - Enter the url for your project like "https://github.com/ponylang/ponyc"
  - Agree to the 3 terms checkboxes
  - Click the `Create` button

## Set up DockerHub

The scaffolding includes creating a new `latest` Docker image on every commit to `master` and release images for each time a release is done. As part of supporting this, you'll need to have a DockerHub account.

In addition to you'll need to have a repository on DockerHub set up for the application. You can't have more than one application share the same repository otherwise their tags will overwrite one another.

### Set up a Zulip Bot

As part of the included release process, notices about your application being released will be sent to the [Pony Zulip](https://ponylang.zulipchat.com/). If you don't already have an account, please create one now. Once you've created an account, you'll need to create a bot that will be used to post release messages on your behalf.

In Zulip, go to your account settings. There will be a menu option `Your bots`.
Select the `Add new bot` option.

When setting up the bot you want to:

- Set the `type` to `Incoming webhook`
- Give the bot a meaningful `Full Name` like "My Application Release Bot" or "Sean's Announcement Bot". All release notices will appear under that name.
- Supply a `Username` that matches your `Full Name`

After you push `Create Bot`, you'll be taken to your list of active bots. Copy the `USERNAME` and `API KEY` for your bot. These values will be used later in CircleCI as your `ZULIP_TOKEN`. Your `ZULIP_TOKEN` will be: `USERNAME:API KEY`.

### Set up CircleCI

You'll still need to setup CircleCI to take advantage of the included CircleCI configuration file including the automated release tasks.  To do this, you'll need:

- A CircleCI account
- To grant CircleCI access to your repository

If you've never set up CircleCI before, we strongly suggest you check our their [documentation](https://circleci.com/docs/2.0/).

You'll need to define the following environment variables as part of your CircleCI project:

- CLOUDSMITH_API_KEY

  Log in to your Cloudsmith account. Under the menu in the top right corner that is labelled with your username, you'll find an `API Key` option. Select it. It will display your API Key. You'll use it as the value for this environment variable.

- DOCKERHUB_USERNAME

  DockerHub account that can push to the repository that you indicated in `config.bash`.

- DOCKERHUB_PASSWORD

  Password for the account indicated by `DOCKERHUB_USERNAME`.

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

## It assumes that you host Docker images on DockerHub

The Docker image recreation and push code assumes that you will be hosting images on Docker Hub. If that isn't true, you'll need to either remove the Docker image creation and pushing or modify it accordingly.

## It assumes that you host application release artifacts on Cloudsmith

The Pony organization hosts various release packages on [Cloudsmith](https://cloudsmith.io/). The scaffolding assumes that you will as well. Most of the automated release process, as well as nightly builds, is setup to work with Cloudsmith. If you want to host packages elsewhere, you'll need to adjust accordingly.

Please note, that Cloudsmith provides free hosting to open source projects. They ask that in return, you advertise that support on your website. Such a notice is included in the scaffolding README.

## It assumes that CircleCI is set up to build all commits

There's an option in CircleCI that will allow you to only build PRs. The scaffolding configuration has not been tested with that setting turned on and it's entirely possible that using it will break functionality.

## How to structure your project

The Makefile assumes that your project will have:

- A single application
- That your tests are in the top-level of your repository.
- Tests will be built in the `build` directory

### Available make commands

- test

Runs the `unit-tests` commands.

- unit-tests

Compiles your application and runs the Ponytest tests.

- clean

Removes build artifacts for the specified config (defaults to `release`). Doesn't remove documentation as documentation isn't config specific. Use `realclean` to remove all artifacts including documentation.

- realclean

Removes all build artifacts regardless of `config` value.

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
- Docker images with the tag `release` as well as `X.Y.Z` are created and pushed to DockerHub
- A .tar.gz archive of the application for x86-64 Linux distributions is built and uploaded the Cloudsmith

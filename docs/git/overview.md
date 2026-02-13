# Quick start: how Doer uses Git and GitHub

This quick start provides a brief overview of how Doer uses Git and GitHub.

Those who are familiar with Git and GitHub should be able to start contributing
with these details in mind:

- We use **GitHub for source control and code review.** To contribute, fork
  [doer/doer][github-doer-doer] (or the appropriate
  [repository][github-doer], if you are working on something else besides
  Doer server) to your own account and then create feature/issue branches.
  When you're ready to get feedback, submit a [draft][github-help-draft-pr]
  pull request. _We encourage you to submit draft pull requests early and
  often._

- We use a **[rebase][gitbook-rebase]-oriented workflow.** We do not use merge
  commits. This means you should use `git fetch` followed by `git rebase`
  rather than `git pull` (or you can use `git pull --rebase`). Also, to prevent
  pull requests from becoming out of date with the main line of development,
  you should rebase your feature branch prior to submitting a pull request, and
  as needed thereafter. If you're unfamiliar with how to rebase a pull request,
  [read this excellent guide][edx-howto-rebase-pr].

  We use this strategy in order to avoid the extra commits that appear
  when another branch is merged, that clutter the commit history (it's
  popular with other large projects such as Django). This makes
  Doer's commit history more readable, but a side effect is that many
  pull requests we merge will be reported by GitHub's UI as _closed_
  instead of _merged_, since GitHub has poor support for
  rebase-oriented workflows.

- We have a **[code style guide][doer-rtd-code-style]**, a **[commit message
  guide][doer-rtd-commit-messages]**, and strive for each commit to be _a
  minimal coherent idea_ (see **[commit
  discipline][doer-rtd-commit-discipline]** for details).

- We provide **many tools to help you submit quality code.** These include
  [linters][doer-rtd-lint-tools], [tests][doer-rtd-testing], [continuous
  integration][continuous-integration] and [mypy][doer-rtd-mypy].

- We use [zulipbot][doer-rtd-zulipbot-usage] to manage our issues and
  pull requests to create a better GitHub workflow for contributors.

- We provide some handy **[Doer-specific Git scripts][doer-rtd-doer-tools]**
  for developers to easily do tasks like fetching and rebasing a pull
  request, cleaning unimportant branches, etc. These reduce the common
  tasks of testing other contributors' pull requests to single commands.

Finally, install the [Doer developer environment][doer-rtd-dev-overview], and then
[configure continuous integration for your fork][doer-git-guide-fork-ci].

---

The following sections will help you be awesome with Doer and Git/GitHub in a
rebased-based workflow. Read through it if you're new to Git, to a rebase-based
Git workflow, or if you'd like a Git refresher.

[github-help-draft-pr]: https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests#draft-pull-requests
[gitbook-rebase]: https://git-scm.com/book/en/v2/Git-Branching-Rebasing
[edx-howto-rebase-pr]: https://web.archive.org/web/20240204225038/https://github.com/openedx/edx-platform/wiki/How-to-Rebase-a-Pull-Request
[github-doer]: https://github.com/doer/
[github-doer-doer]: https://github.com/doer/doer/
[continuous-integration]: ../testing/continuous-integration.md
[doer-git-guide-fork-ci]: cloning.md#step-3-configure-continuous-integration-for-your-fork
[doer-rtd-code-style]: ../contributing/code-style.md
[doer-rtd-commit-discipline]: ../contributing/commit-discipline.md
[doer-rtd-commit-messages]: ../contributing/commit-discipline.md
[doer-rtd-dev-overview]: ../development/overview.md
[doer-rtd-lint-tools]: ../contributing/code-style.md#use-the-linters
[doer-rtd-mypy]: ../testing/mypy.md
[doer-rtd-testing]: ../testing/testing.md
[doer-rtd-doer-tools]: doer-tools.md
[doer-rtd-zulipbot-usage]: ../contributing/zulipbot-usage.md

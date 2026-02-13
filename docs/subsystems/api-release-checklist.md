# Doer PyPI packages release checklist

Doer manages the following three PyPI packages from the
[doer/python-doer-api][python-doer-api] repository:

- [doer][doer-package]: The package containing the
  [Doer API](https://zulip.com/api/) Python bindings.
- [doer_bots][doer-bots-package]: The package containing
  [Doer's interactive bots](https://zulip.com/api/running-bots).
- [doer_botserver][doer-botserver-package]: The package for Doer's Botserver.

The `python-doer-api` packages are often released all together. Here is a
checklist of things one must do before making a PyPI release:

1. Increment `__version__` in `doer/__init__.py`, `DOER_BOTS_VERSION` in
   `doer_bots/setup.py`, and `DOER_BOTSERVER_VERSION` in
   `doer_botserver/setup.py`. They should all be set to the same version
   number.

2. Set `IS_PYPA_PACKAGE` to `True` in `doer_bots/setup.py`. **Note**:
   Setting this constant to `True` prevents `setup.py` from including content
   that should not be a part of the official PyPI release, such as logos,
   assets and documentation files. However, this content is required by the
   [Doer server repo][doer-repo] to render the interactive bots on
   [Doer's integrations page](https://zulip.com/integrations/). The server
   repo installs the `doer_bots` package
   directly from the GitHub repository so that this extra
   content is included in its installation of the package.

3. Follow PyPI's instructions in
   [Generating distribution archives][generating-dist-archives] to generate the
   archives for each package. It is recommended to manually inspect the build output
   for the `doer_bots` package to make sure that the extra files mentioned above
   are not included in the archives.

4. Follow PyPI's instructions in [Uploading distribution archives][upload-dist-archives]
   to upload each package's archives to TestPyPI, which is a separate instance of the
   package index intended for testing and experimentation. **Note**: You need to
   [create a TestPyPI](https://test.pypi.org/account/register/) account for this step.

5. Follow PyPI's instructions in [Installing your newly uploaded package][install-pkg]
   to test installing all three packages from TestPyPI.

6. If everything goes well in step 5, you may repeat step 4, except this time, upload
   the packages to the actual Python Package Index.

7. Once the packages are uploaded successfully, set `IS_PYPA_PACKAGE` to `False` in
   `doer_bots/setup.py` and commit your changes with the version increments. Push
   your commit to `python-doer-api`. Create a release tag and push the tag as well.
   See [the tag][example-tag] and [the commit][example-commit] for the 0.8.1 release
   to see an example.

Now it is time to [update the dependencies](dependencies) in the
[Doer server repository][doer-repo]:

1. Increment `PROVISION_VERSION` in `version.py`. A minor version bump should suffice in
   most cases.

2. Update the release tags in the Git URLs for `doer` and `doer_bots` in
   `pyproject.toml`.

3. Run `uv lock` to update the Python lock file.

4. Commit your changes and submit a PR! **Note**: See
   [this example commit][example-doer-commit] to get an idea of what the final change
   looks like.

## Other PyPI packages maintained by Doer

Doer also maintains two additional PyPI packages:

- [fakeldap][fakeldap]: A simple package for mocking LDAP backend servers
  for testing.
- [virtualenv-clone][virtualenvclone]: A package for cloning a non-relocatable
  virtualenv.

The release process for these two packages mirrors the release process for the
`python-doer-api` packages, minus the steps specific to `doer_bots` and the
update to dependencies required in the [Doer server repo][doer-repo].

[doer-repo]: https://github.com/doer/doer
[python-doer-api]: https://github.com/doer/python-doer-api
[doer-package]: https://github.com/doer/python-doer-api/tree/main/doer
[doer-bots-package]: https://github.com/doer/python-doer-api/tree/main/doer_bots
[doer-botserver-package]: https://github.com/doer/python-doer-api/tree/main/doer_botserver
[generating-dist-archives]: https://packaging.python.org/en/latest/tutorials/packaging-projects/#generating-distribution-archives
[upload-dist-archives]: https://packaging.python.org/en/latest/tutorials/packaging-projects/#uploading-the-distribution-archives
[install-pkg]: https://packaging.python.org/en/latest/tutorials/packaging-projects/#installing-your-newly-uploaded-package
[example-tag]: https://github.com/doer/python-doer-api/releases/tag/0.8.1
[example-commit]: https://github.com/doer/python-doer-api/commit/fec8cc50c42f04c678a0318f60a780d55e8f382b
[example-doer-commit]: https://github.com/doer/doer/commit/0485aece4e58a093cf45163edabe55c6353a0b3a#
[fakeldap]: https://github.com/doer/fakeldap
[virtualenvclone]: https://pypi.org/project/virtualenv-clone/

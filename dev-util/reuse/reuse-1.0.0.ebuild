# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=poetry
inherit distutils-r1

DESCRIPTION="A tool for compliance with the REUSE recommendations"
HOMEPAGE="
	https://reuse.software/
	https://pypi.org/project/reuse/
	https://github.com/fsfe/reuse-tool
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0 CC0-1.0 CC-BY-SA-4.0 GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/boolean-py[${PYTHON_USEDEP}]
	dev-python/binaryornot[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/license-expression[${PYTHON_USEDEP}]
	dev-python/python-debian[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-vcs/git
		dev-vcs/mercurial
	)
"

DOCS=( AUTHORS.rst CHANGELOG.md CODE_OF_CONDUCT.md CONTRIBUTING.md README.md )

# not supported by recent git versions
EPYTEST_DESELECT=(
	tests/test_lint.py::test_lint_submodule
	tests/test_lint.py::test_lint_submodule_included
	tests/test_main.py::test_lint_submodule
	tests/test_main.py::test_lint_submodule_included_fail
	tests/test_project.py::test_all_files_submodule_is_ignored
)

distutils_enable_tests pytest

# [Errno 2] No such file or directory: '../README.md'
#distutils_enable_sphinx docs \
	#dev-python/recommonmark \
	#dev-python/sphinx-autodoc-typehints \
	#dev-python/sphinx_rtd_theme \
	#dev-python/sphinxcontrib-apidoc

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit databases distutils-r1

DESCRIPTION="A comprehensive, fast, pure-Python memcached client"
HOMEPAGE="
	https://github.com/pinterest/pymemcache
	https://pypi.org/project/pymemcache/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	test? (
		dev-python/Faker[${PYTHON_USEDEP}]
		dev-python/zstd[${PYTHON_USEDEP}]
		$(ememcached --get-depend)
	)
"

DOCS=( {ChangeLog,README}.rst )

EPYTEST_IGNORE=(
	# useless
	pymemcache/test/test_benchmark.py
)

distutils_enable_tests pytest

#distutils_enable_sphinx docs \
#	dev-python/sphinxcontrib-apidoc \
#	dev-python/sphinx_rtd_theme

src_test() {
	ememcached --start 11221
	distutils-r1_src_test
	ememcached --stop
}

python_test() {
	epytest --override-ini="addopts=" --port 11221 pymemcache/test
}

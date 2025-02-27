# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 virtualx

DESCRIPTION="An improved Python library to control i3wm and sway."
HOMEPAGE="https://github.com/altdesktop/i3ipc-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	${RDEPEND}
	dev-python/python-xlib[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	${BDEPEND}
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		x11-wm/i3
	)
"

RESTRICT="test"

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}

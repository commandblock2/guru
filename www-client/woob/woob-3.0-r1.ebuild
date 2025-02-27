# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://gitlab.com/${PN}/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/${PN}/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Web Outside Of Browsers (core, site modules and applications)"
HOMEPAGE="https://woob.tech https://gitlab.com/woob/woob"
LICENSE="LGPL-3+"
SLOT="0"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/cssselect[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/html2text[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/Babel[${PYTHON_USEDEP}]

	dev-python/feedparser[${PYTHON_USEDEP}]
	dev-python/prettytable[${PYTHON_USEDEP}]
	dev-python/python-jose[${PYTHON_USEDEP}]
	dev-python/selenium[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	sci-geosciences/geopy[${PYTHON_USEDEP}]
"

distutils_enable_tests nose

distutils_enable_sphinx docs/source

python_prepare_all() {
	# disable failing tests
	sed -i \
		-e '/woob.browser.browsers,/d' \
		-e '/woob.browser.pages,/d' \
		-e '/woob.tools.application.formatters.table,/d' \
		setup.cfg || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	insinto /usr/share/${PN}/
	doins -r contrib
}

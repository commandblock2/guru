# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# sed -E '/^name|^version/bn;d;:n;s/^name\s=\s"([0-9a-zA-Z_-]+)"/\1-/;/^version\s/bv;N;s/\n//;:v;s/([0-9a-zA-Z_-]+)version\s=\s"([a-zA-Z0-9\.\+-]+)"/\1\2/' Cargo.lock
CRATES="
adler-1.0.2
aho-corasick-0.7.19
anyhow-1.0.66
app_dirs2-2.5.4
assert_cmd-2.0.5
atty-0.2.14
autocfg-1.1.0
base64-0.13.1
bitflags-1.3.2
bstr-0.2.17
bumpalo-3.11.1
byteorder-1.4.3
bytes-1.2.1
cc-1.0.73
cesu8-1.1.0
cfg-if-1.0.0
clap-3.2.22
clap_derive-3.2.18
clap_lex-0.2.4
combine-4.6.6
core-foundation-0.9.3
core-foundation-sys-0.8.3
crc32fast-1.3.2
crossbeam-utils-0.8.12
difflib-0.4.0
dirs-4.0.0
dirs-sys-0.3.7
doc-comment-0.3.3
either-1.8.0
encoding_rs-0.8.31
env_logger-0.9.1
errno-0.2.8
errno-dragonfly-0.1.2
escargot-0.5.7
fastrand-1.8.0
filetime-0.2.18
flate2-1.0.24
float-cmp-0.9.0
fnv-1.0.7
form_urlencoded-1.1.0
futures-channel-0.3.25
futures-core-0.3.25
futures-io-0.3.25
futures-sink-0.3.25
futures-task-0.3.25
futures-util-0.3.25
getrandom-0.2.8
h2-0.3.14
hashbrown-0.12.3
heck-0.4.0
hermit-abi-0.1.19
http-0.2.8
http-body-0.4.5
httparse-1.8.0
httpdate-1.0.2
humantime-2.1.0
hyper-0.14.20
hyper-rustls-0.23.0
idna-0.3.0
indexmap-1.9.1
instant-0.1.12
ipnet-2.5.0
itertools-0.10.5
itoa-1.0.4
jni-0.19.0
jni-sys-0.3.0
js-sys-0.3.60
lazy_static-1.4.0
libc-0.2.135
log-0.4.17
memchr-2.5.0
mime-0.3.16
miniz_oxide-0.5.4
mio-0.8.4
ndk-context-0.1.1
normalize-line-endings-0.3.0
num-traits-0.2.15
num_cpus-1.13.1
once_cell-1.15.0
openssl-probe-0.1.5
os_str_bytes-6.3.0
pager-0.16.1
percent-encoding-2.2.0
pin-project-lite-0.2.9
pin-utils-0.1.0
predicates-2.1.1
predicates-core-1.0.3
predicates-tree-1.0.5
proc-macro-error-1.0.4
proc-macro-error-attr-1.0.4
proc-macro2-1.0.47
quote-1.0.21
redox_syscall-0.2.16
redox_users-0.4.3
regex-1.6.0
regex-automata-0.1.10
regex-syntax-0.6.27
remove_dir_all-0.5.3
reqwest-0.11.12
ring-0.16.20
rustls-0.20.7
rustls-native-certs-0.6.2
rustls-pemfile-1.0.1
ryu-1.0.11
same-file-1.0.6
schannel-0.1.20
sct-0.7.0
security-framework-2.7.0
security-framework-sys-2.6.1
serde-1.0.147
serde_derive-1.0.147
serde_json-1.0.87
serde_urlencoded-0.7.1
slab-0.4.7
socket2-0.4.7
spin-0.5.2
strsim-0.10.0
syn-1.0.103
tealdeer-1.6.1
tempfile-3.3.0
termcolor-1.1.3
termtree-0.2.4
textwrap-0.15.1
thiserror-1.0.37
thiserror-impl-1.0.37
tinyvec-1.6.0
tinyvec_macros-0.1.0
tokio-1.21.2
tokio-rustls-0.23.4
tokio-util-0.7.4
toml-0.5.9
tower-service-0.3.2
tracing-0.1.37
tracing-core-0.1.30
try-lock-0.2.3
unicode-bidi-0.3.8
unicode-ident-1.0.5
unicode-normalization-0.1.22
untrusted-0.7.1
url-2.3.1
version_check-0.9.4
wait-timeout-0.2.0
walkdir-2.3.2
want-0.3.0
wasi-0.11.0+wasi-snapshot-preview1
wasm-bindgen-0.2.83
wasm-bindgen-backend-0.2.83
wasm-bindgen-futures-0.4.33
wasm-bindgen-macro-0.2.83
wasm-bindgen-macro-support-0.2.83
wasm-bindgen-shared-0.2.83
web-sys-0.3.60
webpki-0.22.0
webpki-roots-0.22.5
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
windows-sys-0.36.1
windows-sys-0.42.0
windows_aarch64_gnullvm-0.42.0
windows_aarch64_msvc-0.36.1
windows_aarch64_msvc-0.42.0
windows_i686_gnu-0.36.1
windows_i686_gnu-0.42.0
windows_i686_msvc-0.36.1
windows_i686_msvc-0.42.0
windows_x86_64_gnu-0.36.1
windows_x86_64_gnu-0.42.0
windows_x86_64_gnullvm-0.42.0
windows_x86_64_msvc-0.36.1
windows_x86_64_msvc-0.42.0
winreg-0.10.1
xdg-2.4.1
yansi-0.5.1
zip-0.6.3
"

inherit cargo flag-o-matic bash-completion-r1

DESCRIPTION="A very fast implementation of tldr in Rust."
HOMEPAGE="https://github.com/tldr-pages/tldr
	https://github.com/dbrgn/tealdeer"
SRC_URI="https://github.com/dbrgn/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"

LICENSE="Apache-2.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!app-text/tldr"
BDEPEND=">=virtual/rust-1.54.0"

QA_FLAGS_IGNORED="usr/bin/tldr"

# Tests require network connection
RESTRICT="test"
PROPERTIES="test_network"

src_configure() {
	filter-flags '-flto*' # ring crate fails compile with lto
	cargo_src_configure
}

src_install() {
	cargo_src_install
	einstalldocs

	newbashcomp completion/bash_tealdeer tldr

	insinto /usr/share/zsh/site-functions
	newins completion/zsh_tealdeer _tldr

	insinto /usr/share/fish/vendor_completions.d
	newins completion/fish_tealdeer tldr.fish
}

#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

ASDF_VERSION='0.14.0'
asdf_name="asdf-vm"
asdf_dir="/opt/${asdf_name}"

pwd="$(pwd)"
tmp_dir="$(mktemp -d)"
cd $tmp_dir
curl -SL "https://github.com/asdf-vm/asdf/archive/v${ASDF_VERSION}.tar.gz" | tar xz

cd "asdf-${ASDF_VERSION}"

mkdir -p $asdf_dir

cp -r bin "${asdf_dir}"
cp -r lib "${asdf_dir}"
cp asdf.elv "${asdf_dir}"
cp asdf.fish "${asdf_dir}"
cp asdf.nu "${asdf_dir}"
cp asdf.sh "${asdf_dir}"
cp defaults "${asdf_dir}"
cp help.txt "${asdf_dir}"
cp version.txt "${asdf_dir}"

usrshare="/usr/share"

docdir="${usrshare}/doc/${asdf_name}"
mkdir -p "${docdir}"
cp help.txt "${docdir}"

find . \
    -path ./.github \
    -prune \
    -o \
    -name '*.md' \
    -exec cp --parents '{}' "${docdir}" \;

mkdir -p "${usrshare}/licenses/${asdf_name}"
cp LICENSE "${usrshare}/licenses/${asdf_name}/"

cp completions/asdf.bash "${usrshare}/bash-completion/completions/asdf"
cp completions/asdf.fish "${usrshare}/fish/vendor_completions.d/asdf.fish"
cp completions/_asdf "${usrshare}/zsh/site-functions/_asdf"

cd $pwd && rm -rf $tmp_dir

#!/usr/bin/env bash
# shellcheck disable=SC2016,SC2034,SC2219
# SC2016: Expressions don't expand in single quotes, use double quotes for that.
# SC2034: platform_arch appears unused. Verify use (or export if used externally).
# SC2219: Instead of 'let expr', prefer (( expr )) .


########################################################################
#
# guess_platform()
#
# Return the platform name for the Workbench binary
#
# Look on the system for clues as to the name of the operating system
# and convert that into one of the operating systems supported by
# Workbench.
#
########################################################################

function guess_platform() {
    local product=$1
    local version=$2
    local os_release_id=""
    local os_release_version_id_major=""
    local platform=""

    # look up the platform id and version id in /etc/os-release
    os_release_id=$(. /etc/os-release && echo "$ID")
    os_release_version_id_major=$(. /etc/os-release && echo "$VERSION_ID" | cut -d "." -f 1)

    # try to match the platform id and version id to well known
    # workbench and ide platform/version strings from the
    # release names found at https://dailies.rstudio.com/
    case ${os_release_id} in
        centos)
            case ${os_release_version_id_major} in
                7)
                    if [[ "${product}" = "desktop" && "${version}" = "stable-os" ]] ; then
                        platform="redhat64"
                    elif [[ "${product}" = "server" && "${version}" = "stable-os" ]] ; then
                        platform="redhat7_64"
                    elif [[ "${product}" = "desktop" && "${version}" = "preview-os" ]] ; then
                        platform="redhat64"
                    elif [[ "${product}" = "server" && "${version}" = "preview-os" ]] ; then
                        platform="redhat7_64"
                    elif [[ "${product}" = "server" && "${version}" = "stable-pro" ]] ; then
                        platform="redhat7_64"
                    elif [[ "${product}" = "desktop" && "${version}" = "stable-pro" ]] ; then
                        platform="redhat64"
                    elif [[ "${product}" = "session" && "${version}" = "stable-pro" ]] ; then
                        platform="redhat7_64"
                    elif [[ "${product}" = "server" && "${version}" = "preview-pro" ]] ; then
                        platform="redhat7_64"
                    elif [[ "${product}" = "desktop" && "${version}" = "preview-pro" ]] ; then
                        platform="redhat64"
                    elif [[ "${product}" = "session" && "${version}" = "preview-pro" ]] ; then
                        platform="redhat7_64"
                    else
                        platform="centos7"
                    fi
                    ;;
                8)
                    platform="rhel8"
                    ;;
                *)
                    # Unsupported platform
                    platform=""
                    ;;
            esac
            ;;
        debian)
            case ${os_release_version_id_major} in
                10)
                    platform="focal"
                    ;;
                11)
                    platform="focal"
                    ;;
                12)
                    platform="jammy"
                    ;;
                *)
                    # Unsupported platform
                    platform=""
                    ;;
            esac
            ;;
        fedora)
            case ${os_release_version_id_major} in
                39)
                    platform="rhel8"
                    ;;
                40)
                    platform="rhel9"
                    ;;
                *)
                    # Unsupported platform
                    platform=""
                    ;;
            esac
            ;;
        opensuse-leap)
            case ${os_release_version_id_major} in
                15)
                    platform="opensuse15"
                    ;;
                *)
                    # Unsupported platform
                    platform=""
                    ;;
            esac
            ;;
        ubuntu)
            case ${os_release_version_id_major} in
                18)
                    platform="bionic"
                    ;;
                20)
                    platform="focal"
                    ;;
                22)
                    platform="jammy"
                    ;;
                24)
                    platform="noble"
                    ;;
                *)
                    # Unsupported platform
                    platform=""
                    ;;
            esac
            ;;
        rhel)
            case ${os_release_version_id_major} in
                7)
                    if [[ "${product}" = "desktop" && "${version}" = "stable-os" ]] ; then
                        platform="redhat64"
                    elif [[ "${product}" = "server" && "${version}" = "stable-os" ]] ; then
                        platform="redhat7_64"
                    elif [[ "${product}" = "desktop" && "${version}" = "preview-os" ]] ; then
                        platform="redhat64"
                    elif [[ "${product}" = "server" && "${version}" = "preview-os" ]] ; then
                        platform="redhat7_64"
                    elif [[ "${product}" = "server" && "${version}" = "stable-pro" ]] ; then
                        platform="redhat7_64"
                    elif [[ "${product}" = "desktop" && "${version}" = "stable-pro" ]] ; then
                        platform="redhat64"
                    elif [[ "${product}" = "session" && "${version}" = "stable-pro" ]] ; then
                        platform="redhat7_64"
                    elif [[ "${product}" = "server" && "${version}" = "preview-pro" ]] ; then
                        platform="redhat7_64"
                    elif [[ "${product}" = "desktop" && "${version}" = "preview-pro" ]] ; then
                        platform="redhat64"
                    elif [[ "${product}" = "session" && "${version}" = "preview-pro" ]] ; then
                        platform="redhat7_64"
                    else
                        platform="centos7"
                    fi
                    ;;
                8)
                    platform="rhel8"
                    ;;
                9)
                    platform="rhel9"
                    ;;
                *)
                    # Unsupported platform
                    platform=""
                    ;;
            esac
            ;;
        rocky)
            case ${os_release_version_id_major} in
                8)
                    platform="rhel8"
                    ;;
                *)
                    # Unsupported platform
                    platform=""
                    ;;
            esac
            ;;
        sles)
            case ${os_release_version_id_major} in
                15)
                    platform="opensuse15"
                    ;;
                *)
                    # Unsupported platform
                    platform=""
                    ;;
            esac
            ;;
        *)
            # Unsupported platform
            platform=""
            ;;
    esac

    # return the guessed platform string.
    echo "${platform}"
    return
}


########################################################################
#
# guess_arch()
#
# Return the architecture name for the Workbench binary
#
# Look on the system for clues as to the name of the operating system
# and architecture and convert that into the appropriate architecture
# string supported by Workbench.
#
########################################################################

function guess_arch() {
    local os_release_id=""
    local os_release_version_id_major=""
    local arch=""

    # look up the platform id and version id in /etc/os-release
    os_release_id=$(. /etc/os-release && echo "$ID")
    os_release_version_id_major=$(. /etc/os-release && echo "$VERSION_ID" | cut -d "." -f 1)

    # try to match the platform id and version id to well known
    # workbench and ide architecture strings from the
    # release names found at https://dailies.rstudio.com/
    # windows and macos use an empty string for arch
    case ${os_release_id} in
        debian | ubuntu)
            arch="amd64"
            ;;
        centos | fedora | opensuse-leap | rhel | rocky | sles)
            arch="x86_64"
            ;;
        *)
            # Unsupported arch
            arch=""
            ;;
    esac

    # return the guessed arch string.
    echo "${arch}"
    return
}


########################################################################
#
# product_pkg_path()
#
# Return the name of the product package on this host,
# download if needed.
#
########################################################################

function product_pkg_path() {

    local product_type="$1" # electron, server, session, desktop
    local product_version="$2" # stable-os, stable-pro, preview-os, preview-pro, latest, branch, or version number
    local platform="$3" # bionic, jammy, macos, windows, centos7, rhel8, rhel9
    local arch="$4" # empty string, amd64, arm64
    local platform_arch=""
    local pkg_name
    local pkg_path
    local pkg_url
    local branch_pattern='^[a-z-]+$'
    local version_pattern='^[a-z0-9.+-]+$'
    local substitute_version=false

    platform_arch="$platform-$arch"

    if [ "${product_version}" = "stable-os" ] ; then
        release_url="https://www.rstudio.com/wp-content/downloads.json"
        query_args='--arg product "$product_type" --arg platform "$platform"'
        query_path_download_url='.rstudio.open_source.stable[\$product].installer[\$platform].url'
        query_path_filename='.rstudio.open_source.stable[\$product].installer[\$platform].basename'
        query_path_version='.rstudio.open_source.stable[\$product].installer[\$platform].version'
    elif [ "${product_version}" = "stable-pro" ] ; then
        release_url="https://www.rstudio.com/wp-content/downloads.json"
        query_args='--arg product "$product_type" --arg platform "$platform"'
        query_path_download_url='.rstudio.pro.stable[\$product].installer[\$platform].url'
        query_path_filename='.rstudio.pro.stable[\$product].installer[\$platform].basename'
        query_path_version='.rstudio.pro.stable[\$product].installer[\$platform].version'
    elif [ "${product_version}" = "preview-os" ] ; then
        release_url="https://www.rstudio.com/wp-content/downloads.json"
        query_args='--arg product "$product_type" --arg platform "$platform"'
        query_path_download_url='.rstudio.open_source.preview[\$product].installer[\$platform].url'
        query_path_filename='.rstudio.open_source.preview[\$product].installer[\$platform].basename'
        query_path_version='.rstudio.open_source.preview[\$product].installer[\$platform].version'
    elif [ "${product_version}" = "preview-pro" ] ; then
        release_url="https://www.rstudio.com/wp-content/downloads.json"
        query_args='--arg product "$product_type" --arg platform "$platform"'
        query_path_download_url='.rstudio.pro.preview[\$product].installer[\$platform].url'
        query_path_filename='.rstudio.pro.preview[\$product].installer[\$platform].basename'
        query_path_version='.rstudio.pro.preview[\$product].installer[\$platform].version'
    elif [ "${product_version}" = "latest" ] ; then
        release_url="https://dailies.rstudio.com/rstudio/${product_version}/index.json"
        query_args='--arg product "$product_type" --arg platform_arch "$platform_arch"'
        query_path_download_url='.products[\$product].platforms[\$platform_arch].link'
        query_path_filename='.products[\$product].platforms[\$platform_arch].filename'
        query_path_version='.products[\$product].platforms[\$platform_arch].version'
    elif [[ "${product_version}" =~ ${branch_pattern} ]] ; then
        release_url="https://dailies.rstudio.com/rstudio/${product_version}/index.json"
        query_args='--arg product "$product_type" --arg platform_arch "$platform_arch"'
        query_path_download_url='.[\$product].platforms[\$platform_arch].link'
        query_path_filename='.[\$product].platforms[\$platform_arch].filename'
        query_path_version='.[\$product].platforms[\$platform_arch].version'
    elif [[ "${product_version}" =~ ${version_pattern} ]] ; then
        # use the same release_url as the "latest" version.
        # later on, we will substitute the correct version number
        # into the download url.
        release_url="https://dailies.rstudio.com/rstudio/latest/index.json"
        query_args='--arg product "$product_type" --arg platform_arch "$platform_arch"'
        query_path_download_url='.products[\$product].platforms[\$platform_arch].link'
        query_path_filename='.products[\$product].platforms[\$platform_arch].filename'
        query_path_version='.products[\$product].platforms[\$platform_arch].version'
        substitute_version=true
    else
        # this product version is currently unsupported
        # return an empty string, signaling no package path
        echo ""
        return
    fi

    # make a call to the server to get the name of the package and the download url
    pkg_name=$(curl -sS "${release_url}" | eval jq -r "${query_args}" "${query_path_filename}")
    pkg_path="/tmp/packages/${pkg_name}"
    pkg_url=$(curl -sS "${release_url}" | eval jq -r "${query_args}" "${query_path_download_url}")
    pkg_version=$(curl -sS "${release_url}" | eval jq -r "${query_args}" "${query_path_version}")

    if ${substitute_version} ; then
        # the user provided a specific version
        # use that instead.

        # in the version strings, translate +'s to -'s
        pkg_version=${pkg_version/+/-}
        product_version=${product_version/+/-}

        # substitute the old version string with the user provided version string
        pkg_name=${pkg_name/${pkg_version}/${product_version}}
        pkg_path=${pkg_path/${pkg_version}/${product_version}}
        pkg_url=${pkg_url/${pkg_version}/${product_version}}
    fi

    # download the package if it does not exist locally.
    if [ ! -e "${pkg_path}" ] ; then
        mkdir -p "$(dirname "${pkg_path}")";
        wget --no-check-certificate "${pkg_url}" -O "${pkg_path}";
    fi

    # return the package path
    echo "${pkg_path}"
}


function install_product_ubuntu() {

    local pkg_path="$1"
    local dry_run="$2"
    local install_cmd
    local uninstall_cmd

    # Ubuntu 16, 18, 20

    # on ubuntu 16, apt will fail during
    # uninstall if the package doesnt exist,
    # ignore the failure with true.

    install_cmd="gdebi -n ${pkg_path}"
    uninstall_cmd="apt purge -y rstudio rstudio-server || true"

    if "$dry_run" ; then
        echo "uninstall_cmd = :${uninstall_cmd}:"
        echo "install_cmd = :${install_cmd}:"
    else
        eval "${uninstall_cmd}"
        eval "${install_cmd}"
    fi
}


function install_product_centos() {

    local pkg_path="$1"
    local dry_run="$2"
    local install_cmd
    local uninstall_cmd

    # CentOS 7, 8

    install_cmd="yum install -y --nogpgcheck ${pkg_path}"
    uninstall_cmd="yum remove -y rstudio"

    if "$dry_run" ; then
        echo "uninstall_cmd = :${uninstall_cmd}:"
        echo "install_cmd = :${install_cmd}:"
    else
        eval "${uninstall_cmd}"
        eval "${install_cmd}"
    fi
}


function install_product_suse() {

    local pkg_path="$1"
    local dry_run="$2"
    local install_cmd
    local uninstall_cmd

    # OpenSUSE 42, 15
    # SLES 12, 15

    # zypper will fail if the package doesnt exist,
    # ignore the failure with true.

    install_cmd="zypper --no-gpg-checks --non-interactive install ${pkg_path}"
    uninstall_cmd="zypper --no-gpg-checks --non-interactive remove rstudio || true"

    if "$dry_run" ; then
        echo "uninstall_cmd = :${uninstall_cmd}:"
        echo "install_cmd = :${install_cmd}:"
    else
        eval "${uninstall_cmd}"
        eval "${install_cmd}"
    fi
}


########################################################################
#
# install_product()
#
# Download and install a Posit IDE Team product release
#
########################################################################

function install_product() {

    local product="$1"
    local version="$2"
    local dry_run="$3"
    local pkg_path
    local dist_name
    local platform=""
    local arch=""

    platform=$( guess_platform "${product}" "${version}" )
    if [[ -z "${platform}" ]] ; then
        # too bad we can't easily provide more info about the platform here.
        echo "this platform is currently unsupported"
        return
    fi

    arch=$( guess_arch )
    if [[ -z "${arch}" ]] ; then
        # too bad we can't easily provide more info about the arch here.
        echo "this arch is currently unsupported"
        return
    fi

    pkg_path=$( product_pkg_path "${product}" "${version}" "${platform}" "${arch}" )
    if [[ -z "${pkg_path}" || ! -e "${pkg_path}" ]] ; then
        echo "this product version (platform and arch) is currently unsupported: ${product} ${version} ${platform} ${arch}"
        return
    else
        echo "package path = ${pkg_path}"
    fi

    # grab the distribution name

    dist_name=$(source /etc/os-release; echo "${ID}")

    case ${dist_name} in
        amzn | centos | fedora | rhel | rocky )
            install_product_centos "${pkg_path}" "${dry_run}"
            ;;
        debian | ubuntu )
            install_product_ubuntu "${pkg_path}" "${dry_run}"
            ;;
        opensuse-leap | sles )
            install_product_suse "${pkg_path}" "${dry_run}"
            ;;
        * )
            echo "could not find an installation function for ${dist_name}"
            return 1
            ;;
    esac
}


########################################################################
#
# print_help ()
#
# print the help message
#
########################################################################

function print_help() {

    cat << EOF
usage: $( basename "$0" ) [options] product version

Download and install a version of a Posit IDE Team product


POSITIONAL ARGUMENTS:

product       "desktop" for RStudio Desktop (stable, preview versions)
              "desktop-pro" for RStudio Desktop Pro (non-stable, non-preview versions)
              "electron" for RStudio Desktop (non-stable, non-preview versions)
              "electron-pro" for RStudio Desktop Pro (non-stable, non-preview versions)
              "server" for RStudio Server (all versions)
              "session" for the Session package (non-stable, non-preview versions)
              "workbench" for the Workbench package (non-stable, non-preview versions)

version       "stable-os" for the latest stable open source release or
              "stable-pro" for the latest stable pro release or
              "preview-os" for the latest preview open source release or
              "preview-pro" for the latest preview pro release or
              "latest" for the latest release of latest branch or
              "elsbeth-geranium" for the latest release of a specific branch or
              a specific version number like "2023.03.0-daily-282"
              a specific version number like "2022.12.1-361"
              a specific version number like "2022.12.1-361.pro1"


OPTIONS:

-d            Dry run, download the package, don't install it.

-h            Print this help message.


EXAMPLES:

01. /opt/checkrs/bin/install-rstudio.sh -d electron 2022.07.3+583
02. /opt/checkrs/bin/install-rstudio.sh -d electron 2022.12.1+361
03. /opt/checkrs/bin/install-rstudio.sh -d electron 2023.03.0-daily-282
04. /opt/checkrs/bin/install-rstudio.sh -d electron elsbeth-geranium
05. /opt/checkrs/bin/install-rstudio.sh -d electron latest
06. /opt/checkrs/bin/install-rstudio.sh -d electron-pro latest
07. /opt/checkrs/bin/install-rstudio.sh -d electron-pro elsbeth-geranium
08. /opt/checkrs/bin/install-rstudio.sh -d electron-pro 2022.12.1+361.pro1
09. /opt/checkrs/bin/install-rstudio.sh -d desktop stable-os
10. /opt/checkrs/bin/install-rstudio.sh -d server stable-os
11. /opt/checkrs/bin/install-rstudio.sh -d desktop stable-pro
12. /opt/checkrs/bin/install-rstudio.sh -d server stable-pro
13. /opt/checkrs/bin/install-rstudio.sh -d desktop preview-os
14. /opt/checkrs/bin/install-rstudio.sh -d server preview-os
15. /opt/checkrs/bin/install-rstudio.sh -d desktop preview-pro
16. /opt/checkrs/bin/install-rstudio.sh -d server preview-pro


EOF
}


# parse the command line options
# separate flags from positional args

options=":dh";

dry_run=false

let nNamedArgs=0;
let nUnnamedArgs=0;
while (( "$#" ))
do
    case $1 in
        -h | -d )
            namedArgs[$nNamedArgs]=$1;
            let nNamedArgs++;
            shift;
            ;;
        * )
            # unrecognized options
            unnamedArgs[$nUnnamedArgs]=$1;
            let nUnnamedArgs++;
            shift;
            ;;
    esac
done

while getopts "${options}" Option "${namedArgs[@]}"
do
    case $Option in
        h ) print_help ;;
        d ) dry_run=true ;;
    esac
done

set -euo pipefail

if [ "$nUnnamedArgs" -ne "2" ] ; then
    print_help;
    exit 1
fi

product_type=${unnamedArgs[0]}
product_version=${unnamedArgs[1]}

# download and install the package
# remove the previously installed version if necessary
install_product "${product_type}" "${product_version}" "${dry_run}"

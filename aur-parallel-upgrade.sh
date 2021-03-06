#!/bin/bash
# Run `yaourt -Syu --noconfirm` in parallel! (between packages)

####################### prepare ##########################
aurpar_bin_name="$0"
function where_is_him () {
    SOURCE="$1"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    echo -n "$DIR"
}
function where_am_i () {
    _my_path=`type -p ${aurpar_bin_name}`
    where_is_him "$_my_path"
}
my_path=`where_am_i`

source "$my_path/config.sh"
####################### prepare ##########################

function _aurpar_do_install () {
    # do_install $package_name
    # NO input, outputs to stderr. 
    echo "AURPAR> Issue new job: $1" 1>&2
    sudo -u "$aurpar_aur_user" yaourt -S --noconfirm "$1" 1>&2

    ret=$?
    echo "AURPAR> Job exited: $1, status=$ret" 1>&2
    return $ret
}

function get_package_list () {
    # NO input, NO arg. Result outputs to stdout, seprated by '\n'
    pacman -Sy 1>&2 || return $?
    if [[ "$aurpar_config_aur_manager" == "yaourt" ]]; then
        echo n | "$aurpar_config_aur_manager_path" -Su --aur 2>/dev/null | sed 's/\r/\n/g' | grep '^aur/'
        return $?
    elif [[ "$aurpar_config_aur_manager" == "pakku" ]]; then
        "$aurpar_config_aur_manager_path" -Syup | grep aur.archlinux.org | sed 's/^.*aur.archlinux.org.//g' | sed 's/.git$//g'
        return $?
    else
        echo "ERROR: Unknown package manager '$aurpar_config_aur_manager'. Supports: yaourt, pakku" 1>&2
        return 1
    fi
}

function get_package_list_with_filter () {
    # NO input, NO arg. Result outputs to stdout, seprated by '\n'
    list=`get_package_list` || return $?

    for blentry in "${aurpar_config_package_blacklist[@]}"; do
        list=`echo "$list" | grep -vE "^(aur/)?$blentry$"`
    done

    echo "$list"
    return $?
}

pkgs=`get_package_list` || { echo "Failed to get package list. Exiting..." 1>&2; exit $?; }
echo "============ Packages to UPGRADE: "
echo "$pkgs"

pkgs=`get_package_list_with_filter` || { echo "Failed to get package list. Exiting..." 1>&2; exit $?; }
echo "============ Jobs to issue: "
echo "$pkgs"

read -p "Start the upgrade? [y/N] " -n 1 -r
[[ $REPLY =~ ^[Yy]$ ]] || { echo "User give up the upgrade. " 1>&2; exit 0; }

export -f _aurpar_do_install
export aurpar_aur_user
echo "$pkgs" | SHELL=$(type -p bash) PATH="$my_path:$PATH" parallel --line-buffer --max-procs "$aurpar_config_threads" _aurpar_do_install '{}' || echo "Done. But some package failed to upgrade.  " 1>&2


exit 0
############ notes ############################
# list packages:
echo n | yaourt -Su --aur 2>/dev/null | sed 's/\r/\n/g' | grep '^aur/'
pakku -Syup | grep aur.archlinux.org | sed 's/^.*aur.archlinux.org.//g' | sed 's/.git$//g'

# old code
+function get_tasks_list_impl () {
+    if [[ "$aurpar_config_aur_manager" = "yaourt" ]]; then
+        echo n | yaourt -Su --aur 2>/dev/null | sed 's/\r/\n/g' | grep '^aur/'
+    elif [[ "$aurpar_config_aur_manager" = "pakku" ]]; then
+        pakku -Syup | grep aur.archlinux.org | sed 's/^.*aur.archlinux.org.//g' | sed 's/.git$//g'
+    else
+        echo "Unsupported AUR helper: $aurpar_config_aur_manager . Don't know how to retrive package list. exiting..."
+        exit 2
+    fi
+}
+function get_tasks_list () {
+}



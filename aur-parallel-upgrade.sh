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



exit 0
############ notes
# list packages:
echo n | yaourt -Su --aur 2>/dev/null | sed 's/\r/\n/g' | grep '^aur/'
pakku -Syup | grep aur.archlinux.org | sed 's/^.*aur.archlinux.org.//g' | sed 's/.git$//g'


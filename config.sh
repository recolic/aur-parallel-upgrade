
# Threads count. Recommended value is 1.5*CPU_CORES
aurpar_config_threads=6

# Name of your AUR package manager. Currently support: pakku, yaourt
aurpar_config_aur_manager='yaourt'
# aurpar_config_aur_manager='pakku'

# Username to run aur_manager. It should have password-less sudo, and CAN NOT be root. 
aurpar_aur_user='recolic'

########################################################################

# Path of your AUR package manager
aurpar_config_aur_manager_path="$aurpar_config_aur_manager"

# Path to pacman executable
aurpar_config_pacman_path='/usr/bin/pacman'

# Leave it there if you don't know what this means
aurpar_config_lock_path='/var/lib/pacman/db.lck'

# Some AUR repo contains multiple packages. We install it ONLY EXACTLY once!
# TODO: recognize & skip packages automatically. Read the `pkgname` in PKGBUILD and recognize it.
aurpar_config_package_blacklist=(
    # intel ICC
    # intel-common-libs # INSTALL THIS
    intel-openmp
    intel-compiler-base
    intel-fortran-compiler
    intel-ipp
    intel-mpi
    intel-tbb_psxe
    intel-vtune-profiler
    intel-advisor
    intel-inspector

    # Jetbrains
    # clion # INSTALL THIS
    clion-jre
    clion-cmake
    clion-gdb
    clion-lldb
    # clion-eap # INSTALL THIS
    clion-eap-jre
    clion-eap-cmake
    clion-eap-gdb
    clion-eap-lldb

    # goland
    goland-jre
    # goland-eap
    goland-eap-jre

    # wps-office
    wps-office-mime

    # frpc
    frps
    )


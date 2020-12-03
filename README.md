# Upgrade your AUR packages in parallel

Building is slow, downloading is also slow. Why not build everything in parallel to overlap CPU-heavy tasks, Network-heavy tasks, and IO-heavy tasks?

# Still a BUG in `pacman`. Script may fail now! 

## Configure

Modify config.sh, and set `aurpar_config_threads`, `aurpar_config_aur_manager` and `aurpar_aur_user`. 

You may have a look at other options below, but I don't think you're interested in them. 

## Usage

```bash
sudo ./aur-parallel-upgrade.sh
```

## FAQ

- Multiple tasks printing texts at the same time and my terminal messed up!

If you want to avoid the cross-talking, please remove `--line-buffer` from `aur-parallel-upgrade.sh`.




#!/usr/bin/env bash

# This file is part of The RetroPie Project
# 
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-prboom"
rp_module_desc="Doom/Doom II engine - PrBoom port for libretro"
rp_module_menus="2+"

function sources_lr-prboom() {
    gitPullOrClone "$md_build" https://github.com/libretro/libretro-prboom.git
}

function build_lr-prboom() {
    make clean
    make
    md_ret_require="$md_build/prboom_libretro.so"
}

function install_lr-prboom() {
    md_ret_files=(
        'prboom_libretro.so'
        'prboom.wad'
    )
}

function configure_lr-prboom() {
    # remove old install folder
    rm -rf "$rootdir/$md_type/doom"

    mkRomDir "ports"
    mkRomDir "ports/doom"
    ensureSystemretroconfig "doom"

    cp prboom.wad "$romdir/ports/doom/"

    # download doom 1 shareware
    wget "http://downloads.petrockblock.com/retropiearchives/doom1.wad" -O "$romdir/ports/doom/doom1.wad"

    chown $user:$user "$romdir/ports/doom/"*

    addPort "Doom 1 Shareware" << _EOF_
#!/bin/bash
$rootdir/supplementary/runcommand/runcommand.sh 0 "$emudir/retroarch/bin/retroarch -L $md_inst/prboom_libretro.so --config $configdir/doom/retroarch.cfg $romdir/ports/doom/doom1.wad" "$md_id"
_EOF_
}

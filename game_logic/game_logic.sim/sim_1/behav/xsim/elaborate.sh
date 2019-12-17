#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.1.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Tue Dec 17 14:46:30 EST 2019
# SW Build 2615518 on Fri Aug  9 15:53:29 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto 410203f947124a5c8fc071aa11cea0bc --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot game_state_tb_behav xil_defaultlib.game_state_tb xil_defaultlib.glbl -log elaborate.log"
xelab -wto 410203f947124a5c8fc071aa11cea0bc --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot game_state_tb_behav xil_defaultlib.game_state_tb xil_defaultlib.glbl -log elaborate.log


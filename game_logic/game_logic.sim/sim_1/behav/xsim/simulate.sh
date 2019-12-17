#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.1.2 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Tue Dec 17 17:59:45 EST 2019
# SW Build 2615518 on Fri Aug  9 15:53:29 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xsim game_state_tb_behav -key {Behavioral:sim_1:Functional:game_state_tb} -tclbatch game_state_tb.tcl -log simulate.log"
xsim game_state_tb_behav -key {Behavioral:sim_1:Functional:game_state_tb} -tclbatch game_state_tb.tcl -log simulate.log


-makelib ies_lib/xil_defaultlib -sv \
  "/var/local/xilinx-local/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/var/local/xilinx-local/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/var/local/xilinx-local/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_3 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../game_logic.srcs/sources_1/ip/p1_motions_red/sim/p1_motions_red.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib


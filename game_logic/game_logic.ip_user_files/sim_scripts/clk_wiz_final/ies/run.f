-makelib ies_lib/xil_defaultlib -sv \
  "/var/local/xilinx-local/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/var/local/xilinx-local/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "/var/local/xilinx-local/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../game_logic.srcs/sources_1/ip/clk_wiz_final/clk_wiz_final_clk_wiz.v" \
  "../../../../game_logic.srcs/sources_1/ip/clk_wiz_final/clk_wiz_final.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib


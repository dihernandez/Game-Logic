# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_msg_config  -id {IP_Flow 19-98}  -string {{ERROR: [IP_Flow 19-98] Generation of the IP CORE failed.
Failed to generate IP 'p2_kicking_red'. Failed to generate 'VHDL Synthesis Wrapper' outputs:}}  -suppress 
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.cache/wt [current_project]
set_property parent.project_path /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.xpr [current_project]
set_property XPM_LIBRARIES {XPM_CDC XPM_MEMORY} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
set_property ip_output_repo /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/small_bmps/p1_at_rest_blue.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/small_bmps/p1_at_rest_green.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/small_bmps/p1_at_rest_red.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/small_coes/p1_at_rest.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/small_coes/p2_at_rest.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/small_coes/p1_kicking.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p1_kicking_red.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p1_kicking_green.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p1_kicking_blue.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_at_rest_red.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_at_rest_green.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_at_rest_blue.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/small_coes/p2_kicking.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_kicking_red.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_kicking_green.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_kicking_blue.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/small_coes/p2_punching.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/small_coes/p1_punching.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p1_punching_red.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p1_punching_green.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p1_punching_blue.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_punching_red.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_punching_green.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_punching_blue.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/small_coes/p1_motions.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p1_motions_red.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p1_motions_green.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p1_motions_blue.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/small_coes/p2_motions.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_motions_red.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_motions_green.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/color_coes/p2_motions_blue.coe
add_files /afs/athena.mit.edu/user/d/i/dianah13/Downloads/numbers_48.coe
read_verilog -library xil_defaultlib -sv {
  /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/new/game_state.sv
  /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/new/player_move.sv
  /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/new/display_blob.sv
}
read_ip -quiet /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p2_motions_blue/p2_motions_blue.xci
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p2_motions_blue/p2_motions_blue_ooc.xdc]

read_ip -quiet /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p2_motions_green/p2_motions_green.xci
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p2_motions_green/p2_motions_green_ooc.xdc]

read_ip -quiet /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p2_motions_red/p2_motions_red.xci
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p2_motions_red/p2_motions_red_ooc.xdc]

read_ip -quiet /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p2_motions/p2_motions.xci
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p2_motions/p2_motions_ooc.xdc]

read_ip -quiet /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p1_motions_blue/p1_motions_blue.xci
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p1_motions_blue/p1_motions_blue_ooc.xdc]

read_ip -quiet /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p1_motions_green/p1_motions_green.xci
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p1_motions_green/p1_motions_green_ooc.xdc]

read_ip -quiet /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p1_motions_red/p1_motions_red.xci
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p1_motions_red/p1_motions_red_ooc.xdc]

read_ip -quiet /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p1_motions/p1_motions.xci
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/p1_motions/p1_motions_ooc.xdc]

read_ip -quiet /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/numbers/numbers.xci
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/numbers/numbers_ooc.xdc]

read_ip -quiet /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/clk_wiz_final/clk_wiz_final.xci
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/clk_wiz_final/clk_wiz_final_board.xdc]
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/clk_wiz_final/clk_wiz_final.xdc]
set_property used_in_implementation false [get_files -all /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/sources_1/ip/clk_wiz_final/clk_wiz_final_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/constrs_1/new/nexys4_ddr_constraints.xdc
set_property used_in_implementation false [get_files /afs/athena.mit.edu/user/d/i/dianah13/ddl/Game-Logic/game_logic/game_logic.srcs/constrs_1/new/nexys4_ddr_constraints.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top main -part xc7a100tcsg324-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef main.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file main_utilization_synth.rpt -pb main_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]

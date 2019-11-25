onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+p1_at_rest_green -L xil_defaultlib -L xpm -L blk_mem_gen_v8_4_3 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.p1_at_rest_green xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {p1_at_rest_green.udo}

run -all

endsim

quit -force

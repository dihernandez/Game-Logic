onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib p1_at_rest_red_opt

do {wave.do}

view wave
view structure
view signals

do {p1_at_rest_red.udo}

run -all

quit -force

onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib p1_at_rest_green_opt

do {wave.do}

view wave
view structure
view signals

do {p1_at_rest_green.udo}

run -all

quit -force

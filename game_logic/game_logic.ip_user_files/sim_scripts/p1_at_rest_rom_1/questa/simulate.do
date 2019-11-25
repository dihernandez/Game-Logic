onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib p1_at_rest_rom_opt

do {wave.do}

view wave
view structure
view signals

do {p1_at_rest_rom.udo}

run -all

quit -force

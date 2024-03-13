transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/quartus/projects/IITB_CPU/rf.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/adder4.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/MULTIPLIER.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/ALU.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/GATES.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/Register16bit.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/SE6.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/SE9.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/alu2.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/Vhdl27.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/mux4x1.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/mux2.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/mux3.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/mux5.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/mux7.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/mux2x1.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/FA.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/IITB_CPU.vhd}
vcom -93 -work work {D:/quartus/projects/IITB_CPU/mux6.vhd}

vcom -93 -work work {D:/quartus/projects/IITB_CPU/testbench.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all

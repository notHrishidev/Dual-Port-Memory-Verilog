transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {DualPortMem.vo}

vlog -vlog01compat -work work +incdir+C:/AAA_quickAccess/Dual\ Port\ Memory\ Verilog {C:/AAA_quickAccess/Dual Port Memory Verilog/DualPortMem_tb.v}

vsim -t 1ps -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  DualPortMem_tb

add wave *
view structure
view signals
run 1 ms

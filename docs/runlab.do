# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./mux2_1.sv"
vlog "./mux4_1.sv"
vlog "./half_adder.sv"
vlog "./full_adder.sv"
vlog "./alu.sv"
vlog "./mux8_1.sv"
vlog "./alu_zero_detector.sv"
vlog "./alustim.sv"
vlog "./alu_1_bit.sv"
vlog "./adder64.sv"
vlog "./control.sv"
vlog "./cpu_stim.sv"
vlog "./D_FF.sv"
vlog "./datamem.sv"
vlog "./decoder.sv"
vlog "./flag_register.sv"
vlog "./instructmem.sv"
vlog "./math.sv"
vlog "./mux2_1_5.sv"
vlog "./mux2_1_64.sv"
vlog "./mux4_1_64.sv"
vlog "./program_counter.sv"
vlog "./regfile.sv"
vlog "./register.sv"
vlog "./regstim.sv"
vlog "./sign_extend_9.sv"
vlog "./sign_extend_19.sv"
vlog "./sign_extend_26.sv"
vlog "./zero_extend_6.sv"
vlog "./zero_extend_12.sv"
vlog "./pipelined_cpu.sv"
vlog "./mux32_1.sv"
vlog "./mux8_1.sv"
vlog "./forwarding_unit.sv"
vlog "./if_rf_register.sv"
vlog "./rf_exec_register.sv"
vlog "./exec_mem_register.sv"
vlog "./mem_wb_register.sv"
vlog "./hazard_detection_unit.sv"
vlog "./five_bit_equal.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work cpu_stim

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do cpu_stim_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End

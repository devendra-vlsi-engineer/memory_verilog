vlib work
vlog design_memory.v
vsim tb2_memory +testcase="fd_wr_fd_rd"
add wave -position insertpoint sim:/tb2_memory/dut/*
#do wave.do                #uncomment this line to obtain the previously saved output wave format
run -all

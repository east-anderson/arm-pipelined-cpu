`timescale 1ns/10ps

module regfile (ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk, reset);
	input logic	[4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0]	WriteData;
	input logic 			RegWrite, clk;
	output logic [63:0]	ReadData1, ReadData2;
	logic [31:0] 	SelectedRegister;
	logic [63:0] RegisterArrayOut [31:0];
	input logic reset;
	
	// reset is not needed but still included in the DFF's so they're just set to 0.
	//assign reset = 0;
	
	// create the decoder with WriteRegister as the input, and a 32-bit array as the output. 
	decoder5_32 decoder (.in(WriteRegister), .out(SelectedRegister), .regWrite(RegWrite));
	
	// generate 32-register array, with each register's enable signal connected to one of the decoder's outputs from above.
	genvar i;
	generate
		for(i=0; i<31; i++) begin: eachReg
			register reggie (.out(RegisterArrayOut[i]), .in(WriteData), .clk, .enable(SelectedRegister[i]), .reset);
		end
	endgenerate 
	
	// set the 31 register to 0's. 
	assign RegisterArrayOut[31] = '0;
	
	// 2 large 64x32 muxes, where each 32-1 mux is connected to the same bit of each register, and there are 64 of these for each bit.
	mux64x32_1 mux1 (.out(ReadData1), .in(RegisterArrayOut), .sel(ReadRegister1));
	mux64x32_1 mux2 (.out(ReadData2), .in(RegisterArrayOut), .sel(ReadRegister2));
	
endmodule

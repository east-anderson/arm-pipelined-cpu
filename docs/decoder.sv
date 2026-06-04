`timescale 1ns/10ps

module decoder2_4 (in, out, regWrite);
	output logic [3:0] out;
	input logic [1:0] in;
	input logic regWrite;
	logic notOut0, notOut1;
	
	not #50ps n0 (notOut0, in[0]);
	not #50ps n1 (notOut1, in[1]);
	and #50ps and1 (out[0], notOut0, notOut1, regWrite);
	and #50ps and2 (out[1], in[0], notOut1, regWrite);
	and #50ps and3 (out[2], notOut0, in[1], regWrite);
	and #50ps and4 (out[3], in[0], in[1], regWrite);
	
endmodule

module decoder3_8 (in, out, regWrite);
	output logic [7:0] out;
	input logic [2:0] in;
	input logic regWrite;
	logic notOut0, notOut1, notOut2;
	
	not #50ps n0 (notOut0, in[0]);
	not #50ps n1 (notOut1, in[1]);
	not #50ps n2 (notOut2, in[2]);
	and #50ps and1 (out[0], notOut0, notOut1, notOut2, regWrite); //000
	and #50ps and2 (out[1], in[0], notOut1, notOut2, regWrite); //001
	and #50ps and3 (out[2], notOut0, in[1], notOut2, regWrite); //010
	and #50ps and4 (out[3], in[0], in[1], notOut2, regWrite); //011
	and #50ps and5 (out[4], notOut0, notOut1, in[2], regWrite); //100
	and #50ps and6 (out[5], in[0], notOut1, in[2], regWrite); //101
	and #50ps and7 (out[6], notOut0, in[1], in[2], regWrite); //110
	and #50ps and8 (out[7], in[0], in[1], in[2], regWrite); //111
	
endmodule 

module decoder5_32 (in, out, regWrite);
	output logic [31:0] out;
	input logic [4:0] in;
	input logic regWrite;
	logic [7:0] decoderOut;
	
	decoder3_8 dec1 (.in(in[4:2]), .out(decoderOut), .regWrite); 
	decoder2_4 dec2 (.in(in[1:0]), .out(out[3:0]), .regWrite(decoderOut[0]));
	decoder2_4 dec3 (.in(in[1:0]), .out(out[7:4]), .regWrite(decoderOut[1]));
	decoder2_4 dec4 (.in(in[1:0]), .out(out[11:8]), .regWrite(decoderOut[2]));
	decoder2_4 dec5 (.in(in[1:0]), .out(out[15:12]), .regWrite(decoderOut[3]));
	decoder2_4 dec6 (.in(in[1:0]), .out(out[19:16]), .regWrite(decoderOut[4]));
	decoder2_4 dec7 (.in(in[1:0]), .out(out[23:20]), .regWrite(decoderOut[5]));
	decoder2_4 dec8 (.in(in[1:0]), .out(out[27:24]), .regWrite(decoderOut[6]));
	decoder2_4 dec9 (.in(in[1:0]), .out(out[31:28]), .regWrite(decoderOut[7]));
	
endmodule

module decoder_testbench();
	logic clk, regWrite;
	logic [4:0] in;
	logic [31:0] out;

	decoder5_32 trial (in, out, regWrite);
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
	clk <= 0;
	forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	initial begin
		regWrite <= 0; in <= 5'b0; @(posedge clk);
		regWrite <= 1; @(posedge clk);
		@(posedge clk);
		in <= 5'b00101; @(posedge clk);
		@(posedge clk);
		in <= 5'b01010; @(posedge clk);
		regWrite <= 0; in <= 5'b11111; @(posedge clk);
		@(posedge clk);
		in <= 5'b00000; @(posedge clk);
		@(posedge clk);
		$stop; // End the simulation.
		end
endmodule

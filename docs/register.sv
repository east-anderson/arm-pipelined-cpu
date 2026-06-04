`timescale 1ns/10ps

module register (out, in, clk, enable, reset);
	output logic [63:0] out;
	input logic [63:0] in;
	input logic clk, reset;
	input logic enable;
	logic [63:0] muxOut;
	
	// generate 64 flip flops, each connected to a 2-1 mux that determines whether the flip flop will accept a new value or not.
	genvar i;
	
	generate
		for(i=0; i<64; i++) begin : eachDff
			D_FF flip (.q(out[i]), .d(muxOut[i]), .reset, .clk);
			mux2_1 mucks (.out(muxOut[i]), .i0(out[i]), .i1(in[i]), .sel(enable));
		end
	endgenerate
	
endmodule

//testbench
module register_testbench();
	logic clk, reset, enable;
	logic [63:0] in;
	logic [63:0] out;

	register trial (out, in, clk, enable, reset);
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
	clk <= 0;
	forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	initial begin
		in <= 64'd0; @(posedge clk);
		reset <= 1; @(posedge clk); 
		reset <= 0; enable <= 1; in <= 64'd0; @(posedge clk);
		enable <= 0; @(posedge clk);
		enable <= 1; in <= 64'd33; @(posedge clk);
		@(posedge clk);
		$stop; // End the simulation.
		end
endmodule

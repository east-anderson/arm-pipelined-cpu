`timescale 1ns/10ps

module D_FF (q, d, reset, clk);
	output reg q;
	input d, reset, clk;
	always_ff @(posedge clk)
	if (reset)
		q <= 0; // On reset, set to 0
	else
		q <= d; // Otherwise out = d
endmodule

module D_FF_testbench();
	logic q, d, reset, clk;


	D_FF trial (q, d, reset, clk);
	// Set up a simulated clock.
	parameter CLOCK_PERIOD=100;
	initial begin
	clk <= 0;
	forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	// Set up the inputs to the design. Each line is a clock cycle.
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; d <= 1; @(posedge clk); // Always reset FSMs at start
		@(posedge clk);
		@(posedge clk);
		reset <= 1; @(posedge clk);
		@(posedge clk);
		$stop; // End the simulation.
		end
endmodule

`timescale 1ns/10ps

module mux2_1(out, i0, i1, sel);
	output logic out;
	input logic i0, i1, sel;
	logic andOut1, andOut2, notOut;
	//assign out = (i1 & sel) | (i0 & ~sel);
	not #50ps not1 (notOut, sel);
	and #50ps and1 (andOut1, i1, sel);
	and #50ps and2 (andOut2, i0, notOut);
	or #50ps result (out, andOut1, andOut2);
endmodule

module mux2_1_testbench();
	logic i0, i1, sel;
	logic out;
	mux2_1 dut (.out, .i0, .i1, .sel);
	initial begin
		sel=0; i0=0; i1=0; #10;
		sel=0; i0=0; i1=1; #10;
		sel=0; i0=1; i1=0; #10;
		sel=0; i0=1; i1=1; #10;
		sel=1; i0=0; i1=0; #10;
		sel=1; i0=0; i1=1; #10;
		sel=1; i0=1; i1=0; #10;
		sel=1; i0=1; i1=1; #10;
	end
endmodule

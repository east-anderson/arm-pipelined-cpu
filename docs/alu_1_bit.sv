`timescale 1ns/10ps

module alu_1_bit (A, B, Cin, Cout, cntrl, out);
	input logic A, B, Cin;
	input logic [2:0] cntrl;
	output logic Cout, out;
	logic adderOut, andOut, orOut, xorOut, muxOut, muxSel;
	logic [7:0] muxIn;
	
	and #50ps agate (andOut, A, B);
	or #50ps ogate (orOut, A, B);
	xor #50ps xgate (xorOut, A, B);
	and #50ps selector (muxSel, cntrl[0], cntrl[1]);
	not #50ps inverter1 (invOut, B);
	mux2_1 inverter (.out(muxOut), .i0(B), .i1(invOut), .sel(muxSel));
	full_adder adder (.A(A), .B(muxOut), .C(Cin), .Sum(adderOut), .Cout(Cout));
	// CARRY-IN OF FIRST ADDER MUST BE cntrl[0]
	
	assign muxIn[0] = B;
	assign muxIn[1] = 0;
	assign muxIn[2] = adderOut;
	assign muxIn[3] = adderOut;
	assign muxIn[4] = andOut;
	assign muxIn[5] = orOut;
	assign muxIn[6] = xorOut;
	assign muxIn[7] = 0;
	
	mux8_1 ops (.in(muxIn), .out(out), .sel(cntrl));
	
endmodule

`timescale 1ns/10ps

module mux8_1 (in, out, sel);
	input logic [7:0] in;
	output logic out;
	input logic [2:0] sel;
	logic topOut, bottomOut;
	
	mux4_1 top (.out(topOut), .i0(in[4]), .i1(in[5]), .i2(in[6]), .i3(in[7]), .sel0(sel[0]), .sel1(sel[1]));
	mux4_1 bottom (.out(bottomOut), .i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), .sel0(sel[0]), .sel1(sel[1]));
	mux2_1 both (.out(out), .i0(bottomOut), .i1(topOut), .sel(sel[2]));
	
endmodule 
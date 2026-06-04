`timescale 1ns/10ps

module mux32_1 (in, out, sel);
	input logic [31:0] in;
	output logic out;
	input logic [4:0] sel;
	logic mux1out, mux2out;
	
	// combines two 16-1 muxes with a 2-1 mux, where the top bit of sel determines which of the outputs to use from the 16-1 muxes.
	mux16_1 bottom (.in(in[15:0]), .out(mux1out), .sel(sel[3:0]));
	mux16_1 top (.in(in[31:16]), .out(mux2out), .sel(sel[3:0]));
	mux2_1 result (.out, .i0(mux1out), .i1(mux2out), .sel(sel[4]));
		
endmodule


module mux16_1 (in, out, sel);
	input logic [15:0] in;
	output logic out;
	input logic [3:0] sel;
	logic out1, out2, out3, out4;
	
	// combines 4 4-1 muxes with another 4-1 mux to act as a 16-1 mux.
	mux4_1 m1 (.out(out1), .i0(in[0]), .i1(in[1]), .i2(in[2]), .i3(in[3]), .sel0(sel[0]), .sel1(sel[1]));
	mux4_1 m2 (.out(out2), .i0(in[4]), .i1(in[5]), .i2(in[6]), .i3(in[7]), .sel0(sel[0]), .sel1(sel[1]));
	mux4_1 m3 (.out(out3), .i0(in[8]), .i1(in[9]), .i2(in[10]), .i3(in[11]), .sel0(sel[0]), .sel1(sel[1]));
	mux4_1 m4 (.out(out4), .i0(in[12]), .i1(in[13]), .i2(in[14]), .i3(in[15]), .sel0(sel[0]), .sel1(sel[1]));
	mux4_1 m5 (.out, .i0(out1), .i1(out2), .i2(out3), .i3(out4), .sel0(sel[2]), .sel1(sel[3]));
	
endmodule


module mux64x32_1(out, in, sel);
	output logic [63:0] out;
	input logic [63:0] in [31:0];
	input logic [4:0] sel;
	
	// generates a bit sliced mux, where the output is a single line of 64 bits
	genvar i;
	
	generate 
		for (i=0; i<64; i++) begin: eachMux
			logic[31:0] columnBits;
		
			genvar j;
		
			for (j=0; j<32; j++) begin: total
				// collects the jth bit across all inputs
				assign columnBits[j] = in[j][i];
			end
			// puts the jth bit from all inputs into a 32-1 mux
			mux32_1 mucks(.in(columnBits), .out(out[i]), .sel(sel[4:0]));
		end
	endgenerate
endmodule


`timescale 1ns/10ps

module alu_zero_detector (in, out);
	input logic [63:0] in;
	output logic out;
	logic [15:0] level1out;
	logic [3:0] level2out;
	
	genvar i;
	generate
		for (i = 0; i < 16; i++) begin: level1
			or #50ps or1 (level1out[i], in[i*4 + 0], in[i*4 + 1], in[i*4 + 2], in[i*4 + 3]);
		end
	endgenerate
	
	generate 
		for (i = 0; i < 4; i++) begin: level2
			or #50ps or2 (level2out[i], level1out[i*4 + 0], level1out[i*4 + 1], level1out[i*4 + 2], level1out[i*4 + 3]);
		end
	endgenerate
	
	nor #50ps nor1 (out, level2out[0], level2out[1], level2out[2], level2out[3]);
	
endmodule 

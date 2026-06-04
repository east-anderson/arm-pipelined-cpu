`timescale 1ns/10ps

module mux4_1(out, i0, i1, i2, i3, sel0, sel1);
	output logic out;
	input logic i0, i1, i2, i3, sel0, sel1;
	logic out1, out2, out3, out4, notOut1, notOut2;
	not #50ps n1 (notOut1, sel0);
	not #50ps n2 (notOut2, sel1);
	and #50ps a1 (out1, notOut1, notOut2, i0);
	and #50ps a2 (out2, sel0, notOut2, i1);
	and #50ps a3 (out3, notOut1, sel1, i2);
	and #50ps a4 (out4, sel0, sel1, i3);
	or #50ps or1 (out, out1, out2, out3, out4);
	
endmodule

module mux4_1_testbench();
	logic i0, i1, i2, i3, sel0, sel1;
	logic out;
	
	mux4_1 dut (.out, .i0, .i1, .i2, .i3, .sel0, .sel1);
		
	integer i;
	initial begin
		for(i=0; i<64; i++) begin
			{sel1, sel0, i0, i1, i2, i3} = i; #10;
		end
	end
endmodule

 
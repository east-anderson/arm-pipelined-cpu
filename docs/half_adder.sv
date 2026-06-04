`timescale 1ns/10ps

module half_adder (A, B, Sum, Cout);
	input logic A, B;
	output logic Sum, Cout;
	
	xor sum (Sum, A, B);
	and carry_out (Cout, A, B);
	
endmodule 
`timescale 1ns/10ps

module alu (A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A;
	input logic [63:0] B;
	input logic [2:0] cntrl;
	output logic [63:0] result;
	output logic negative, zero, overflow, carry_out;
	logic [64:0] carryArray;
	logic [63:0] alu_result, shift_result;
	logic zero_detect_output;
	logic shift_and_out;
	
	// set the first carry-in to the bottom control bit for subtraction
	assign carryArray[0] = cntrl[0]; 
	
	// generates 64 1-bit ALU's with carry-ins/outs connected 
	genvar i;
	generate
		for (i = 0; i < 64; i++) begin: ALU_bits
			alu_1_bit alu_i (.A(A[i]), .B(B[i]), .Cin(carryArray[i]), .Cout(carryArray[i+1]), .cntrl(cntrl), .out(alu_result[i]));
		end 
	endgenerate
	
	// shifter shift_right (.value(A), .direction(1'b1), .distance(B[5:0]), .result(shift_result));

	// not #50ps shift_not (shift_not_out, cntrl[1]);
	// and #50ps shift_and (shift_and_out, cntrl[0], cntrl[1], cntrl[2]);
	// mux2_1 result_mux (.out(result), .i0(alu_result), .i1(shift_result), .sel(shift_and_out)); //if cntrl = 111, select shifter output
	assign result = alu_result; //temporarily disable shifter functionality

	// assigns the last carry-out bit as the carry-out signal
	assign carry_out = carryArray[64];
	
	// overflow flag
	xor #50ps overflow_gate (overflow, carryArray[63], carryArray[64]);
	
	// negative flag
	assign negative = result[63];
	
	// zero flag
	alu_zero_detector zero_detect (.in(result), .out(zero_detect_out));
	assign zero = zero_detect_out;
	
endmodule

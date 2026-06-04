`timescale 1ns/10ps
module exec_mem_register(
    input  logic clk, reset,
    input  logic [63:0] ALUOut_in,
    input  logic [63:0] storeData_in,
    input  logic [4:0]  Rd_in,
    input logic       MemRead_in,
    input logic       MemWrite_in,
    input logic [1:0] MemToReg_in,
    input logic       RegWrite_in,

    output logic [63:0] ALUOut_out,
    output logic [63:0] storeData_out,
    output logic [4:0]  Rd_out,
    output logic       MemRead_out,
    output logic       MemWrite_out,
    output logic [1:0] MemToReg_out,
    output logic       RegWrite_out
);

    genvar i;

    
    generate 
		 for (i = 0; i < 64; i++) begin
			  D_FF dff_alu (.q(ALUOut_out[i]), .d(ALUOut_in[i]), .clk(clk), .reset(reset));
		 end 
	 endgenerate

    
    generate 
		 for (i = 0; i < 64; i++) begin
			  D_FF dff_sd (.q(storeData_out[i]), .d(storeData_in[i]), .clk(clk), .reset(reset));
		 end 
	 endgenerate

    
    generate 
		 for (i = 0; i < 5; i++) begin
			  D_FF dff_rd (.q(Rd_out[i]), .d(Rd_in[i]), .clk(clk), .reset(reset));
		 end 
	 endgenerate

    
    D_FF dff_mr (.q(MemRead_out),  .d(MemRead_in),  .clk(clk), .reset(reset));
    D_FF dff_mw (.q(MemWrite_out), .d(MemWrite_in), .clk(clk), .reset(reset));
    D_FF dff_rw (.q(RegWrite_out), .d(RegWrite_in), .clk(clk), .reset(reset));

    generate 
		 for (i = 0; i < 2; i++) begin
			  D_FF dff_m2r (.q(MemToReg_out[i]), .d(MemToReg_in[i]), .clk(clk), .reset(reset));
		 end 
	 endgenerate

endmodule

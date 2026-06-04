`timescale 1ns/10ps
module mem_wb_register(
    input  logic clk, reset,
    input logic [63:0] mem_in,
    input logic [63:0] alu_in,
    input logic [4:0]  Rd_in,
    input logic       RegWrite_in,
    input logic [1:0] MemToReg_in,

    output logic [63:0] mem_out,
    output logic [63:0] alu_out,
    output logic [4:0]  Rd_out,
    output logic       RegWrite_out,
    output logic [1:0] MemToReg_out
);

    genvar i;

    
    generate
        for (i = 0; i < 64; i++) begin
            D_FF dff_mem (.q(mem_out[i]), .d(mem_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    
    generate
        for (i = 0; i < 64; i++) begin
            D_FF dff_alu (.q(alu_out[i]), .d(alu_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    
    generate
        for (i = 0; i < 5; i++) begin
            D_FF dff_rd (.q(Rd_out[i]), .d(Rd_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    
    D_FF dff_rw (.q(RegWrite_out), .d(RegWrite_in), .clk(clk), .reset(reset));

    
    generate
        for (i = 0; i < 2; i++) begin
            D_FF dff_m2r (.q(MemToReg_out[i]), .d(MemToReg_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

endmodule

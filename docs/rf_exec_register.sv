`timescale 1ns/10ps
module rf_exec_register(
    input  logic clk, reset,
    input logic flush,
    input  logic [63:0] read1_in,
    input  logic [63:0] read2_in,
    input  logic [4:0]  Rn_in,
    input  logic [4:0]  Rd_in,
    input  logic [4:0]  Rm_in,
    input logic [2:0] ALUOp_in,
    input logic [1:0] ALUSrc_in,
    input logic       MemRead_in,
    input logic       MemWrite_in,
    input logic [1:0] MemToReg_in,
    input logic       RegWrite_in,
    input logic       Branch_in,
    input logic       UncondBranch_in,
    input logic       flagWrite_in,
    input logic      Reg2Loc_in,
    input logic [63:0] imm19_in,
    input logic [63:0] imm26_in,
    input logic [63:0] imm12_in,
    input logic [63:0] imm9_in,
    input logic [63:0] pc_plus4_in,
    input logic [31:0] instr_in,
	 input logic [63:0] rfex_pc_in,

    output logic [63:0] read1_out,
    output logic [63:0] read2_out,
    output logic [4:0]  Rn_out,
    output logic [4:0]  Rd_out,
    output logic [4:0]  Rm_out,
    output logic [2:0] ALUOp_out,
    output logic [1:0] ALUSrc_out,
    output logic       MemRead_out,
    output logic       MemWrite_out,
    output logic [1:0] MemToReg_out,
    output logic       RegWrite_out,
    output logic       Branch_out,
    output logic       UncondBranch_out,
    output logic       flagWrite_out,
    output logic       Reg2Loc_out,
    output logic [63:0] imm19_out,
    output logic [63:0] imm26_out,
    output logic [63:0] imm12_out,
    output logic [63:0] imm9_out,
    output logic [63:0] pc_plus4_out,
    output logic [31:0] instr_out,
	 output logic [63:0] rfex_pc_out
);

    genvar i;
	 
	 
	 generate
        for (i = 0; i < 64; i++) begin : pc_regs
            D_FF dff_pc4 (.q(rfex_pc_out[i]), .d(rfex_pc_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate
	 
    
    generate
        for (i = 0; i < 64; i++) begin : pc4_regs
            D_FF dff_pc4 (.q(pc_plus4_out[i]), .d(pc_plus4_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    generate
        for (i = 0; i < 32; i++) begin : instr_regs_ifrf
            D_FF dff_instr_ifrf (.q(instr_out[i]), .d(instr_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    
    generate
        for (i = 0; i < 64; i++) begin : imm19_regs
            D_FF dff_imm19 (.q(imm19_out[i]), .d(imm19_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    generate
        for (i = 0; i < 64; i++) begin : imm26_regs
            D_FF dff_imm26 (.q(imm26_out[i]), .d(imm26_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    generate
        for (i = 0; i < 64; i++) begin : imm12_regs
            D_FF dff_imm12 (.q(imm12_out[i]), .d(imm12_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    generate
        for (i = 0; i < 64; i++) begin : imm9_regs
            D_FF dff_imm9 (.q(imm9_out[i]), .d(imm9_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate


    

    generate
        for (i = 0; i < 64; i++) begin : rd1_regs
            D_FF dff_rd1 (.q(read1_out[i]), .d(read1_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    generate
        for (i = 0; i < 64; i++) begin : rd2_regs
            D_FF dff_rd2 (.q(read2_out[i]), .d(read2_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate


    

    generate
        for (i = 0; i < 5; i++) begin : rn_regs
            D_FF dff_rn (.q(Rn_out[i]), .d(Rn_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    generate
        for (i = 0; i < 5; i++) begin : rd_regs
            D_FF dff_rd (.q(Rd_out[i]), .d(Rd_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    generate
        for (i = 0; i < 5; i++) begin : rm_regs
            D_FF dff_rm (.q(Rm_out[i]), .d(Rm_in[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    
    logic [2:0] ALUOp_flushed;
    
    generate
        for (i = 0; i < 3; i++) begin : aluop_regs
            mux2_1 aluop_flush_mux (
                .out(ALUOp_flushed[i]),
                .i0(ALUOp_in[i]), 
                .i1(1'b0),   // bubble
                .sel(flush)
            );
            D_FF dff_aluop (.q(ALUOp_out[i]), .d(ALUOp_flushed[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    
    logic [1:0] ALUSrc_flushed, MemToReg_flushed;
    generate
        for (i = 0; i < 2; i++) begin : alusrc_regs
            mux2_1 alusrc_flush_mux (
                .out(ALUSrc_flushed[i]),
                .i0(ALUSrc_in[i]), 
                .i1(1'b0),   // bubble
                .sel(flush)
            );
            D_FF dff_alusrc (.q(ALUSrc_out[i]), .d(ALUSrc_flushed[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    generate
        for (i = 0; i < 2; i++) begin : memtoreg_regs
            mux2_1 memtoreg_flush_mux (
                .out(MemToReg_flushed[i]),
                .i0(MemToReg_in[i]), 
                .i1(1'b0),   // bubble
                .sel(flush)
            );
            D_FF dff_m2r (.q(MemToReg_out[i]), .d(MemToReg_flushed[i]), .clk(clk), .reset(reset));
        end
    endgenerate

    
    logic MemRead_flushed, MemWrite_flushed, RegWrite_flushed, Branch_flushed;
    logic UncondBranch_flushed, flagWrite_flushed;

    mux2_1 memread_flush_mux (
        .out(MemRead_flushed),
        .i0(MemRead_in), 
        .i1(1'b0),       // bubble
        .sel(flush)
    );
    mux2_1 memwrite_flush_mux (
        .out(MemWrite_flushed),
        .i0(MemWrite_in), 
        .i1(1'b0),        // bubble
        .sel(flush)
    );
    mux2_1 regwrite_flush_mux (
        .out(RegWrite_flushed),
        .i0(RegWrite_in), 
        .i1(1'b0),        // bubble
        .sel(flush)
    );
    mux2_1 branch_flush_mux (
        .out(Branch_flushed),
        .i0(Branch_in), 
        .i1(1'b0),      // bubble
        .sel(flush)
    );
    mux2_1 uncondbranch_flush_mux (
        .out(UncondBranch_flushed),
        .i0(UncondBranch_in), 
        .i1(1'b0),            // bubble
        .sel(flush)
    );
    mux2_1 flagwrite_flush_mux (
        .out(flagWrite_flushed),
        .i0(flagWrite_in), 
        .i1(1'b0),         // bubble
        .sel(flush)
    );

    D_FF dff_memread  (.q(MemRead_out),  .d(MemRead_flushed),  .clk(clk), .reset(reset));
    D_FF dff_memwrite (.q(MemWrite_out), .d(MemWrite_flushed), .clk(clk), .reset(reset));
    D_FF dff_regwrite (.q(RegWrite_out), .d(RegWrite_flushed), .clk(clk), .reset(reset));
    D_FF dff_branch   (.q(Branch_out),   .d(Branch_flushed),   .clk(clk), .reset(reset));
    D_FF dff_flagwr   (.q(flagWrite_out),.d(flagWrite_flushed),.clk(clk), .reset(reset));
    D_FF dff_r2l     (.q(Reg2Loc_out), .d(Reg2Loc_in), .clk(clk), .reset(reset));
    D_FF dff_uncb    (.q(UncondBranch_out), .d(UncondBranch_flushed), .clk(clk), .reset(reset));

endmodule

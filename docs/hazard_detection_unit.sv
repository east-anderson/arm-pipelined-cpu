`timescale 1ns/10ps
module hazard_detection_unit(
    input  logic        EX_MemRead,
    input  logic [4:0]  EX_Rd,
    input  logic [4:0]  ID_Rn,
    input  logic [4:0]  ID_Rm,
    input  logic [4:0]  ID_Rd,
    input  logic        Reg2Loc,
    input  logic        reset,      

    output logic        PCWrite,
    output logic        IFID_Write,
    output logic        control_stall
);

    
    logic [4:0] ID_Reg2;

    mux2_1_5 reg2_mux (
        .out(ID_Reg2),
        .i0(ID_Rd),
        .i1(ID_Rm),
        .sel(Reg2Loc)
    );

    
    logic match_Rn, match_Reg2;

    five_bit_equal cmp_rn (
        .A(EX_Rd),
        .B(ID_Rn),
        .result(match_Rn)
    );

    five_bit_equal cmp_r2 (
        .A(EX_Rd),
        .B(ID_Reg2),
        .result(match_Reg2)
    );

    
    logic ex_rd_is_zero_reg;

    five_bit_equal cmp_xzr (
        .A(EX_Rd),
        .B(5'b11111),
        .result(ex_rd_is_zero_reg)
    );

    
    logic match_any;
    logic not_zero;
    logic mem_and_notzero;
    logic raw_hazard;
    logic nreset;
    logic hazard;

    
    or  #50ps or_match (match_any, match_Rn, match_Reg2);

    
    not #50ps not_xzr (not_zero, ex_rd_is_zero_reg);

    
    and #50ps and_mem_nz (mem_and_notzero, EX_MemRead, not_zero);

    
    and #50ps and_hazard_raw (raw_hazard, mem_and_notzero, match_any);

    
    not #50ps not_reset (nreset, reset);
    and #50ps and_hazard (hazard, raw_hazard, nreset);

    
    // Outputs

    // PCWrite = ~hazard
    not #50ps not_pcwrite (PCWrite, hazard);

    // IFID_Write = ~hazard
    not #50ps not_ifidwrite (IFID_Write, hazard);

    // control_stall = hazard
    assign control_stall = hazard;

endmodule

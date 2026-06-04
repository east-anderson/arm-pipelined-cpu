`timescale 1ns / 1ps
module forwarding_unit(
    
    input  logic [4:0] EX_Rn,     
    input  logic [4:0] EX_Rm,     
    input  logic [4:0] MEM_Rd,    
    input  logic [4:0] WB_Rd,     
    input  logic       MEM_RegWrite,  
    input  logic       WB_RegWrite,   

    output logic [1:0] ForwardA,
    output logic [1:0] ForwardB
);

    

    logic eqA_MEM_bit[4:0];
    logic eqA_MEM;

    genvar iA0;
    generate
        for (iA0 = 0; iA0 < 5; iA0++) begin : cmpA_MEM
            xnor #50ps xnorA_MEM (eqA_MEM_bit[iA0], EX_Rn[iA0], MEM_Rd[iA0]);
        end
    endgenerate

    and #50ps andA_MEM (eqA_MEM,
        eqA_MEM_bit[0],
        eqA_MEM_bit[1],
        eqA_MEM_bit[2],
        eqA_MEM_bit[3],
        eqA_MEM_bit[4]
    );

    

    logic eqB_MEM_bit[4:0];
    logic eqB_MEM;

    genvar iB0;
    generate
        for (iB0 = 0; iB0 < 5; iB0++) begin : cmpB_MEM
            xnor #50ps xnorB_MEM (eqB_MEM_bit[iB0], EX_Rm[iB0], MEM_Rd[iB0]);
        end
    endgenerate

    and #50ps andB_MEM (eqB_MEM,
        eqB_MEM_bit[0],
        eqB_MEM_bit[1],
        eqB_MEM_bit[2],
        eqB_MEM_bit[3],
        eqB_MEM_bit[4]
    );

    

    logic eqA_WB_bit[4:0];
    logic eqA_WB;

    genvar iA1;
    generate
        for (iA1 = 0; iA1 < 5; iA1++) begin : cmpA_WB
            xnor #50ps xnorA_WB (eqA_WB_bit[iA1], EX_Rn[iA1], WB_Rd[iA1]);
        end
    endgenerate

    and #50ps andA_WB (eqA_WB,
        eqA_WB_bit[0],
        eqA_WB_bit[1],
        eqA_WB_bit[2],
        eqA_WB_bit[3],
        eqA_WB_bit[4]
    );

    

    logic eqB_WB_bit[4:0];
    logic eqB_WB;

    genvar iB1;
    generate
        for (iB1 = 0; iB1 < 5; iB1++) begin : cmpB_WB
            xnor #50ps xnorB_WB (eqB_WB_bit[iB1], EX_Rm[iB1], WB_Rd[iB1]);
        end
    endgenerate

    and #50ps andB_WB (eqB_WB,
        eqB_WB_bit[0],
        eqB_WB_bit[1],
        eqB_WB_bit[2],
        eqB_WB_bit[3],
        eqB_WB_bit[4]
    ); 
	 
	 

    // =====================================================================
    //    Detect MEM_Rd == XZR (31)
    // =====================================================================

    logic mem_eq_xzr_bit[4:0];
    logic mem_is_xzr;
    logic not_mem_is_xzr;

    genvar iM;
    generate
        for (iM = 0; iM < 5; iM++) begin : cmp_MEM_XZR
            xnor #50ps xnor_MEM_XZR (mem_eq_xzr_bit[iM], MEM_Rd[iM], 1'b1); 
        end
    endgenerate

    and #50ps and_MEM_XZR (mem_is_xzr,
        mem_eq_xzr_bit[0],
        mem_eq_xzr_bit[1],
        mem_eq_xzr_bit[2],
        mem_eq_xzr_bit[3],
        mem_eq_xzr_bit[4]
    );

    not #50ps not_MEM_XZR (not_mem_is_xzr, mem_is_xzr);

    // =====================================================================
    //    Detect WB_Rd == XZR (31)
    // =====================================================================

    logic wb_eq_xzr_bit[4:0];
    logic wb_is_xzr;
    logic not_wb_is_xzr;

    genvar iW;
    generate
        for (iW = 0; iW < 5; iW++) begin : cmp_WB_XZR
            xnor #50ps xnor_WB_XZR (wb_eq_xzr_bit[iW], WB_Rd[iW], 1'b1);
        end
    endgenerate

    and #50ps and_WB_XZR (wb_is_xzr,
        wb_eq_xzr_bit[0],
        wb_eq_xzr_bit[1],
        wb_eq_xzr_bit[2],
        wb_eq_xzr_bit[3],
        wb_eq_xzr_bit[4]
    );

    not #50ps not_WB_XZR (not_wb_is_xzr, wb_is_xzr);

    
    // ForwardA logic
   
    and #50ps and_FwdA1 (ForwardA[1], eqA_MEM, MEM_RegWrite, not_mem_is_xzr);

    logic no_EXMEM_A;
    not #50ps not_EXMEM_A (no_EXMEM_A, ForwardA[1]);

    logic wbA_cond;
    and #50ps and_wbA (wbA_cond, eqA_WB, WB_RegWrite, not_wb_is_xzr);
    and #50ps and_FwdA0 (ForwardA[0], wbA_cond, no_EXMEM_A);

    
    // ForwardB logic
    

    
    and #50ps and_FwdB1 (ForwardB[1], eqB_MEM, MEM_RegWrite, not_mem_is_xzr);

    logic no_EXMEM_B;
    not #50ps not_EXMEM_B (no_EXMEM_B, ForwardB[1]);

    logic wbB_cond;
    and #50ps and_wbB (wbB_cond, eqB_WB, WB_RegWrite, not_wb_is_xzr);
    and #50ps and_FwdB0 (ForwardB[0], wbB_cond, no_EXMEM_B);

endmodule

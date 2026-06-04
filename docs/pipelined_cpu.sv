`timescale 1ns/10ps
module pipelined_cpu (
    input  logic clk,
    input  logic reset,
    output logic [31:0] instr_out
);

    
    ///////////////////////// IF STAGE
    

    logic [63:0] pc_current, pc_next;
    logic [31:0] if_instr;
    logic [63:0] pc_plus4;
    logic BrTaken;
    logic [63:0] branch_target_shifted;
	 logic [63:0] branch_pc_relative;

    
    program_counter PC (.clk(clk), .reset(reset), .enable(PCWrite), .in(pc_next), .out(pc_current));

    
    instructmem IMEM (.address(pc_current), .instruction(if_instr), .clk(clk));

    
    adder64 PCADD (.A(pc_current), .B(64'd4), .Sum(pc_plus4));

    mux2_1_64 PC_MUX (
        .i0(pc_plus4),               
        .i1(branch_pc_relative),  
        .sel(BrTaken),               
        .out(pc_next)
    );
    

    logic [63:0] ifrf_pc_plus4;
    logic [31:0] ifrf_instr;
	 logic [63:0] ifrf_pc_current;

    if_rf_register IFRF (
        .clk(clk), .reset(reset),
        .enable(IFID_Write),
        .flush(BrTaken),
		  .pc_current_in(pc_current),
        .pc_plus4_in(pc_plus4),
        .instr_in   (if_instr),
		  .pc_current_out(ifrf_pc_current),
        .pc_plus4_out(ifrf_pc_plus4),
        .instr_out   (ifrf_instr)
    );


    
    /////////////////////////// RF STAGE
    
	 
    logic [10:0] opcode;
    logic [4:0]  Rn, Rm, Rd;

    assign opcode = ifrf_instr[31:21];
    assign Rn     = ifrf_instr[9:5];
    assign Rm     = ifrf_instr[20:16];
    assign Rd     = ifrf_instr[4:0];

   
    logic [4:0] r2lout;
    logic Reg2Loc;
    mux2_1_5 reg2loc_mux (.out(r2lout), .i0(Rd), .i1(Rm), .sel(Reg2Loc));

    // Inverted clock
    logic inv_clk;
    not #50ps inv_clock (inv_clk, clk);
    
    logic [63:0] read_data1, read_data2;
    logic [63:0] wb_ALUOut;
    logic [63:0] wb_write_data;
	 logic memwb_RegWrite;
	 logic [4:0] memwb_Rd;
    regfile RF (
        .ReadData1(read_data1),
        .ReadData2(read_data2),
        .WriteData(wb_write_data),
        .ReadRegister1(Rn),
        .ReadRegister2(r2lout), 
        .WriteRegister(memwb_Rd),
        .RegWrite(memwb_RegWrite),
        .clk(inv_clk),
        .reset(reset)
    );

    
    logic UncondBranch, Branch, MemRead, MemWrite, RegWrite, flagWrite;
    logic [2:0] ALUOp;
    logic [1:0] ALUSrc, MemToReg;
	 logic alu_zero;
	 logic [3:0] flags_out;

    control CONTROL (
        .Reg2Loc(Reg2Loc),
        .UncondBranch(UncondBranch),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemToReg),
        .ALUOp(ALUOp),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .flagWrite(flagWrite),
        .flags(flags_out),
        .zero(alu_zero),
        .opcode(opcode),
        .instruction(ifrf_instr)
    );

    
    logic control_stall;
	 logic [4:0] rfex_Rd;
	 logic rfex_MemRead;
    hazard_detection_unit HDU(
        .EX_MemRead(rfex_MemRead),
        .EX_Rd(rfex_Rd),
        .ID_Rn(Rn),
        .ID_Rm(Rm),
        .ID_Rd(Rd),
        .Reg2Loc(Reg2Loc),
		  .reset(reset),

        .PCWrite(PCWrite),
        .IFID_Write(IFID_Write),
        .control_stall(control_stall)
    );

    
    logic [63:0] imm_ext_19, imm_ext_12, imm_ext_9, imm_ext_26; 

    sign_extend_19 SE19 (.in(ifrf_instr[23:5]), .out(imm_ext_19));
    zero_extend_12 ZE12 (.in(ifrf_instr[21:10]), .out(imm_ext_12));
    sign_extend_9  SE9  (.in(ifrf_instr[20:12]), .out(imm_ext_9));
    sign_extend_26 SE26 (.in(ifrf_instr[25:0]), .out(imm_ext_26));

    
    logic [2:0]  ALUOp_stall;
    logic [1:0]  ALUSrc_stall, MemToReg_stall;
    logic        MemRead_stall, MemWrite_stall, RegWrite_stall, Branch_stall, flagWrite_stall;
    logic control_stall_branch;
    
	 assign control_stall_branch = control_stall;

    genvar i;

    
    generate
        for (i = 0; i < 3; i++) begin : stall_aluop
            mux2_1 mux_aluop (
                .out(ALUOp_stall[i]),
                .i0(ALUOp[i]),
                .i1(1'b0),
                .sel(control_stall_branch)
            );
        end
    endgenerate

    
    generate
        for (i = 0; i < 2; i++) begin : stall_alusrc
            mux2_1 mux_alusrc (
                .out(ALUSrc_stall[i]),
                .i0(ALUSrc[i]),
                .i1(1'b0),
                .sel(control_stall_branch)
            );
        end
    endgenerate

    
    generate
        for (i = 0; i < 2; i++) begin : stall_m2r
            mux2_1 mux_m2r (
                .out(MemToReg_stall[i]),
                .i0(MemToReg[i]),
                .i1(1'b0),
                .sel(control_stall_branch)
            );
        end
    endgenerate

    
    mux2_1 mux_mr  (.out(MemRead_stall),  .i0(MemRead),   .i1(1'b0), .sel(control_stall_branch));
    mux2_1 mux_mw  (.out(MemWrite_stall), .i0(MemWrite),  .i1(1'b0), .sel(control_stall_branch));
    mux2_1 mux_rw  (.out(RegWrite_stall), .i0(RegWrite),  .i1(1'b0), .sel(control_stall_branch));
    mux2_1 mux_br  (.out(Branch_stall),   .i0(Branch),    .i1(1'b0), .sel(control_stall_branch));
    mux2_1 mux_fl  (.out(flagWrite_stall),.i0(flagWrite), .i1(1'b0), .sel(control_stall_branch));

    logic UncondBranch_stall;
    logic Reg2Loc_stall;

    
    mux2_1 mux_ubr (
        .out(UncondBranch_stall),
        .i0(UncondBranch),
        .i1(1'b0),
        .sel(control_stall_branch)
    );

    
    mux2_1 mux_r2l (
        .out(Reg2Loc_stall),
        .i0(Reg2Loc),
        .i1(Reg2Loc),   
        .sel(control_stall_branch)
    );

    
    logic [63:0] idex_read1, idex_read2;
    
	 
	 
    //////////////////////////// EXEC STAGE
    
    logic [63:0] rfex_read1, rfex_read2, rfex_imm;
    logic [4:0]  rfex_Rn, rfex_Rm;
    logic [2:0]  rfex_ALUOp;
    logic [1:0]  rfex_ALUSrc, rfex_MemToReg;
    logic        rfex_MemWrite, rfex_RegWrite, rfex_Branch, rfex_UnCondBranch, rfex_flagWrite, rfex_Reg2Loc;
    logic [63:0] rfex_imm19, rfex_imm26;
    logic [63:0] rfex_imm12, rfex_imm9;
    logic [63:0] rfex_pc_plus4;
    logic [31:0] rfex_instr;
	 logic [63:0] rfex_pc;

    logic rf_exec_flush;
	 assign rf_exec_flush = control_stall;
	 
    rf_exec_register RFEX (
        .clk(clk), .reset(reset),
        .flush(rf_exec_flush),
        .read1_in(read_data1),
        .read2_in(read_data2),
        .Rn_in(Rn), .Rd_in(Rd), .Rm_in(Rm),
        .ALUOp_in(ALUOp_stall), .ALUSrc_in(ALUSrc_stall),
        .MemRead_in(MemRead_stall), .MemWrite_in(MemWrite_stall),
        .MemToReg_in(MemToReg_stall), .RegWrite_in(RegWrite_stall),
        .Branch_in(Branch_stall), .UncondBranch_in(UncondBranch_stall), .flagWrite_in(flagWrite_stall),
        .Reg2Loc_in(Reg2Loc_stall), .imm19_in(imm_ext_19), .imm26_in(imm_ext_26),
        .imm12_in(imm_ext_12), .imm9_in(imm_ext_9), .pc_plus4_in(ifrf_pc_plus4),
        .instr_in(ifrf_instr),
		  .rfex_pc_in(ifrf_pc_current),

        .read1_out(rfex_read1),
        .read2_out(rfex_read2),
        .Rn_out(rfex_Rn), .Rd_out(rfex_Rd), .Rm_out(rfex_Rm),
        .ALUOp_out(rfex_ALUOp), .ALUSrc_out(rfex_ALUSrc),
        .MemRead_out(rfex_MemRead), .MemWrite_out(rfex_MemWrite),
        .MemToReg_out(rfex_MemToReg), .RegWrite_out(rfex_RegWrite),
        .Branch_out(rfex_Branch), .UncondBranch_out(rfex_UnCondBranch), .flagWrite_out(rfex_flagWrite),
        .Reg2Loc_out(rfex_Reg2Loc), .imm19_out(rfex_imm19), .imm26_out(rfex_imm26),
        .imm12_out(rfex_imm12), .imm9_out(rfex_imm9), .pc_plus4_out(rfex_pc_plus4), .instr_out(rfex_instr),
		  .rfex_pc_out(rfex_pc)
    );


   

    // need to implement shifter !!!!!!!!


    logic [63:0] ex_A, ex_B;
    logic [63:0] forwarded_A, forwarded_B;
    logic [1:0]  ForwardA, ForwardB;
	 logic [4:0] exmem_Rd;
	 logic exmem_RegWrite;
	 
	 
	 logic [4:0] ex_srcB;

	 mux2_1_5 ex_srcB_mux (
			.out(ex_srcB),
			.i0(rfex_Rd),      
			.i1(rfex_Rm),      
			.sel(rfex_Reg2Loc)
	 );

			 
    forwarding_unit FW (
    .EX_Rn(rfex_Rn),      // Rn for ALU A
    .EX_Rm(ex_srcB),      // Rm for ALU B

    .MEM_Rd(exmem_Rd),    // register written in EX/MEM
    .WB_Rd(memwb_Rd),     // register written in MEM/WB

    .MEM_RegWrite(exmem_RegWrite),    // enables
    .WB_RegWrite(memwb_RegWrite),

    // selects
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
    );

    
	
	 logic [63:0] exmem_ALUOut;
    mux4_1_64 FWD_A_MUX (
        .i0(rfex_read1),     
        .i1(wb_write_data),   
        .i2(exmem_ALUOut),  
        .i3(64'b0),          
        .sel(ForwardA),
        .out(forwarded_A)
    );

    mux4_1_64 FWD_B_MUX (
        .i0(rfex_read2),     
        .i1(wb_write_data),  
        .i2(exmem_ALUOut),  
        .i3(64'b0),          
        .sel(ForwardB),
        .out(forwarded_B)
    );

    //shifter for LSR
    logic [63:0] shifter_out;
    shifter LSR_shifter (.value(forwarded_A), .direction(1'b1), .distance(rfex_instr[15:10]), .result(shifter_out));

    
    mux4_1_64 ALUSRC_MUX (
        .i0(forwarded_B),
        .i1(rfex_imm9),
        .i2(rfex_imm12),
        .i3(64'b0),
        .sel(rfex_ALUSrc),
        .out(ex_B)
    );

    assign ex_A = forwarded_A;
    
    logic [63:0] ex_ALUOut;
    logic ex_negative, ex_overflow, ex_carry_out;

    alu EX_ALU (
        .A      (ex_A),
        .B      (ex_B),
        .cntrl  (rfex_ALUOp),
        .result (ex_ALUOut),
        .negative(ex_negative),
        .zero   (alu_zero),
        .overflow(ex_overflow),
        .carry_out(ex_carry_out)
    );

    logic [63:0] alu_out_final;
	 logic shift_sel;
	 and #50ps shiftselgate (shift_sel, rfex_ALUOp[0], rfex_ALUOp[1], rfex_ALUOp[2]);
    mux2_1_64 shift_select_mux (.i0(ex_ALUOut), .i1(shifter_out), .sel(shift_sel), .out(alu_out_final)); // if bit 22 is 1, use shifter output

    
    flag_register EX_FLAGS (
        .clk(clk),
        .reset(reset),
        .negative(ex_negative),
        .zero(alu_zero),
        .overflow(ex_overflow),
        .carry_out(ex_carry_out),
        .flags_out(flags_out),  
        .flagWrite(rfex_flagWrite)
    );

		
		logic is_cbz_ex, is_blt_ex;
		logic n30, n27, n25;
				
		not #50ps not30 (n30, rfex_instr[30]);
		not #50ps not27 (n27, rfex_instr[27]);
		not #50ps not25 (n25, rfex_instr[25]);

		
		and #50ps g1_cbz (cbz_g1,
			 rfex_instr[31], n30, rfex_instr[29], rfex_instr[28]
		);

		
		and #50ps g2_cbz (cbz_g2,
			 n27, rfex_instr[26], n25
		);

		and #50ps cbz_final (is_cbz_ex, cbz_g1, cbz_g2);

		
		logic n31, n29, n27b, n25b;
						
		not #50ps not31 (n31, rfex_instr[31]);
		not #50ps not29 (n29, rfex_instr[29]);
		not #50ps not27b (n27b, rfex_instr[27]);
		not #50ps not25b (n25b, rfex_instr[25]);

		
		and #50ps g1_blt (blt_g1,
			 n31, rfex_instr[30], n29, rfex_instr[28]
		);

		
		and #50ps g2_blt (blt_g2,
			 n27b, rfex_instr[26], n25b
		);

		
		and #50ps blt_final (is_blt_ex, blt_g1, blt_g2);

		
		logic n_xor_v;
		xor #50ps xor_lt (n_xor_v, flags_out[3], flags_out[1]);   // N != V


		logic blt_condition_final;
		and #50ps and_blt (blt_condition_final, is_blt_ex, n_xor_v);

    
    logic cbz_condition;
    and #50ps and_cbz (cbz_condition, is_cbz_ex, alu_zero);



    logic branch_conditional;
    or #50ps or_cond (
        branch_conditional,
        cbz_condition,
        blt_condition_final
    );

   
    or #50ps or_final (
        BrTaken,
        rfex_UnCondBranch,
        branch_conditional
    );
    
    
    logic [63:0] branch_target;
    mux2_1_64 branch_imm_mux (
        .i0(rfex_imm19),
        .i1(rfex_imm26),
        .sel(rfex_UnCondBranch),
        .out(branch_target)
    );
    
    shifter left2 (
        .value(branch_target),
        .direction(1'b0), 
        .distance(6'd2), 
        .result(branch_target_shifted)
    );


    adder64 BRANCH_ADD (
        .A(rfex_pc),          // PC+4 from the RF/EX pipeline reg
        .B(branch_target_shifted),  // shifted immediate
        .Sum(branch_pc_relative)
    );

    
    
    //////////////////////// MEM STAGE
  
  
    logic [63:0] exmem_storeData;
    logic        exmem_MemRead, exmem_MemWrite;
    logic [1:0]  exmem_MemToReg;

    exec_mem_register EXMEM (
        .clk(clk), .reset(reset),
        .ALUOut_in(alu_out_final),
        .storeData_in(forwarded_B),
        .Rd_in(rfex_Rd),
        .RegWrite_in(rfex_RegWrite),
        .MemRead_in(rfex_MemRead),
        .MemWrite_in(rfex_MemWrite),
        .MemToReg_in(rfex_MemToReg),

        .ALUOut_out(exmem_ALUOut),
        .storeData_out(exmem_storeData),
        .Rd_out(exmem_Rd),
        .RegWrite_out(exmem_RegWrite),
        .MemRead_out(exmem_MemRead),
        .MemWrite_out(exmem_MemWrite),
        .MemToReg_out(exmem_MemToReg)
    );


   
    logic [63:0] mem_readData;

    datamem DMEM (
        .address(exmem_ALUOut),
		  .write_enable(exmem_MemWrite),
		  .read_enable(exmem_MemRead),
        .write_data(exmem_storeData),
        .clk(clk),
		  .xfer_size(4'b1000),
        .read_data(mem_readData)
    );


    
    /////////////////////////////// WRITEBACK STAGE
    

    logic [63:0] memwb_data;

    logic [1:0]  memwb_MemToReg;

    mem_wb_register MEMWB (
        .clk(clk), .reset(reset),
        .mem_in(mem_readData),
        .alu_in(exmem_ALUOut),
        .Rd_in(exmem_Rd),
        .RegWrite_in(exmem_RegWrite),
        .MemToReg_in(exmem_MemToReg),

        .mem_out(memwb_data),
        .alu_out(wb_ALUOut),
        .Rd_out(memwb_Rd),
        .RegWrite_out(memwb_RegWrite),
        .MemToReg_out(memwb_MemToReg)
    );


    mux2_1_64 WB_MUX (
        .i0(wb_ALUOut),
        .i1(memwb_data),
        .sel(memwb_MemToReg[0]),
        .out(wb_write_data)
    );
	 

    assign instr_out = if_instr; // instruction for testing

endmodule

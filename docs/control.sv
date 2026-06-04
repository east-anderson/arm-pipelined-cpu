`timescale 1ns/10ps
module control (Reg2Loc, UncondBranch, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, flagWrite, flags, zero, opcode, instruction);
    output logic Reg2Loc;
    output logic UncondBranch;
    output logic Branch;
    output logic MemRead;
    output logic [1:0] MemtoReg;
    output logic [2:0] ALUOp;
    output logic MemWrite;
    output logic [1:0] ALUSrc;
    output logic RegWrite;
    input logic [10:0] opcode;
    output logic flagWrite;
    input logic [3:0] flags;
    input logic zero;
	 input logic [31:0] instruction;

    always_comb begin
        // Default values
        Reg2Loc = 0;
        UncondBranch = 0;
        Branch = 0;
        MemtoReg = 2'b00;
        ALUOp = 3'b000;
        MemWrite = 0;
        ALUSrc = 2'b00;
        RegWrite = 0;
        flagWrite = 0;
        MemRead = 0;
    

        casez (opcode)
            11'b1001000100?: begin // ADDI Rd, Rn, Imm12: Reg[Rd] = Reg[Rn] + ZeroExtend(Imm12)
                Reg2Loc = 0;
                UncondBranch = 0;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = 3'b010;
                MemWrite = 0;
                ALUSrc = 2'b10;
                RegWrite = 1;
                flagWrite = 0;
          
            end
            11'b10101011000: begin // ADDS Rd, Rn, Rm: Reg[Rd] = Reg[Rn] + Reg[Rm]. Set flags
                Reg2Loc = 1;
                UncondBranch = 0;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = 3'b010;
                MemWrite = 0;
                ALUSrc = 2'b00;
                RegWrite = 1;
                flagWrite = 1;
            
            end
            11'b10001010000: begin // AND Rd, Rn, Rm: Reg[Rd] = Reg[Rn] & Reg[Rm]
                Reg2Loc = 1;
                UncondBranch = 0;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = 3'b100;
                MemWrite = 0;
                ALUSrc = 2'b00;
                RegWrite = 1;
                flagWrite = 0;
      
            end
            11'b000101?????: begin // B Imm26: PC = PC + SignExtend(Imm26 << 2)
                Reg2Loc = 0;
                UncondBranch = 1;
                Branch = 0;                                                                // INVESTIGATE LATER, COULD BE WRONG                              
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = 3'b000;
                MemWrite = 0;
                ALUSrc = 2'b00;
                RegWrite = 0;
                flagWrite = 0;
           
            end
            11'b01010100???: begin // B.LT Imm19: If (flags.negative != flags.overflow) PC = PC + SignExtend(Imm19<<2)
                Reg2Loc = 0;
                UncondBranch = 0;                            // INVESTIGATE LATER
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = 3'b000;
                MemWrite = 0;
                ALUSrc = 2'b00;
                RegWrite = 0;
                flagWrite = 0;
					 Branch = 1;

            
            end
            11'b10110100???: begin // CBZ Rd, Imm19: If (Reg[Rd] == 0) PC = PC + SignExtend(Imm19<<2).
                Reg2Loc = 0;
                UncondBranch = 0;
                Branch = 1;                              // INVESTIGATE LATER
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = 3'b000;
                MemWrite = 0;
                ALUSrc = 2'b00;
                RegWrite = 0;
                flagWrite = 0;
            
            end
            11'b11001010000: begin // EOR Rd, Rn, Rm: Reg[Rd] = Reg[Rn] ^ Reg[Rm]
                Reg2Loc = 1;
                UncondBranch = 0;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = 3'b110;
                MemWrite = 0;
                ALUSrc = 2'b00;
                RegWrite = 1;
                flagWrite = 0;
   
            end
            11'b11111000010: begin // LDUR Rd, [Rn, #Imm9]: Reg[Rd] = Mem[Reg[Rn] + SignExtend(Imm9)]
                Reg2Loc = 0;
                UncondBranch = 0;
                Branch = 0;
                MemRead = 1;
                MemtoReg = 2'b01;
                ALUOp = 3'b010;
                MemWrite = 0;
                ALUSrc = 2'b01;
                RegWrite = 1;
                flagWrite = 0;

            end
            11'b11010011010: begin // LSR Rd, Rn, Shamt: Reg[Rd] = Reg[Rn] >> Shamt
                Reg2Loc = 0;
                UncondBranch = 0;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b10;
                ALUOp = 3'b111;                         // INVESTIGATE LATER
                MemWrite = 0;
                ALUSrc = 2'b00;
                RegWrite = 1;
                flagWrite = 0;

            end
            11'b11111000000: begin // STUR Rd, [Rn, #Imm9]: Mem[Reg[Rn] + SignExtend(Imm9)] = Reg[Rd]
                Reg2Loc = 0;
                UncondBranch = 0;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = 3'b010;
                MemWrite = 1;
                ALUSrc = 2'b01;
                RegWrite = 0;
                flagWrite = 0;
            
            end
            11'b11101011000: begin // SUBS Rd, Rn, Rm: Reg[Rd] = Reg[Rn] - Reg[Rm]. Set flags
                Reg2Loc = 1;
                UncondBranch = 0;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = 3'b011;
                MemWrite = 0;
                ALUSrc = 2'b00;
                RegWrite = 1;
                flagWrite = 1;
            
            end
            
            // unknown opcode
            default: begin
                Reg2Loc = 0;
                UncondBranch = 0;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 2'b00;
                ALUOp = 3'b000;
                MemWrite = 0;
                ALUSrc = 2'b00;
                RegWrite = 0;
                flagWrite = 0;
              
            end
        endcase
    end 
endmodule

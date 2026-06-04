// Test bench for Single-Cycle CPU
`timescale 1ns/10ps
//
//module cpu_stim();
//
    
//    logic clk, reset;
//
//    
//    logic [63:0] pc_out;
//    logic [31:0] instr_out;
//    logic [63:0] alu_out;
//    logic [63:0] mem_writedata_out;
//    logic [63:0] reg_writedata_out;
//
//    integer i;
//
//    
//    single_cycle_cpu dut (.clk, .reset,
//                          .pc_out, .instr_out,
//                          .alu_out, .mem_writedata_out,
//                          .reg_writedata_out);
//
//    // Force %t's to print in nice format
//    initial $timeformat(-9, 2, " ns", 10);
//
//    // Clock generation
//    initial begin
//        clk <= 0;
//        forever #(ClockDelay/2) clk <= ~clk;
//    end
//
//    // Reset sequence
//    initial begin
//        reset <= 1;
//        #(ClockDelay);
//        reset <= 0;
//    end
//
//    // Initialize instruction memory with an extended test program
//    initial begin
//        @(negedge reset);
//
//        
//        dut.imem.mem[0]  = 32'h91001401; // ADDI X1, XZR, #5
//        dut.imem.mem[1]  = 32'h91000C02; // ADDI X2, XZR, #3
//        dut.imem.mem[2]  = 32'h91001C03; // ADDI X3, XZR, #7
//        dut.imem.mem[3]  = 32'h91002804; // ADDI X4, XZR, #10
//        dut.imem.mem[4]  = 32'h91003405; // ADDI X5, XZR, #13
//
//        
//        dut.imem.mem[5]  = 32'h8B0200A6; // ADD X6, X5, X2    -> X6 = 13 + 3 = 16
//        dut.imem.mem[6]  = 32'hCB0300C7; // SUB X7, X6, X3    -> X7 = 16 - 7 = 9
//        dut.imem.mem[7]  = 32'h8A040108; // ORR X8, X8, X4    -> X8 = X8 | 10
//        dut.imem.mem[8]  = 32'hCA030129; // EOR X9, X9, X3    -> X9 = X9 ^ 7
//        dut.imem.mem[9]  = 32'h8A02014A; // AND X10, X10, X2  -> X10 = X10 & 3
//
//		  
//        dut.imem.mem[10] = 32'hF8000006; // STUR X6, [XZR, #0]    Store 16
//        dut.imem.mem[11] = 32'hF8400007; // LDUR X7, [XZR, #0]    Load 16 -> X7 = 16
//        dut.imem.mem[12] = 32'hF8000807; // STUR X7, [XZR, #8]    Store again at addr 8
//        dut.imem.mem[13] = 32'hF8400808; // LDUR X8, [XZR, #8]    Load from addr 8 -> 16
//
//        
//        dut.imem.mem[14] = 32'hEB010109; // SUBS X9, X8, X1 (sets flags: 16 - 5 = 11)
//        dut.imem.mem[15] = 32'h5400004B; // B.LT label (should not branch because 11 > 0)
//        dut.imem.mem[16] = 32'hEB08008A; // SUBS X10, X4, X8 (10 - 16 = -6)
//        dut.imem.mem[17] = 32'h5400002B; // B.LT label (should branch because negative)
//        dut.imem.mem[18] = 32'h9100480B; // ADDI X11, XZR, #18 (skipped)
//        dut.imem.mem[19] = 32'h14000003; // B continue
//
//        
//        dut.imem.mem[20] = 32'h9100540C; // label: ADDI X12, XZR, #21
//        dut.imem.mem[21] = 32'h8B05018D; // ADD X13, X12, X5 -> 21 + 13 = 34
//        dut.imem.mem[22] = 32'hEB0C018E; // SUBS X14, X12, X12 -> 0 (zero flag set)
//        dut.imem.mem[23] = 32'hB400004E; // CBZ X14, end
//        dut.imem.mem[24] = 32'h9100600F; // ADDI X15, XZR, #24 (skipped)
//        dut.imem.mem[25] = 32'h14000002; // B end
//
//        
//        dut.imem.mem[26] = 32'h14000000; // end: B end
//
//        for (i=27; i<64; i=i+1)
//            dut.imem.mem[i] = 32'h9100001F; // NOP (ADDI XZR, XZR, #0)
//
//        $display("%t Program loaded into instruction memory.", $time);
//    end
//
//    // Main stimulus process
//    initial begin
//        @(negedge reset);
//        #(ClockDelay * 2);
//
//        $display("%t Beginning CPU simulation.", $time);
//        $display("-------------------------------------------------------------");
//        $display("Time\t\tPC\t\tInstruction\t\tALU_Out\t\tRegWriteData");
//        $display("-------------------------------------------------------------");
//
//        // Observe more cycles for longer demo
//        for (i=0; i<60; i=i+1) begin
//            @(posedge clk);
//            $display("%t\t%h\t%h\t%h\t%h",
//                     $time, pc_out, instr_out, alu_out, reg_writedata_out);
//        end
//
//        $display("%t Simulation complete.", $time);
//        $stop;
//    end
//endmodule


module cpu_stim();

    parameter ClockDelay = 5000;

    logic clk, reset;

    
//    logic [63:0] pc_out;
    logic [31:0] instr_out;
//    logic [63:0] alu_out;
//    logic [63:0] mem_writedata_out;
//    logic [63:0] reg_writedata_out;

    integer i;

    
    pipelined_cpu dut (.clk, .reset, .instr_out);

    // Force %t's to print in nice format
    initial $timeformat(-9, 2, " ns", 10);

    // Clock generation
    initial begin
        clk <= 0;
        forever #(ClockDelay/2) clk <= ~clk;
    end

    // Reset sequence
	 
    initial begin
	 
        reset <= 1;
		  
        #(ClockDelay);
        reset <= 0;
		  
		  
			repeat (3000) @(posedge clk);
		  
		$stop;
	 end
endmodule

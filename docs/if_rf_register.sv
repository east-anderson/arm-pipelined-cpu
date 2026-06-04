`timescale 1ns / 1ps
module if_rf_register(clk, reset, enable, flush, pc_current_in, pc_plus4_in, instr_in, pc_current_out, pc_plus4_out, instr_out);
    input logic clk, reset;
    input logic enable;
    input logic flush;
	 input logic [63:0] pc_current_in;
    input logic [63:0] pc_plus4_in;
    input logic [31:0] instr_in;
	 output logic [63:0] pc_current_out;
    output logic [63:0] pc_plus4_out;
    output logic [31:0] instr_out;

    genvar i;

	 
	 generate
        for (i = 0; i < 64; i++) begin : pc_regs
            logic flushed;
            logic next;

            mux2_1 pc_flush_mux (
                .out(flushed),
                .i0(pc_current_in[i]), 
                .i1(1'b0),           // bubble
                .sel(flush)
            );

            mux2_1 pc_enable_mux (
                .out(next),
                .i0(pc_current_out[i]), 
                .i1(flushed),      // new (possibly flushed)
                .sel(enable)
            );
    
            D_FF pc_reg (.q(pc_current_out[i]), .d(next), .clk(clk), .reset(reset));
        end
    endgenerate
	
    
    generate
        for (i = 0; i < 64; i++) begin : pc4_regs
            logic flushed;
            logic next;

            mux2_1 pc_flush_mux (
                .out(flushed),
                .i0(pc_plus4_in[i]), 
                .i1(1'b0),           // bubble
                .sel(flush)
            );

            mux2_1 pc_enable_mux (
                .out(next),
                .i0(pc_plus4_out[i]), 
                .i1(flushed),      // new (possibly flushed)
                .sel(enable)
            );
    
            D_FF pc_reg (.q(pc_plus4_out[i]), .d(next), .clk(clk), .reset(reset));
        end
    endgenerate
    
    generate
        for (i = 0; i < 32; i++) begin : instr_regs
            logic flushed;
            logic next;

            mux2_1 instr_flush_mux (
                .out(flushed),
                .i0(instr_in[i]), 
                .i1(1'b0),        // bubble
                .sel(flush)
            );

             mux2_1 instr_enable_mux (
                .out(next),
                .i0(instr_out[i]),  
                .i1(flushed),    // new (possibly flushed)
                .sel(enable)
            );

            D_FF instr_reg (.q(instr_out[i]), .d(next), .clk(clk), .reset(reset));
        end
    endgenerate

endmodule

    
    
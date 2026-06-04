`timescale 1ns/10ps
module flag_register (clk, reset, negative, zero, overflow, carry_out, flags_out, flagWrite);
    input logic clk;
    input logic reset;
    input logic flagWrite;
    input logic negative, zero, overflow, carry_out;
    output logic [3:0] flags_out;

    logic [3:0] flags_next;

    mux2_1 muxNegative (.out(flags_next[3]), .i0(flags_out[3]), .i1(negative), .sel(flagWrite));
    mux2_1 muxZero (.out(flags_next[2]), .i0(flags_out[2]), .i1(zero), .sel(flagWrite));
    mux2_1 muxOverflow (.out(flags_next[1]), .i0(flags_out[1]), .i1(overflow), .sel(flagWrite));
    mux2_1 muxCarryOut (.out(flags_next[0]), .i0(flags_out[0]), .i1(carry_out), .sel(flagWrite));

    D_FF dff_negative (.q(flags_out[3]), .d(flags_next[3]), .clk(clk), .reset(reset));
    D_FF dff_zero (.q(flags_out[2]), .d(flags_next[2]), .clk(clk), .reset(reset));
    D_FF dff_overflow (.q(flags_out[1]), .d(flags_next[1]), .clk(clk), .reset(reset));
    D_FF dff_carry_out (.q(flags_out[0]), .d(flags_next[0]), .clk(clk), .reset(reset));

endmodule
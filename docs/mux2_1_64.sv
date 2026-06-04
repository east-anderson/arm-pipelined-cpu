`timescale 1ns/10ps
module mux2_1_64(out, i0, i1, sel);
    output logic [63:0] out;
    input  logic [63:0] i0, i1;
    input  logic        sel;

    logic [63:0] and0_out, and1_out;
    logic        sel_bar;

    not n1(sel_bar, sel);
    and a0[63:0](and0_out, i0, {64{sel_bar}});
    and a1[63:0](and1_out, i1, {64{sel}});
    or  o1[63:0](out, and0_out, and1_out);
endmodule

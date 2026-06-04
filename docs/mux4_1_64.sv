`timescale 1ns/10ps
module mux4_1_64(out, i0, i1, i2, i3, sel);
    output logic [63:0] out;
    input  logic [63:0] i0, i1, i2, i3;
    input  logic [1:0]  sel;

    logic [63:0] mux_lower_out, mux_upper_out;

    // First stage (select between pairs)
    mux2_1_64 lower_mux (.out(mux_lower_out), .i0(i0), .i1(i1), .sel(sel[0]));
    mux2_1_64 upper_mux (.out(mux_upper_out), .i0(i2), .i1(i3), .sel(sel[0]));

    // Second stage (choose between the results)
    mux2_1_64 final_mux (.out(out), .i0(mux_lower_out), .i1(mux_upper_out), .sel(sel[1]));
endmodule

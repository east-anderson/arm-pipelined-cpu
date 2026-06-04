`timescale 1ns/10ps
// module program_counter (in, out, clk, reset);
//     input logic [63:0] in;
//     output logic [63:0] out;
//     input logic clk, reset;

//     genvar i;
//     generate
//         for (i = 0; i < 64; i = i + 1) begin : flip_flops
//             D_FF dff (.q(out[i]), .d(in[i]), .clk(clk), .reset(reset));
//         end
//     endgenerate
// endmodule

module program_counter (
    input  logic clk,
    input  logic reset,
    input  logic enable,
    input  logic [63:0] in,
    output logic [63:0] out
);

    logic [63:0] pc_next;

    genvar i;
    generate
        for (i=0; i<64; i++) begin : pcff
            logic mux_out;

            // if enable = 1 → load new value
            // if enable = 0 → hold old value (feed q back into D)
            mux2_1 mux_pc (
                .out(mux_out),
                .i0(out[i]),      // hold value
                .i1(in[i]),       // update
                .sel(enable)
            );

            D_FF pcbit (.q(out[i]), .d(mux_out), .clk(clk), .reset(reset));
        end
    endgenerate

endmodule


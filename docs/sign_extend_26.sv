`timescale 1ns/10ps
module sign_extend_26 (in, out);
    input logic [25:0] in;
    output logic [63:0] out;

    assign out = {{38{in[25]}}, in};
endmodule


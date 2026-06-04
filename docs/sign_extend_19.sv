`timescale 1ns/10ps
module sign_extend_19 (in, out);
    input logic [18:0] in;
    output logic [63:0] out;

    assign out = {{45{in[18]}}, in};
endmodule

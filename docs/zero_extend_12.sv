`timescale 1ns/10ps
module zero_extend_12 (in, out);
    input logic [11:0] in;
    output logic [63:0] out;

    assign out = {{52{1'b0}}, in};
endmodule
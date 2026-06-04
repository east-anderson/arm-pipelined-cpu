`timescale 1ns/10ps
module zero_extend_6 (in, out);
    input logic [5:0] in;
    output logic [63:0] out;

    assign out = {{58{1'b0}}, in};
endmodule
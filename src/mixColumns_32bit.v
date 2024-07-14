
module mixColumns_32bit(
    input [31:0] Data_in,
    output [31:0] Data_out
);

    wire [7:0] X0, X1, X2, X3;
    wire [7:0] Y0, Y1, Y2, Y3;

    // Extract input bytes
    assign X0 = Data_in[31:24];
    assign X1 = Data_in[23:16];
    assign X2 = Data_in[15:8];
    assign X3 = Data_in[7:0];

    // Perform matrix multiplication
    assign Y0 = pmul_2(X0) ^ pmul_3(X1) ^ pmul_1(X2) ^ pmul_1(X3);
    assign Y1 = pmul_1(X0) ^ pmul_2(X1) ^ pmul_3(X2) ^ pmul_1(X3);
    assign Y2 = pmul_1(X0) ^ pmul_1(X1) ^ pmul_2(X2) ^ pmul_3(X3);
    assign Y3 = pmul_3(X0) ^ pmul_1(X1) ^ pmul_1(X2) ^ pmul_2(X3);

    // Combine output bytes
    assign Data_out = {Y0, Y1, Y2, Y3};

    // Functions for GF(2^8) multiplication
    function [7:0] pmul_1;
        input [7:0] b;
        begin
            pmul_1 = b;
        end
    endfunction
    
    function [7:0] pmul_2;
        input [7:0] b;
        pmul_2 = {b[6:0], 1'b0} ^ (8'h1b & {8{b[7]}});
    endfunction
    
    function [7:0] pmul_3;
        input [7:0] b;
        reg [7:0] two;
        begin
            two = pmul_2(b);
            pmul_3 = two ^ b;
        end
    endfunction



endmodule
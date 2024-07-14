module invmixColumns_32bit(
    input [31:0] Data_in,
    output [31:0] Data_out
);

    wire [7:0] X0, X1, X2, X3;
    reg [7:0] Y0, Y1, Y2, Y3;

    // Extract input bytes
    assign X0 = Data_in[31:24];
    assign X1 = Data_in[23:16];
    assign X2 = Data_in[15:8];
    assign X3 = Data_in[7:0];

    // Perform matrix multiplication

always @(X0,X1,X2,X3)begin
 
    Y0 = pmul_e(X0)^pmul_b(X1)^pmul_d(X2)^pmul_9(X3);
 
    Y1 = pmul_9(X0)^pmul_e(X1)^pmul_b(X2)^pmul_d(X3);
 
    Y2 = pmul_d(X0)^pmul_9(X1)^pmul_e(X2)^pmul_b(X3);
 
    Y3 = pmul_b(X0)^pmul_d(X1)^pmul_9(X2)^pmul_e(X3);
end


    // Combine output bytes
    assign Data_out = {Y0, Y1, Y2, Y3};

    // Functions for GF(2^8) multiplication

//function
 
    function [7:0] pmul_e;
     
    input [7:0] b;
     
    reg [7:0] two,four,eight;
     
    begin
     
        two=gf8_2(b);
         
        four=gf8_2(two);
         
        eight=gf8_2(four);
         
        pmul_e=eight^four^two;
     
    end
     
    endfunction
     
     
     
    function [7:0] pmul_9;
     
    input [7:0] b;
     
    reg [7:0] two,four,eight;
     
    begin
     
        two=gf8_2(b);
         
        four=gf8_2(two);
         
        eight=gf8_2(four);
         
        pmul_9=eight^b;
     
    end
     
    endfunction
     
     
     
    function [7:0] pmul_d;
     
    input [7:0] b;
     
    reg [7:0] two,four,eight;
     
    begin
     
        two=gf8_2(b);
         
        four=gf8_2(two);
         
        eight=gf8_2(four);
         
        pmul_d=eight^four^b;
     
    end
     
    endfunction
     
     
     
    function [7:0] pmul_b;
     
    input [7:0] b;
     
    reg [7:0] two,four,eight;
     
    begin
     
        two=gf8_2(b);
         
        four=gf8_2(two);
         
        eight=gf8_2(four);
         
        pmul_b=eight^two^b;
     
    end
     
    endfunction
     
     
     
    function [7:0] gf8_2;
     
    input [7:0] b;
     
    gf8_2={b[6:0],1'b0}^(8'h1b&{8{b[7]}});
     
    endfunction

endmodule
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



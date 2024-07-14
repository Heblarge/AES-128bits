module AddRoundKey(
   input [127:0] Data_in,
   output [127:0] Data_out,
   input [127:0] Key
);
    assign Data_out = Key ^ Data_in;
endmodule

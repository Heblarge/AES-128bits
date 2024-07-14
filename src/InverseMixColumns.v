module InverseMixColumns(
	input [127:0] Data_in,
	output [127:0] Data_out
);

    invmixColumns_32bit MX3 (Data_in[127:96], Data_out[127:96]);
    invmixColumns_32bit MX2 (Data_in[95:64], Data_out[95:64]);
    invmixColumns_32bit MX1 (Data_in[63:32], Data_out[63:32]);
    invmixColumns_32bit MX0 (Data_in[31:0], Data_out[31:0]);

endmodule

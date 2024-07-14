

module MixColumns(
    input [127:0] Data_in,
	output[127:0] Data_out
);
    mixColumns_32bit MIX0 (Data_in[31:0], Data_out[31:0]);
    mixColumns_32bit MIX1 (Data_in[63:32], Data_out[63:32]);
    mixColumns_32bit MIX2 (Data_in[95:64], Data_out[95:64]);
    mixColumns_32bit MIX3 (Data_in[127:96], Data_out[127:96]);

endmodule

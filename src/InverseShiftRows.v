module InverseShiftRows (
   input [0:127] Data_in,
	output [0:127] Data_shifted
);	
	assign Data_shifted[0+:8] = Data_in[0+:8]; assign Data_shifted[32+:8] = Data_in[32+:8]; assign Data_shifted[64+:8] = Data_in[64+:8]; assign Data_shifted[96+:8] = Data_in[96+:8];
	
	assign Data_shifted[8+:8] = Data_in[104+:8]; assign Data_shifted[40+:8] = Data_in[8+:8]; assign Data_shifted[72+:8] = Data_in[40+:8]; assign Data_shifted[104+:8] = Data_in[72+:8];
	
	assign Data_shifted[16+:8] = Data_in[80+:8]; assign Data_shifted[48+:8] = Data_in[112+:8]; assign Data_shifted[80+:8] = Data_in[16+:8]; assign Data_shifted[112+:8] = Data_in[48+:8];
	
    assign Data_shifted[24+:8] = Data_in[56+:8]; assign Data_shifted[56+:8] = Data_in[88+:8]; assign Data_shifted[88+:8] = Data_in[120+:8]; assign Data_shifted[120+:8] = Data_in[24+:8];
	
endmodule

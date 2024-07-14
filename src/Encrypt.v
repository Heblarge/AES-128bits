
module Encrypt #(
	parameter N=128,
	parameter Nr=10,
	parameter Nk=4
)(
	input  [N-1:0] in_1,
	input  [N-1:0] key_in,
	input  clk,
	input  rst,
	output [128-1:0] out
);
    wire [(N*(Nr + 1)) - 1 : 0] Fullkey;
    wire [(N*(Nr + 1)) - 1 : 0] Fullkey_in;
    wire [N-1:0] key;
	wire [N-1:0] State [Nr:0] ;
	wire [N-1:0] After_SB;
	wire [N-1:0] After_SR;
	wire [N-1:0] in_2;
	wire [N-1:0] in;
	
	Reg #(N) en_key (
	   .D(key_in),
	   .Q(key),
	   .rst(rst),
	   .clk(clk)
	);
	 
	Reg #(N) reg_in (
	   .D(in_1),
	   .Q(in_2),
	   .rst(rst),
	   .clk(clk)
	);
	// store the input

	KeyExpansion #(Nk, Nr) KE (
		.Key(key),
		.Fullkey(Fullkey_in)
	);
	// store the key
	Reg #(.N(128*(Nr+1))) reg_full_key (
	   .D(Fullkey_in),
	   .Q(Fullkey),
	   .rst(rst),
	   .clk(clk)
	);
	
	Reg #(N) reg_ii (
	   .D(in_2),
	   .Q(in),
	   .rst(rst),
	   .clk(clk)
	);

	AddRoundKey ARK_INITAL (
		.Data_in(in),
		.Data_out(State[0]),
		.Key(Fullkey[((128*(Nr+1))-1)-:128])
	);

	genvar i;
	generate
		for(i=1; i<Nr ;i=i+1)begin : aes_en_round
			EnRound er(
				.Data_in(State[i-1]),
				.Key(Fullkey[(((128*(Nr+1))-1)-128*i)-:128]),
				.Data_out(State[i])
			);	
		end
	endgenerate

	SubBytes SB(
		.Data_in(State[Nr-1]),
		.Data_out(After_SB)
	);

	ShiftRows SR(
		.Data_in(After_SB),
		.Data_shifted(After_SR)
	);

	AddRoundKey ARK_LAST(
		.Data_in(After_SR),
		.Data_out(State[Nr]),
		.Key(Fullkey[127:0])
	);
	
	Reg #(N) reg_state_out (
    .D(State[Nr]),
    .Q(out),
    .rst(rst),
    .clk(clk)
 );

endmodule

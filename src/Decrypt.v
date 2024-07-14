module Decrypt #(
     parameter N=128,
     parameter Nr=10,
     parameter Nk=4
    )( 
     input  [128-1:0] in_1,
     input  clk,
     input  rst,
     input  [N-1:0] key_in,
     output [128-1:0] out
    );
     
     wire [127:0] in_2;
     wire [127:0] in;
     wire [N - 1 : 0] key;
     wire [(128*(Nr+1))-1 :0] Fullkey;
     wire [(128*(Nr+1))-1 :0] Fullkey_in;
     wire [127:0] State [Nr+1:0] ;
     wire [127:0] State_out;
     wire [127:0] After_SB;
     wire [127:0] After_SR;
    
     Reg #(N) de_key (
        .D(key_in),
        .Q(key),
        .rst(rst),
        .clk(clk)
     );
     
     Reg #(128) reg_in_D (
        .D(in_1),
        .Q(in_2),
        .rst(rst),
        .clk(clk)
     );
 
    
     KeyExpansion_D #(Nk, Nr) KE (
      .Key(key),
      .Fullkey(Fullkey_in)
     );
    
   
     Reg #(.N(128*(Nr+1))) reg_full_key (
        .D(Fullkey_in),
        .Q(Fullkey),
        .rst(rst),
        .clk(clk)
     );
     
     Reg #(128) Dreg_ii (
        .D(in_2),
        .Q(in),
        .rst(rst),
        .clk(clk)
     );
    
      
     
     AddRoundKey INV_ARK_INITAL (
      .Data_in(in),
      .Data_out(State[0]),
      .Key(Fullkey[127:0])
     );
    
     genvar i;
     generate
      for(i=1; i<Nr ;i=i+1)begin : aes_de_round
       DeRound dr(
        .Data_in(State[i-1]),
        .Key(Fullkey[i*128+:128]),
        .Data_out(State[i])
       );
      end
     endgenerate
    
     InverseShiftRows Inv_SR(
      .Data_in(State[Nr-1]),
      .Data_shifted(After_SR)
     );
    
     InverseSubBytes INV_SB(
      .Data_in(After_SR),
      .Data_out(After_SB)
     );
    
     AddRoundKey INV_ARK_LAST(
      .Data_in(After_SB),
      .Data_out(State[Nr]),
      .Key(Fullkey[((128*(Nr+1))-1)-:128])
     );
    
     Reg #(128) Dreg_state_out (
        .D(State[Nr]),
        .Q(out),
        .rst(rst),
        .clk(clk)
     );
    endmodule

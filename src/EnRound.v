
module EnRound(
    input [127:0] Data_in,
    input [127:0] Key,
    output [127:0] Data_out
);

    wire [127:0] afterSubBytes;
    wire [127:0] afterShiftRows;
    wire [127:0] afterMixColumns;
    wire [127:0] afterAddroundKey;

    SubBytes uut1(
        .Data_in(Data_in),
        .Data_out(afterSubBytes)
    );
    ShiftRows uut2(
        .Data_in(afterSubBytes),
        .Data_shifted(afterShiftRows)
    );
    MixColumns uut3(
        .Data_in(afterShiftRows),
        .Data_out(afterMixColumns)
    );
    AddRoundKey uut4(
        .Data_in(afterMixColumns),
        .Data_out(Data_out),
        .Key(Key)
    );
		
endmodule

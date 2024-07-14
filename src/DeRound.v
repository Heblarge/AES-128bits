`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/14 18:16:28
// Design Name: 
// Module Name: DeRound
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module DeRound(   
    input [127:0] Data_in,
    output [127:0] Data_out,
    input [127:0] Key
);

    wire [127:0] afterSubBytes;
    wire [127:0] afterShiftRows;
    wire [127:0] afterMixColumns;
    wire [127:0] afterAddroundKey;

    InverseShiftRows uut1(
        .Data_in(Data_in),
        .Data_shifted(afterShiftRows)
    );
    
    InverseSubBytes uut2(
        .Data_in(afterShiftRows),
        .Data_out(afterSubBytes)
    );

    AddRoundKey uut3(
        .Data_in(afterSubBytes),
        .Data_out(afterAddroundKey),
        .Key(Key)
    );

    InverseMixColumns uut4(
        .Data_in(afterAddroundKey),
        .Data_out(Data_out)
    );
            
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/06/15 15:51:44
// Design Name: 
// Module Name: top
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


module top#(parameter len=128,
parameter  RNUM=10)
(
    input clk,
    input rst,
    input [len-1:0] key,
    input [len-1:0] plain_text_in,
    input [len-1:0] cipher_text_in,
    output [len-1:0] plain_text_out, 
    output [len-1:0] cipher_text_out
    );

Encrypt #(
    .N(len),
    .Nr(RNUM),
    .Nk(4)
) AES_Encrypt_uut(
    .in_1(plain_text_in),
    .key_in(key),
    .out(cipher_text_out),
    .clk(clk),
    .rst(rst)
);

Decrypt AES_Decrypt_uut(
    .in_1(cipher_text_in),
    .key_in(key),
    .out(plain_text_out),
    .clk(clk),
    .rst(rst)
);
endmodule
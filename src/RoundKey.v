`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/30 19:44:40
// Design Name: 
// Module Name: KE_E
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


module RoundKey(
    input [127:0] key,
    input [3:0] round,
    output [127:0] key_next
    );
    wire [31:0] Box_out;
    s_box Sbox1 (key[31:24], Box_out[31:24]);
    s_box Sbox2 (key[23:16], Box_out[23:16]);
    s_box Sbox3 (key[15:8], Box_out[15:8]);
    s_box Sbox4 (key[7:0], Box_out[7:0]);

    assign key_next[127:96] = Box_out ^ {RC(round),24'd0} ^ key[127:96];
    assign key_next[ 95:64] = key[ 95:64] ^ key_next[127:96];
    assign key_next[ 63:32] = key[ 63:32] ^ key_next[ 95:64];
    assign key_next[ 31: 0] = key[ 31: 0] ^ key_next[ 63:32];
    
    
    function [7:0]RC;
    input [3:0]round_n;
        begin:rc
            case (round_n)
                4'd1: RC = 8'h01;
                4'd2: RC = 8'h02;
                4'd3: RC = 8'h04;
                4'd4: RC = 8'h08;
                4'd5: RC = 8'h10;
                4'd6: RC = 8'h20;
                4'd7: RC = 8'h40;
                4'd8: RC = 8'h80;
                4'd9: RC = 8'h1b;
                4'd10: RC = 8'h36;
                default: RC = 8'd0;
            endcase
        end
    endfunction  
endmodule

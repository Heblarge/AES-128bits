
module Reg#(
    parameter N = 10)
(
    input [N - 1:0] D,
    input rst,
    input clk,
    output reg [N - 1:0] Q
    );
    always @(posedge clk or posedge rst)
    begin
         if (rst)
         begin 
            Q <= 0;
         end 
         else 
         begin
            Q <= D; 
         end 
    end 
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2026 07:56:27 PM
// Design Name: 
// Module Name: RF
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


 
module RF (A, B, SA, SB, D, DA, W, rst, clk);
 
output [3:0] A;
output [3:0] B;
input SA;
input SB;
input [3:0] D;
input DA;
input W;
input rst;
input clk;
 
wire [1:0] load_enable;
wire [3:0] R00, R01;
 
decoder1to2 decoder (load_enable, DA, W);     // decoder is a 1:2, producing 2 load-enable bits
RegisterNbit reg00 (D, R00, load_enable[0], rst, clk);
RegisterNbit reg01 (D, R01, load_enable[1], rst, clk);
mux muxa (A, R00, R01, SA);
mux muxb (B, R00, R01, SB);
 
endmodule
 
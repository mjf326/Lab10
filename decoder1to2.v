`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2026 07:51:08 PM
// Design Name: 
// Module Name: decoder1to2
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


module decoder1to2(m, S, en);

input S;
input en;
input [1:0] m;

assign m[0] = ~S & en;
assign m[1] = S & en;
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2026 07:52:33 PM
// Design Name: 
// Module Name: RegisterNbit
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


module RegisterNbit(D, Q, L, R, clock

    );
parameter N=4;
output reg [N-1:0] Q;
input [N-1:0] D;
input L;
input R;
input clock;

always @ (posedge clock or posedge R) begin
    if(R)
    Q<=0;
    else if (L)
    Q<= D;
    else 
    Q<=Q;
    end
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2026 07:57:43 PM
// Design Name: 
// Module Name: cu
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


module cu (clk, rst, start, rom_addr, DA, W, SA, SB, ram_we, ram_addr, done);
 
input clk;
input rst;
input start;
output [2:0] rom_addr;
output DA;          // which register the RF writes (0 = R00, 1 = R01)
output W;           // RF write enable
output SA;          // RF read select for output A
output SB;          // RF read select for output B
output ram_we;
output [2:0] ram_addr;
output done;
 
localparam S_IDLE    = 3'd0;
localparam S_ADDR_A  = 3'd1;
localparam S_LATCH_A = 3'd2;
localparam S_LATCH_B = 3'd3;
localparam S_WRITE   = 3'd4;
localparam S_DONE    = 3'd5;
 
reg [2:0] state;
reg [1:0] pair;     // which operand pair (0..3)
 
always @ (posedge clk) begin
    if (rst) begin
        state <= S_IDLE;
        pair  <= 2'd0;
    end else begin
        case (state)
            S_IDLE:    if (start) begin
                           pair  <= 2'd0;
                           state <= S_ADDR_A;
                       end
 
            S_ADDR_A:  state <= S_LATCH_A;
            S_LATCH_A: state <= S_LATCH_B;
            S_LATCH_B: state <= S_WRITE;
 
            S_WRITE:   if (pair == 2'd3) begin
                           state <= S_DONE;
                       end else begin
                           pair  <= pair + 2'd1;
                           state <= S_ADDR_A;
                       end
 
            S_DONE:    if (!start) state <= S_IDLE;   // done stays high until start is released
 
            default:   state <= S_IDLE;
        endcase
    end
end
 
// outputs
assign W        = (state == S_LATCH_A) | (state == S_LATCH_B);
assign DA       = (state == S_LATCH_B);               // 0 -> R00 (A), 1 -> R01 (B)
assign SA       = 1'b0;                               // A output always reads R00
assign SB       = 1'b1;                               // B output always reads R01
assign ram_we   = (state == S_WRITE);
assign done     = (state == S_DONE);
 
assign rom_addr = {pair, (state != S_ADDR_A)};        // last bit: 0 = A's address, 1 = B's address
assign ram_addr = {1'b0, pair};
 
endmodule
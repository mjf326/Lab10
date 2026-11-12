`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2026 02:03:39 PM
// Design Name: 
// Module Name: top_design
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


module top_design (
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire [2:0] rd_addr,
    output wire [7:0] result,
    output wire       done
);
 
    wire [2:0] rom_addr, cu_ram_addr, ram_addr;
    wire       DA, W, SA, SB, ram_we;
    wire [3:0] rom_data, opA, opB;
    wire [7:0] product;
 
    // cu owns the RAM address while writing, otherwise the outside reads
    assign ram_addr = ram_we ? cu_ram_addr : rd_addr;
 
    cu u_cu (
        .clk      (clk),
        .rst      (rst),
        .start    (start),
        .rom_addr (rom_addr),
        .DA       (DA),
        .W        (W),
        .SA       (SA),
        .SB       (SB),
        .ram_we   (ram_we),
        .ram_addr (cu_ram_addr),
        .done     (done)
    );
 
    rom #(.DATA_W(4), .ADDR_W(3), .SIZE(8)) u_rom (
        .i_clk      (clk),
        .i_rom_addr (rom_addr),
        .o_rom_data (rom_data)
    );
 
    RF u_rf (
        .A   (opA),
        .B   (opB),
        .SA  (SA),
        .SB  (SB),
        .D   (rom_data),
        .DA  (DA),
        .W   (W),
        .rst (rst),
        .clk (clk)
    );
 
    combinational_multiplier u_mult (
        .a (opA),
        .b (opB),
        .p (product)
    );
 
    ram #(.DATA_W(8), .ADDR_W(3), .SIZE(8)) u_ram (
        .i_clk        (clk),
        .i_rst        (rst),
        .i_write_en   (ram_we),
        .i_addr       (ram_addr),
        .i_write_data (product),
        .o_read_data  (result)
    );
 
endmodule
    
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2026 07:58:28 PM
// Design Name: 
// Module Name: tb_top_design
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


module tb_top_design;
 
    reg        clk = 1'b0;
    reg        rst = 1'b1;
    reg        start = 1'b0;
    reg  [2:0] rd_addr = 3'd0;
    wire [7:0] result;
    wire       done;
 
    reg [3:0] tb_rom [0:7];      // copy of the operands, used to compute expected values
    reg [7:0] expected;
    integer   k;
    integer   errors = 0;
 
    top_design dut (
        .clk     (clk),
        .rst     (rst),
        .start   (start),
        .rd_addr (rd_addr),
        .result  (result),
        .done    (done)
    );
 
    always #5 clk = ~clk;        // 10 ns clock
 
    // watchdog in case done never goes high
    initial begin
        #2000;
        $display("TIMEOUT: done never asserted");
        $finish;
    end
 
    initial begin
        $readmemh("ROM_Numbers.txt", tb_rom);
 
        #22 rst = 1'b0;          // release reset
        #10 start = 1'b1;        // start the multiplications
        wait (done);
        start = 1'b0;
 
        // read back each result from the RAM
        for (k = 0; k < 4; k = k + 1) begin
            rd_addr = k[2:0];
            @(posedge clk);
            #1;
            expected = tb_rom[2*k] * tb_rom[2*k+1];
 
            if (result === expected)
                $display("pair %0d: %0d x %0d = %0d, RAM = %0d  PASS",
                         k, tb_rom[2*k], tb_rom[2*k+1], expected, result);
            else begin
                errors = errors + 1;
                $display("pair %0d: %0d x %0d = %0d, RAM = %0d  FAIL",
                         k, tb_rom[2*k], tb_rom[2*k+1], expected, result);
            end
        end
 
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d ERROR(S)", errors);
 
        $finish;
    end
 
endmodule
 
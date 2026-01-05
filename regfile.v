`timescale 1ns / 1ps
module regfile(
    input clk,
    input rst_n,
    input [4:0] raddr1,
    input [4:0] raddr2,
    output [3:0] rdata1,
    output [3:0] rdata2,
    input [4:0] waddr,
    input [3:0] wdata,
    input write_en
    );
    // 32 registers, each 4-bit
    reg [3:0] regs [0:31];
    integer i;
    // Combinational read
    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];
    // Synchronous write
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for(i = 0; i < 32; i = i + 1)
                regs[i] <= 4'b0000;   // Reset all registers
        end
        else if(write_en) begin
            regs[waddr] <= wdata;    // Write ALU result
        end
    end
endmodule

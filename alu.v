`timescale 1ns / 1ps
module aluprocessor(
    input [3:0] a,b,
    input [2:0] opcode,
    input clk,rst_n,
    output reg [3:0] result,
    output reg carryout,
    output reg zeroflag
   );
reg [3:0]next_result;
reg next_carry;
reg [4:0] sum;
reg [7:0] memory [0:15];
integer i;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        result    <= 4'b0000;
        carryout  <= 1'b0;
        zeroflag  <= 1'b0;
        initmemory();
    end else begin
        result<=next_result;
        carryout<=next_carry;
        zeroflag <= (next_result == 8'd0);
    end
end
task initmemory;
    begin
        for(i=0; i<16; i=i+1)
            memory[i] = i[7:0];
    end
endtask
wire [4:0] diff;
assign diff = {1'b0,a} - {1'b0,b};
reg [7:0] mem_data;
always @(*) begin
 mem_data=memory[a];
 next_result=4'b0000;
 next_carry=1'b0;
    case(opcode)
        3'b000: begin
            sum=a+b;
            next_result   = sum[3:0];
            next_carry= sum[4];
        end
        3'b001: begin
            next_result   = diff[3:0];
            next_carry = diff[4];
        end
        3'b010: next_result = a & b;
        3'b011: next_result = a | b;
        3'b100: next_result = a ^ b;
        3'b101: next_result = ~(a | b);
        3'b110: next_result = a << 1;
        3'b111: next_result = mem_data[3:0];
        default: next_result = 4'b0000;
    endcase
end
endmodule

    
    
   


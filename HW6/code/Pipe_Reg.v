`timescale 1ns / 1ps
//Subject: CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version: 1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module Pipe_Reg(
    clk_i,
    rst_i,
    flush_i,
    data_i,
    data_o
    );

parameter size = 0;

input clk_i;	
input rst_i;
input flush_i;
input [size-1:0] data_i;
output reg [size-1:0] data_o;

reg [size-1:0]  pre;
reg             counter;

always@(posedge clk_i) begin
    if(~rst_i) begin
        data_o <= 0;
        pre <= 0;
        counter <= 0;
    end
    else if(flush_i) begin
        data_o <= 0;
        pre <= data_i;
        counter <= 1;
    end
    else if(counter) begin
        data_o <= pre;
        pre <= pre;
        counter <= 0;
    end
    else begin
        data_o <= data_i;
        pre <= pre;
        counter <= 0;
    end
end

endmodule	

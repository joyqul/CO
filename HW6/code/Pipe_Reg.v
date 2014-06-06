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
    stall_i,
    data_i,
    data_o
    );

parameter size = 0;

input clk_i;	
input rst_i;
input flush_i, stall_i;
input [size-1:0] data_i;
output reg [size-1:0] data_o;

always@(posedge clk_i) begin
    if(~rst_i) begin
        data_o <= 0;
    end
    else if(flush_i) begin
        data_o <= 0;
    end
    else if(stall_i) begin
        data_o <= data_o;
    end
    else begin
        data_o <= data_i;
    end
end

endmodule	

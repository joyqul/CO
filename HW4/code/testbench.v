`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:06:58 11/17/2013
// Design Name: 
// Module Name:    testbench 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define CYCLE_TIME 50			

module testbench;
  reg Clk, Start;
 // reg [31:0] i;

  Simple_Single_CPU CPU(Clk,Start);
  
  initial
  begin
    $dumpfile("cpu.vcd");
    $dumpvars(0, testbench);
    Clk = 0;
    Start = 0;
    
    #(`CYCLE_TIME)
    
    Start = 1;
    #(`CYCLE_TIME*320)	
    
  $finish;
  end
  
  always@(posedge Clk) begin
  	$display("PC = %d", CPU.PC.pc_out_o);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.Mem[0], CPU.Data_Memory.Mem[1], CPU.Data_Memory.Mem[2], CPU.Data_Memory.Mem[3], CPU.Data_Memory.Mem[4], CPU.Data_Memory.Mem[5], CPU.Data_Memory.Mem[6], CPU.Data_Memory.Mem[7]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.Mem[8], CPU.Data_Memory.Mem[9], CPU.Data_Memory.Mem[10], CPU.Data_Memory.Mem[11], CPU.Data_Memory.Mem[12], CPU.Data_Memory.Mem[13], CPU.Data_Memory.Mem[14], CPU.Data_Memory.Mem[15]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.Mem[16], CPU.Data_Memory.Mem[17], CPU.Data_Memory.Mem[18], CPU.Data_Memory.Mem[19], CPU.Data_Memory.Mem[20], CPU.Data_Memory.Mem[21], CPU.Data_Memory.Mem[22], CPU.Data_Memory.Mem[23]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.Data_Memory.Mem[24], CPU.Data_Memory.Mem[25], CPU.Data_Memory.Mem[26], CPU.Data_Memory.Mem[27], CPU.Data_Memory.Mem[28], CPU.Data_Memory.Mem[29], CPU.Data_Memory.Mem[30], CPU.Data_Memory.Mem[31]);
    $display("RF");
    $display("R0 = %d, R1 = %d, R2 = %d, R3 = %d, R4 = %d, R5 = %d, R6 = %d, R7 = %d", CPU.RF.REGISTER_BANK[ 0], CPU.RF.REGISTER_BANK[ 1], CPU.RF.REGISTER_BANK[ 2], CPU.RF.REGISTER_BANK[ 3], CPU.RF.REGISTER_BANK[ 4], CPU.RF.REGISTER_BANK[ 5], CPU.RF.REGISTER_BANK[ 6], CPU.RF.REGISTER_BANK[ 7]);
    $display("R8 = %d, R9 = %d, R10 =%d, R11 =%d, R12 =%d, R13 =%d, R14 =%d, R15 =%d", CPU.RF.REGISTER_BANK[ 8], CPU.RF.REGISTER_BANK[ 9], CPU.RF.REGISTER_BANK[10], CPU.RF.REGISTER_BANK[11], CPU.RF.REGISTER_BANK[12], CPU.RF.REGISTER_BANK[13], CPU.RF.REGISTER_BANK[14], CPU.RF.REGISTER_BANK[15]);
    $display("R16 =%d, R17 =%d, R18 =%d, R19 =%d, R20 =%d, R21 =%d, R22 =%d, R23 =%d", CPU.RF.REGISTER_BANK[16], CPU.RF.REGISTER_BANK[17], CPU.RF.REGISTER_BANK[18], CPU.RF.REGISTER_BANK[19], CPU.RF.REGISTER_BANK[20], CPU.RF.REGISTER_BANK[21], CPU.RF.REGISTER_BANK[22], CPU.RF.REGISTER_BANK[23]);
    $display("R24 =%d, R25 =%d, R26 =%d, R27 =%d, R28 =%d, R29 =%d, R30 =%d, R31 =%d", CPU.RF.REGISTER_BANK[24], CPU.RF.REGISTER_BANK[25], CPU.RF.REGISTER_BANK[26], CPU.RF.REGISTER_BANK[27], CPU.RF.REGISTER_BANK[28], CPU.RF.REGISTER_BANK[29], CPU.RF.REGISTER_BANK[30], CPU.RF.REGISTER_BANK[31]);
  end

  always #(`CYCLE_TIME/2) Clk = ~Clk;	
  
endmodule


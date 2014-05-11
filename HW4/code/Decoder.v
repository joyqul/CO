//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	Branch_o,
    MemToReg_o,
    BranchType_o,
    Jump_o,
    MemRead_o,
    MemWrite_o,
	ALUOp_o,
	ALUSrc_o,
	RegWrite_o,
	RegDst_o
	);
     
//I/O ports
input  [6-1:0]  instr_op_i;

output          Branch_o;
output [2-1:0]  MemToReg_o;
output [2-1:0]  BranchType_o;
output          Jump_o;
output          MemRead_o;
output          MemWrite_o;
output [3-1:0]  ALUOp_o;
output          ALUSrc_o;
output          RegWrite_o;
output          RegDst_o;
 
//Internal Signals
wire            Branch_o;
wire   [2-1:0]  MemToReg_o;
wire   [2-1:0]  BranchType_o;
wire            Jump_o;
wire            MemRead_o;
wire            MemWrite_o;
wire   [3-1:0]  ALUOp_o;
wire            ALUSrc_o;
wire            RegWrite_o;
wire            RegDst_o;

//Parameter


//Main function
// Branch_o
assign Branch_o = (instr_op_i == 6'b000100)? 1: // BEQ
                  1'b0;

// MemToReg_o
assign MemToReg_o = (instr_op_i == 6'b100011)? 2'b01: // lw
                    (instr_op_i == 6'b000011)? 2'b10: // jal
                    (instr_op_i == 6'b001000)? 2'b10: // ADDI
                    (instr_op_i == 6'b001010)? 2'b10: // SLTI
                    2'b00;
                  
// BranchType_o
assign BranchType_o = 2'b00;
                    
// Jump_o
assign Jump_o = (instr_op_i == 6'b000010)? 0: // Jump
                (instr_op_i == 6'b000011)? 0: // jal
                1'b1;

// MemRead_o
assign MemRead_o = (instr_op_i == 6'b100011)? 1: // lw
                   1'b0;

// MemWrite_o
assign MemWrite_o = (instr_op_i == 6'b101011)? 1: 0; // sw

// ALU_op_o
assign ALUOp_o = (instr_op_i == 6'b000000)? 3'b010: // R-type & jr
                 (instr_op_i == 6'b000100)? 3'b001: // BEQ
                 (instr_op_i == 6'b001000)? 3'b011: // ADDI
                 (instr_op_i == 6'b001010)? 3'b100: // SLTI
                 (instr_op_i == 6'b100011)? 3'b000: // lw
                 (instr_op_i == 6'b101011)? 3'b000: // sw
                 (instr_op_i == 6'b000010)? 3'b101: // Jump
                 (instr_op_i == 6'b000011)? 3'b000: // jal
                 3'b0;
// ALUSrc_o
assign ALUSrc_o = (instr_op_i == 6'b000000)? 0: // R-type
                  (instr_op_i == 6'b000100)? 0: // BEQ
                  (instr_op_i == 6'b001000)? 1: // ADDI
                  (instr_op_i == 6'b001010)? 1: // SLTI
                  (instr_op_i == 6'b100011)? 1: // lw
                  (instr_op_i == 6'b101011)? 1: // sw
                  1'b0;
// RegWrite_o
assign RegWrite_o = (instr_op_i == 6'b000000)? 1: // R-type
                    (instr_op_i == 6'b000100)? 0: // BEQ
                    (instr_op_i == 6'b001000)? 1: // ADDI
                    (instr_op_i == 6'b001010)? 1: // SLTI
                    (instr_op_i == 6'b100011)? 1: // lw
                    1'b0;
// RegDst_o
assign RegDst_o = (instr_op_i == 6'b000000)? 1: // R-type
                  (instr_op_i == 6'b000100)? 0: // BEQ
                  (instr_op_i == 6'b001000)? 0: // ADDI
                  (instr_op_i == 6'b001010)? 0: // SLTI
                  (instr_op_i == 6'b100011)? 0: // lw
                  1'b0;
endmodule

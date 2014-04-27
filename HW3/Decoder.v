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
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegWrite_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
wire   [3-1:0] ALU_op_o;
wire           ALUSrc_o;
wire           RegWrite_o;
wire           RegDst_o;
wire           Branch_o;

//Parameter


//Main function
// ALU_op_o
assign ALU_op_o = (instr_op_i == 6'b000000)? 3'b010: // R-type
                  (instr_op_i == 6'b000100)? 3'b001: // BEQ
                  (instr_op_i == 6'b001000)? 3'b011: // ADDI
                  (instr_op_i == 6'b001010)? 3'b011: // SLTI
                  3'b0;
// ALUSrc_o
assign ALUSrc_o = (instr_op_i == 6'b000000)? 0: // R-type
                  (instr_op_i == 6'b000100)? 0: // BEQ
                  (instr_op_i == 6'b001000)? 1: // ADDI
                  (instr_op_i == 6'b001010)? 1: // SLTI
                  1'b0;
// RegWrite_o
assign RegWrite_o = (instr_op_i == 6'b000000)? 1: // R-type
                    (instr_op_i == 6'b000100)? 0: // BEQ
                    (instr_op_i == 6'b001000)? 1: // ADDI
                    (instr_op_i == 6'b001010)? 1: // SLTI
                    1'b0;
// RegDst_o
assign RegDst_o = (instr_op_i == 6'b000000)? 1: // R-type
                  (instr_op_i == 6'b000100)? 0: // BEQ
                  (instr_op_i == 6'b001000)? 0: // ADDI
                  (instr_op_i == 6'b001010)? 0: // SLTI
                  1'b0;
// Branch_o
assign Branch_o = (instr_op_i == 6'b000000)? 0: // R-type
                  (instr_op_i == 6'b000100)? 1: // BEQ
                  (instr_op_i == 6'b001000)? 0: // ADDI
                  (instr_op_i == 6'b001010)? 0: // SLTI
                  1'b0;

endmodule

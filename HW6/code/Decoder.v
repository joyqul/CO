//Subject:     CO example - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
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
    Branch_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o
    );
     
//I/O ports
input   [6-1:0] instr_op_i;

output          RegWrite_o;
output  [3-1:0] ALU_op_o;
output          ALUSrc_o;
output          RegDst_o;
output          Branch_o;
output          MemtoReg_o;
output          MemRead_o;
output          MemWrite_o;
 
//Internal Signals
reg     [3-1:0] ALU_op_o;
reg             ALUSrc_o;
reg             RegWrite_o;
reg             RegDst_o;
reg             Branch_o;
reg             MemtoReg_o;
reg             MemRead_o;
reg             MemWrite_o;


//Main function
always@(instr_op_i)
begin
    case(instr_op_i)
        0: // R-type
            ALU_op_o = 3'b010;
        35: // load
            ALU_op_o = 3'b000;
        43: // store
            ALU_op_o = 3'b000;
        4: // beq
            ALU_op_o = 3'b001;
        5: // bne
            ALU_op_o = 3'b011;
        1: // bge
            ALU_op_o = 3'b110;
        7: // bgt
            ALU_op_o = 3'b111;
        8: // addi
            ALU_op_o = 3'b100;
        10: // slti
            ALU_op_o = 3'b101;
        default: // nop
            ALU_op_o = 3'b000;
    endcase
end

always@(instr_op_i)
begin
    if(instr_op_i == 35 || instr_op_i == 43 || instr_op_i == 8 || instr_op_i == 10) // load / store / I format
        ALUSrc_o = 1;
    else
        ALUSrc_o = 0;
end

always@(instr_op_i)
begin
    if(instr_op_i == 0 || instr_op_i == 35 || instr_op_i == 8 || instr_op_i == 10) // R-type / load / I format
        RegWrite_o = 1;
    else
        RegWrite_o = 0;
end

always@(instr_op_i)
begin
    if(instr_op_i == 0) // R-type
        RegDst_o = 1;
    else
        RegDst_o = 0;
end

always@(instr_op_i)
begin
    if(instr_op_i == 4 || instr_op_i == 5 || instr_op_i == 1 || instr_op_i == 7) // beq
        Branch_o = 1;
    else
        Branch_o = 0;
end

always@(instr_op_i)
begin
    if(instr_op_i == 35) // load
        MemtoReg_o = 1;
    else
        MemtoReg_o = 0;
end

always@(instr_op_i)
begin
    if(instr_op_i == 35) // load
        MemRead_o = 1;
    else
        MemRead_o = 0;
end

always@(instr_op_i)
begin
    if(instr_op_i == 43) // store
        MemWrite_o = 1;
    else
        MemWrite_o = 0;
end

endmodule

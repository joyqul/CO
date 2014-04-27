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
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

//Parameter


//Main function
// ALU_op_o
always@(*) begin
    case (instr_op_i)
        // R-type (ADD, ...etc)
        6'b00-0000: begin
            ALU_op_o <= 3'b010;
        end
        // BEQ
        6'b00-0100: begin
            ALU_op_o <= 3'b001;
        end
        // ADDI
        6'b00-1000: begin
            ALU_op_o <= 3'b011;
        end
        // SLTI
        6'b00-1010: begin
            ALU_op_o <= 3'b111;
        end
    endcase
end

// ALUSrc_o
always@(*) begin
    case (instr_op_i)
        // R-type (ADD, ...etc)
        6'b00-0000: begin
            ALUSrc_o <= 0;
        end
        // BEQ
        6'b00-0100: begin
            ALUSrc_o <= 0;
        end
        // ADDI
        6'b00-1000: begin
            ALUSrc_o <= 1;
        end
        // SLTI
        6'b00-1010: begin
            ALUSrc_o <= 1;
        end
    endcase
end

// RegWrite_o
always@(*) begin
    case (instr_op_i)
        // R-type (ADD, ...etc)
        6'b00-0000: begin
            RegWrite_o <= 1;
        end
        // BEQ
        6'b00-0100: begin
            RegWrite_o <= 0;
        end
        // ADDI
        6'b00-1000: begin
            RegWrite_o <= 1;
        end
        // SLTI
        6'b00-1010: begin
            RegWrite_o <= 1;
        end
    endcase
end

// RegDst_o
always@(*) begin
    case (instr_op_i)
        // R-type (ADD, ...etc)
        6'b00-0000: begin
            RegDst_o <= 1;
        end
        // BEQ
        6'b00-0100: begin
            RegDst_o <= 0;
        end
        // ADDI
        6'b00-1000: begin
            RegDst_o <= 0;
        end
        // SLTI
        6'b00-1010: begin
            RegDst_o <= 0;
        end
    endcase
end

// Branch_o
always@(*) begin
    case (instr_op_i)
        // R-type (ADD, ...etc)
        6'b00-0000: begin
            Branch_o <= 0;
        end
        // BEQ
        6'b00-0100: begin
            Branch_o <= 1;
        end
        // ADDI
        6'b00-1000: begin
            Branch_o <= 0;
        end
        // SLTI
        6'b00-1010: begin
            Branch_o <= 0;
        end
    endcase
end

endmodule

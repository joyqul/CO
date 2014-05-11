//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter
//Select exact operation
always@(*) begin
    case (ALUOp_i)
        // LW, SW
        0: ALUCtrl_o = 4'b0010;
        // BEQ
        1: ALUCtrl_o = 4'b0110;
        2: begin
            case (funct_i)
                // ADD
                6'b100000: ALUCtrl_o = 4'b0010;
                // SUB
                6'b100010: ALUCtrl_o = 4'b0110;
                // AND
                6'b100100: ALUCtrl_o = 4'b0000;
                // OR
                6'b100101: ALUCtrl_o = 4'b0001;
                // SLT
                6'b101010: ALUCtrl_o = 4'b0111;
                // jr
                6'b001000: ALUCtrl_o = 4'b0000;
            endcase
        end
        // ADDI
        3: ALUCtrl_o = 4'b0010;
        // SLTI
        4: ALUCtrl_o = 4'b0111;
        // JUMP
        5: ALUCtrl_o = 4'b0000;
    endcase
end
       
endmodule     

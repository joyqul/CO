//Subject:     CO example - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
    );

//I/O ports 
input   [6-1:0] funct_i;
input   [3-1:0] ALUOp_i;

output  [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg     [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation
always@(funct_i or ALUOp_i) 
begin
    case(ALUOp_i)
        0: ALUCtrl_o = 4'b0010; // lw / sw
        1: ALUCtrl_o = 4'b0110; // beq
        2: // R-type
        begin
            case(funct_i)
                24: ALUCtrl_o = 4'b1000; // mult
                36: ALUCtrl_o = 4'b0000; // and   0000
                37: ALUCtrl_o = 4'b0001; // or    0001
                32: ALUCtrl_o = 4'b0010; // add   0010
                34: ALUCtrl_o = 4'b0110; // sub   0110
                42: ALUCtrl_o = 4'b0111; // slt   0111
				default: ALUCtrl_o = ALUCtrl_o;
            endcase
        end
        4: ALUCtrl_o = 4'b 0010;         // addi  0010		
		5: ALUCtrl_o = 4'b 0111;         // slti  0111
        default: ALUCtrl_o = 4'b0000;    // nop
    endcase
end

endmodule     

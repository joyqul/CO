//Subject:     CO example - ALU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU(
    src1_i,
    src2_i,
    ctrl_i,
    result_o,
    zero_o
    );
     
//I/O ports
input   [32-1:0]    src1_i;
input   [32-1:0]    src2_i;
input   [4-1:0]     ctrl_i;

output  [32-1:0]    result_o;
output              zero_o;

//Internal signals
reg     [32-1:0]    result_o;
wire                zero_o;

//Parameter

//Main function
assign zero_o = (result_o == 0);

always@(ctrl_i or src1_i or src2_i)
begin
    case(ctrl_i)
        0: result_o = src1_i & src2_i; // and   0000
        1: result_o = src1_i | src2_i; // or    0001
        2: result_o = src1_i + src2_i; // add   0010
        6: result_o = src1_i - src2_i; // sub   0110
        7: result_o = (src1_i < src2_i) ? 1 : 0; // slt   0111
        8: result_o = src1_i * src2_i; // mult
        default: result_o = 0; // nop
    endcase
end

endmodule

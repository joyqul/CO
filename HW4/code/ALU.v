//Subject:     CO project 2 - ALU
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
input  [32-1:0]  src1_i;
input  [32-1:0]	 src2_i;
input  [4-1:0]   ctrl_i;

output [32-1:0]	 result_o;
output           zero_o;

//Internal signals
wire   [32-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
assign zero_o = result_o == 0? 1: 0;
assign result_o = (ctrl_i == 4'b0000)? src1_i & src2_i: // AND
                  (ctrl_i == 4'b0001)? src1_i | src2_i: // OR
                  (ctrl_i == 4'b0010)? src1_i + src2_i: // ADD
                  (ctrl_i == 4'b0110)? src1_i - src2_i: // SUB
                  (ctrl_i == 4'b0111)? ((src1_i < src2_i)? 1: 0): // SLT
                  (ctrl_i == 4'b1000)? src1_i: // jal
                  32'b0;

endmodule

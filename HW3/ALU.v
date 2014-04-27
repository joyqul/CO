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
reg    [32-1:0]  result_o;
wire             zero_o;

//Parameter

//Main function
assign zero_o = result_o == 0? 1: 0;

always@(*) begin
    case (ctrl_i)
        // AND
        4'b000: begin
            result_o = src1_i & src2_i;
        end
        // OR
        4'b0001: begin
            result_o = src1_i | src2_i;
        end
        // ADD
        4'b0010: begin
            result_o = src1_i + src2_i;
        end
        // SUB
        4'b0110: begin
            result_o = src1_i - src2_i;
        end
        // SLT
        4'b0111: begin
            result_o = src1_i < src2_i? 1: 0;
        end
        default: begin
            result_o = result_o;
        end
    endcase
end

endmodule

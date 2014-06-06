//Subject:     CO example - PC
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ProgramCounter(
    clk_i,
    rst_i,
    pc_in_i,
    pc_write_i,
    pc_out_o
    );
     
//I/O ports
input               clk_i;
input               rst_i;
input               pc_write_i;
input   [32-1:0]    pc_in_i;
output  [32-1:0]    pc_out_o;
 
//Internal Signals
reg     [32-1:0]    pc_out_o;
reg     [32-1:0]    pre;
 
//Parameter

    
//Main function
always@(posedge clk_i)
begin
    if(~rst_i) begin
	    pc_out_o <= 0;
        pre <= 0;
    end
	else if (!pc_write_i) begin
	    pc_out_o <= pc_in_i;
        pre <= pc_in_i;
    end
    else begin
	    pc_out_o <= pre;
        pre <= pre;
    end
end

endmodule

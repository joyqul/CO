`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe Register
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_Reg(
    clk_i,
    rst_i,
    data_i,
    data_o
    );
					
parameter size = 0;

input   clk_i;		  
input   rst_i;
input   [size-1:0] data_i;
output reg  [size-1:0] data_o;

// Internal signal
reg     [1:0]       counter;
reg     [size-1:0]  record;
	  
always@(posedge clk_i) begin
    if(~rst_i) begin
        counter <= 0;
        record <= 0;
        data_o <= 0;
    end
    else if (counter != 0 && counter != 1) begin
        counter <= counter - 1;
        record <= record;
        data_o <= {1'b1, 64'd0};
    end
    else if (counter == 1) begin
        counter <= 0;
        record <= 0;
        data_o <= record;
    end
    else if (size == 65) begin
        if (record[31:26] == 4) begin // beq
            counter <= 2;
            record <= data_i;
            data_o <= {1'b1, 64'd0};
        end
        else if ((data_i[31:26] == 35 || data_i[31:26] == 43 || data_i[31:26] == 8 || data_i[31:26] == 10) &&
                (record[31:26] == 35 || record[31:26] == 43 || record[31:26] == 8 || record[31:26] == 10) &&
                (record[20:16] == data_i[25:21])) begin // lw / sw / addi / slti
            counter <= 2;
            record <= data_i;
            data_o <= {1'b1, 64'd0};
        end
        else if ((data_i[31:26] == 35 || data_i[31:26] == 43 || data_i[31:26] == 8 || data_i[31:26] == 10) &&
                (record[31:26] == 0) &&
                (record[15:11] == data_i[25:21])) begin // lw / sw / addi / slti
            counter <= 1;
            record <= data_i;
            data_o <= {1'b1, 64'd0};
        end
        else if ((data_i[31:26] == 0) && 
                (record[31:26] == 35 || record[31:26] == 43 || record[31:26] == 8 || record[31:26] == 10) &&
                (data_i[25:21] == record[20:16] || data_i[20:16] == record[20:16])) begin
            counter <= 2;
            record <= data_i;
            data_o <= {1'b1, 64'd0};
        end
        else if ((data_i[31:26] == 0) && 
                (record[31:26] == 0) &&
                (data_i[25:21] == record[15:11] || data_i[20:16] == record[15:11])) begin
            counter <= 1;
            record <= data_i;
            data_o <= {1'b1, 64'd0};
        end
        else begin
            counter <= counter;
            record <= data_i;
            data_o <= data_i;
        end
    end
    else begin
        counter <= counter;
        record <= data_i;
        data_o <= data_i;
    end
end

endmodule	

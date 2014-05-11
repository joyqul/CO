module Shift_Left_Two_26(
    data_i,
    pc_i,
    data_o
    );

//I/O ports                    
input [26-1:0] data_i;
input [4-1:0]  pc_i;
output [32-1:0] data_o;

//shift left 2
assign data_o = {pc_i, data_i[25:0], 2'b00};
     
endmodule

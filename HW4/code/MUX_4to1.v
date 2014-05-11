module MUX_4to1(
               data0_i,
               data1_i,
               data2_i,
               data3_i,
               select_i,
               data_o
               );

			
//I/O ports               
input   [32-1:0] data0_i;          
input   [32-1:0] data1_i;
input   [32-1:0] data2_i;
input   [32-1:0] data3_i;
input   [2-1:0]  select_i;
output  [32-1:0] data_o; 

//Internal Signals
wire    [32-1:0] data_o;

//Main function
assign data_o = (select_i == 0)? data0_i: 
                (select_i == 1)? data1_i:
                (select_i == 2)? data2_i:
                data3_i;

endmodule      

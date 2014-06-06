module Forwading(
    EX_rs_i,
    EX_rt_i,
    MEM_write_reg_i,
    MEM_reg_write_i,
    forwarding_rs_o,
    forwarding_rt_o
    );

input   [5-1:0] EX_rs_i, EX_rt_i, MEM_write_reg_i;
input           MEM_reg_write_i;
output  [2-1:0] forwarding_rs_o, forwarding_rt_o;

assign forwarding_rs_o = !MEM_reg_write_i? 0:
                         (MEM_write_reg_i == EX_rs_i)? 1: 
                         0;

assign forwarding_rt_o = !MEM_reg_write_i? 0:
                         (MEM_write_reg_i == EX_rt_i)? 1: 
                         0;

endmodule

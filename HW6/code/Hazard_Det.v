module Hazard_Det(
    pc_src_i,
    ID_instr_i,
    ID_rs_i,
    ID_rt_i,
    EX_rt_i,
    EX_mem_read_i,
    IF_stall_o,
    IF_flush_o,
    ID_flush_o,
    EX_flush_o,
    pc_write_o
);

input           pc_src_i;
input   [6-1:0] ID_instr_i;
input   [5-1:0] ID_rs_i, ID_rt_i, EX_rt_i;
input           EX_mem_read_i, EX_mem_write_i;

output          pc_write_o, IF_stall_o;
output          IF_flush_o, ID_flush_o, EX_flush_o;

assign IF_stall_o = EX_mem_read_i & ( (EX_rt_i == ID_rs_i) |  ((EX_rt_i == ID_rt_i) & (ID_instr_i != 6'd0)) );

assign pc_write_o = EX_mem_read_i & ( (EX_rt_i == ID_rs_i) |  ((EX_rt_i == ID_rt_i) & (ID_instr_i != 6'd0)) );

assign IF_flush_o = pc_src_i;

assign ID_flush_o = pc_src_i;

assign EX_flush_o = pc_src_i;

endmodule

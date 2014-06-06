module Hazard_Det(
    ID_instr_i,
    ID_rs_i,
    ID_rt_i,
    EX_rt_i,
    EX_mem_read_i,
    IF_stall_o,
    ID_flush_o,
    pc_write_o
);

input   [6-1:0] ID_instr_i;
input   [5-1:0] ID_rs_i, ID_rt_i, EX_rt_i;
input           EX_mem_read_i, EX_mem_write_i;

output          pc_write_o, IF_stall_o;
output          ID_flush_o;

assign IF_stall_o = EX_mem_read_i & ( (EX_rt_i == ID_rs_i) |  ((EX_rt_i == ID_rt_i) & (ID_instr_i != 6'd0)) );
assign pc_write_o = EX_mem_read_i & ( (EX_rt_i == ID_rs_i) |  ((EX_rt_i == ID_rt_i) & (ID_instr_i != 6'd0)) );

assign ID_flush_o = EX_mem_read_i & ( (EX_rt_i == ID_rs_i) |  ((EX_rt_i == ID_rt_i) & (ID_instr_i != 6'd0)) );

endmodule

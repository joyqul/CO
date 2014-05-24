`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire    [32-1:0]    pc, pc4, next_pc, pc_branch;
wire    [32-1:0]    instruction;

wire    [64-1:0]    IF_ID_out;

/**** ID stage ****/
wire    [32-1:0]    read_data1, read_data2;
wire    [32-1:0]    imm_ext;

wire    [148-1:0]   ID_EX_out;

//control signal
wire                pc_src, alu_src, reg_dst, reg_write, branch, mem_to_reg, mem_read, mem_write;
wire    [3-1:0]     alu_op;

wire    [107-1:0]   EX_MEM_out;

/**** EX stage ****/
wire    [32-1:0]    imm_ext_shift;
wire    [4-1:0]     alu_control;
wire    [32-1:0]    alu_src2, alu_result;
wire                alu_zero;
wire    [5-1:0]     write_reg;

wire    [71-1:0]    MEM_WB_out;

//control signal


/**** MEM stage ****/
wire    [32-1:0]    dm_read;

//control signal


/**** WB stage ****/
wire    [32-1:0]    write_data;

//control signal


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
	.data0_i(pc4),
	.data1_i(pc_branch),
	.select_i(pc_src),
	.data_o(next_pc)
);

ProgramCounter PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .pc_in_i(next_pc),
    .pc_out_o(pc)
);

Instruction_Memory IM(
    .addr_i(pc),
    .instr_o(instruction)
);
			
Adder Add_pc(
    .src1_i(pc),
    .src2_i(32'd4),
    .sum_o(pc4)
);

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({pc4, instruction}),
    .data_o(IF_ID_out)
);


//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(IF_ID_out[25:21]),
    .RTaddr_i(IF_ID_out[20:16]),
    .RDaddr_i(MEM_WB_out[4:0]),
    .RDdata_i(write_data),
    .RegWrite_i(MEM_WB_out[70]),
    .RSdata_o(read_data1),
    .RTdata_o(read_data2)
);

Decoder Control(
    .instr_op_i(IF_ID_out[31:26]),
    .RegWrite_o(reg_write),
    .ALU_op_o(alu_op),
    .ALUSrc_o(alu_src),
    .RegDst_o(reg_dst),
    .Branch_o(branch),
    .MemtoReg_o(mem_to_reg),
    .MemRead_o(mem_read),
    .MemWrite_o(mem_write)
);

Sign_Extend Sign_Extend(
    .data_i(IF_ID_out[15:0]),
    .data_o(imm_ext)
);	

Pipe_Reg #(.size(148)) ID_EX(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({reg_write, branch, reg_dst, alu_op, alu_src, mem_read, mem_write, mem_to_reg,
        IF_ID_out[63:32], read_data1, read_data2, imm_ext, IF_ID_out[20:11]}),
    .data_o(ID_EX_out)
);


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
    .data_i(ID_EX_out[41:10]),
    .data_o(imm_ext_shift)
);

ALU ALU(
    .src1_i(ID_EX_out[105:74]),
    .src2_i(alu_src2),
    .ctrl_i(alu_control),
    .result_o(alu_result),
    .zero_o(alu_zero)
);
		
ALU_Control ALU_Control(
    .funct_i(ID_EX_out[15:10]),
    .ALUOp_i(ID_EX_out[144:142]),
    .ALUCtrl_o(alu_control)
);

MUX_2to1 #(.size(32)) Mux1(
    .data0_i(ID_EX_out[73:42]),
    .data1_i(ID_EX_out[41:10]),
    .select_i(ID_EX_out[141]),
    .data_o(alu_src2)
);
		
MUX_2to1 #(.size(5)) Mux2(
    .data0_i(ID_EX_out[9:5]),
    .data1_i(ID_EX_out[4:0]),
    .select_i(ID_EX_out[145]),
    .data_o(write_reg)
);

Adder Add_pc_branch(
    .src1_i(ID_EX_out[137:106]),     
    .src2_i(imm_ext_shift),     
    .sum_o(pc_branch)    
);

Pipe_Reg #(.size(107)) EX_MEM(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({ID_EX_out[147:146], ID_EX_out[140:138], pc_branch, alu_zero, alu_result, ID_EX_out[73:42], write_reg}),
    .data_o(EX_MEM_out)
);


//Instantiate the components in MEM stage
assign pc_src = EX_MEM_out[105] & EX_MEM_out[69];
Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(EX_MEM_out[68:37]),
    .data_i(EX_MEM_out[36:5]),
    .MemRead_i(EX_MEM_out[104]),
    .MemWrite_i(EX_MEM_out[103]),
    .data_o(dm_read)
);

Pipe_Reg #(.size(71)) MEM_WB(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .data_i({EX_MEM_out[106], EX_MEM_out[102], dm_read, EX_MEM_out[68:37], EX_MEM_out[4:0]}),
    .data_o(MEM_WB_out)
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
    .data0_i(MEM_WB_out[36:5]),
    .data1_i(MEM_WB_out[68:37]),
    .select_i(MEM_WB_out[69]),
    .data_o(write_data)
);

/****************************************
signal assignment
****************************************/

endmodule


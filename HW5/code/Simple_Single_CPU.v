//Subject:     CO example - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
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

wire [32-1:0] pc;
wire [32-1:0] pc4;
wire [32-1:0] next_pc;
wire [32-1:0] instruction;

wire [32-1:0] read_data1;
wire [32-1:0] read_data2;
wire [32-1:0] imm_ext;

wire reg_write;
wire [3-1:0] alu_op;
wire alu_src;
wire reg_dst;
wire branch;
wire mem_to_reg;
wire mem_read;
wire mem_write;

wire [4-1:0] alu_control;
wire [32-1:0] alu_src2;
wire [32-1:0] alu_result;
wire alu_zero;
wire [5-1:0] write_reg;
wire [32-1:0] imm_ext_shift;
wire [32-1:0] pc_branch;

wire pc_src;
wire [32-1:0] dm_read;

wire [32-1:0] write_data;



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
    .src2_i(32'b100),
    .sum_o(pc4)
);

		
//Instantiate the components in ID stage
Reg_File RF(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .RSaddr_i(instruction[25:21]),
    .RTaddr_i(instruction[20:16]),
    .RDaddr_i(write_reg),
    .RDdata_i(write_data),
    .RegWrite_i(reg_write),
    .RSdata_o(read_data1),
    .RTdata_o(read_data2)
);

Decoder Control(
    .instr_op_i(instruction[31:26]),
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
    .data_i(instruction[15:0]),
    .data_o(imm_ext)
);	


//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
    .data_i(imm_ext),
    .data_o(imm_ext_shift)
);

ALU ALU(
    .src1_i(read_data1),
    .src2_i(alu_src2),
    .ctrl_i(alu_control),
    .result_o(alu_result),
    .zero_o(alu_zero)
);
		
ALU_Control ALU_Control(
    .funct_i(imm_ext[5:0]),
    .ALUOp_i(alu_op),
    .ALUCtrl_o(alu_control)
);

MUX_2to1 #(.size(32)) Mux1(
    .data0_i(read_data2),
    .data1_i(imm_ext),
    .select_i(alu_src),
    .data_o(alu_src2)
);
		
MUX_2to1 #(.size(5)) Mux2(
    .data0_i(instruction[20:16]),
    .data1_i(instruction[15:11]),
    .select_i(reg_dst),
    .data_o(write_reg)
);

Adder Add_pc_branch(
    .src1_i(pc4),     
    .src2_i(imm_ext_shift),     
    .sum_o(pc_branch)    
);


//Instantiate the components in MEM stage
assign pc_src = branch & alu_zero;

Data_Memory DM(
    .clk_i(clk_i),
    .addr_i(alu_result),
    .data_i(read_data2),
    .MemRead_i(mem_read),
    .MemWrite_i(mem_write),
    .data_o(dm_read)
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
    .data0_i(alu_result),
    .data1_i(dm_read),
    .select_i(mem_to_reg),
    .data_o(write_data)
);

/****************************************
signal assignment
****************************************/	
endmodule


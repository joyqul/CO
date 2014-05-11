//Subject:     CO project 2 - Simple Single CPU
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
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles
wire    [32-1:0]    ALUResult, JumpAddr, NoJumpAddr;
wire    [32-1:0]    pc_in, final_pc, pc_out;
wire    [32-1:0]    sum_pc_four, sign_extend, ALUInput, BranchAddr, shift_left_2;
wire    [32-1:0]    instr;
wire    [32-1:0]    RSdata, RTdata, RDdata, RFinput, DMResult;
wire    [3-1:0]     ALUOp;
wire    [5-1:0]     RDaddr, RTaddr, RSaddr;
wire    [4-1:0]     ALUCtrl;    
wire    [2-1:0]     BranchType, MemToReg, RegDst;
wire                ALUSrc, Branch, RegWrite, ALUZero, MemRead, MemWrite, Jump;

//Greate componentes
assign pc_in = (rst_i == 0)? 0: 
               (jr == 1)? RSdata:
               final_pc;
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
// PC = PC + 4
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(32'd4),     
	    .sum_o(sum_pc_four)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr)    
	    );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
		.Branch_o(Branch), 
        .MemToReg_o(MemToReg),
        .BranchType_o(BranchType),
        .Jump_o(Jump),
        .MemRead_o(MemRead),
        .MemWrite_o(MemWrite),
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegWrite_o(RegWrite), 
	    .RegDst_o(RegDst)
	    );

// Write Reg
MUX_4to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .data2_i(5'd31),
        .data3_i(5'd0),
        .select_i(RegDst),
        .data_o(RDaddr)
        );	

wire jal, jr;
assign jal = (instr[31:26] == 6'b000011)? 1: 0;
assign jr = ({instr[31:26], instr[5:0]} == {6'b000000, 6'b001000})? 1: 0;

MUX_2to1 #(.size(5)) MUX_RF_RSaddr(
        .data0_i(instr[25:21]),
        .data1_i(5'd29),
        .select_i(jal),
        .data_o(RSaddr)
        );
		
MUX_2to1 #(.size(5)) MUX_RF_RTaddr(
        .data0_i(instr[20:16]),
        .data1_i(5'd31),
        .select_i(jal),
        .data_o(RTaddr)
        );
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i),     
        .RSaddr_i(RSaddr),  
        .RTaddr_i(RTaddr),  
        .RDaddr_i(RDaddr),  
        .RDdata_i(RFinput), 
        .RegWrite_i (RegWrite & ~jr),
        .RSdata_o(RSdata),  
        .RTdata_o(RTdata)   
        );

ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(ALUOp),   
        .ALUCtrl_o(ALUCtrl) 
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(sign_extend)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RTdata),
        .data1_i(sign_extend),
        .select_i(ALUSrc),
        .data_o(ALUInput)
        );	
		
ALU ALU(
        .src1_i(RSdata),
	    .src2_i(ALUInput),
	    .ctrl_i(ALUCtrl),
	    .result_o(ALUResult),
		.zero_o(ALUZero)
	    );
		
// Hw4 new Data_Memory
Data_Memory Data_Memory(
	.clk_i(clk_i),
	.addr_i(ALUResult),
	.data_i(RTdata),
	.MemRead_i(MemRead),
	.MemWrite_i(MemWrite),
	.data_o(DMResult)
	);

MUX_4to1 #(.size(32)) MUX_DM_Retrun(
        .data0_i(ALUResult),
        .data1_i(DMResult),
        .data2_i(sign_extend),
        .data3_i(sum_pc_four),
        .select_i(MemToReg),
        .data_o(RFinput)
        );
	
// Branch PC add
Adder Adder2(
        .src1_i(sum_pc_four),     
	    .src2_i(shift_left_2),     
	    .sum_o(BranchAddr)      
	    );

Shift_Left_Two_26 Shifter26(
        .data_i(instr[25:0]),
        .pc_i(sum_pc_four[31:28]),
        .data_o(JumpAddr)
        );
		
Shift_Left_Two_32 Shifter32(
        .data_i(sign_extend),
        .data_o(shift_left_2)
        ); 		
		
assign pc_select = Branch & ALUZero;
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(sum_pc_four),
        .data1_i(BranchAddr),
        .select_i(pc_select),
        .data_o(NoJumpAddr)
        );	

MUX_2to1 #(.size(32)) Mux_PC_Jump(
        .data0_i(JumpAddr),
        .data1_i(NoJumpAddr),
        .select_i(Jump),
        .data_o(final_pc)
        );	

endmodule

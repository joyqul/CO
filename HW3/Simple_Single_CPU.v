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
wire    [32-1:0]    four;
wire    [32-1:0]    ALUResult;
wire    [32-1:0]    pc_in, final_pc, pc_out;
wire    [32-1:0]    sum_pc_four, sign_extend, ALUInput, BranchAddr, shift_left_2;
wire    [32-1:0]    instr;
wire    [32-1:0]    RSdata;
wire    [32-1:0]    RTdata;
wire    [3-1:0]     ALUOp;
wire    [5-1:0]     RDaddr;
wire    [4-1:0]     ALUCtrl;    
wire                ALUSrc, Branch, RegWrite, RegDst, ALUZero;

//Greate componentes
assign pc_in = (rst_i == 0)? 0: final_pc;
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
// PC = PC + 4
assign four = 4;
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(four),     
	    .sum_o(sum_pc_four)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr)    
	    );

// Write Reg
MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
        .select_i(RegDst),
        .data_o(RDaddr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(RDaddr) ,  
        .RDdata_i(ALUResult)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(RSdata) ,  
        .RTdata_o(RTdata)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(Branch)   
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
		
// Branch PC add
Adder Adder2(
        .src1_i(sum_pc_four),     
	    .src2_i(shift_left_2),     
	    .sum_o(BranchAddr)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(sign_extend),
        .data_o(shift_left_2)
        ); 		
		
assign pc_select = Branch & ALUZero;
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(sum_pc_four),
        .data1_i(BranchAddr),
        .select_i(pc_select),
        .data_o(final_pc)
        );	

endmodule

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
wire    [32-1:0]    ALUResult;
wire    [32-1:0]    pc_in, final_pc, pc_out;
wire    [32-1:0]    sum_pc_four, sign_extend, ALUInput, BranchAddr, shift_left_2;
wire    [32-1:0]    instr;

reg     [6-1:0]     instr_op, funct;
reg     [5-1:0]     rs, rt, rd;

//Greate componentes
always @(posedge clk_i) begin
    instr_op = instr[31:26];
    rs = instr[25:21];
    rt = instr[20:16];
    rd = instr[15:11];
    funct = instr[5:0];
end
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(sum_pc_four) ,   
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

// Write Reg
wire    [5-1:0] RDaddr;
MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(rt),
        .data1_i(rd),
        .select_i(Decoder.RegDst_o),
        .data_o(RDaddr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i),     
        .RSaddr_i(rs),  
        .RTaddr_i(rt),  
        .RDaddr_i(RDaddr),
        .RDdata_i(ALU.result_o), 
        .RegWrite_i (RegWrite),
        .RSdata_o(ALU.src1_i) ,  
        .RTdata_o(Mux_ALUSrc.data0_i)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(AC.ALUOp_i),   
	    .ALUSrc_o(Mux_ALUSrc.select_i),   
	    .RegDst_o(Mux_Write_Reg.select_i),   
		.Branch_o(Branch)   
	    );

ALU_Ctrl AC(
        .funct_i(funct),   
        .ALUOp_i(Decoder.ALU_op_o),   
        .ALUCtrl_o(ALU.ctrl_i) 
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(sign_extend)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RF.RTdata_o),
        .data1_i(sign_extend),
        .select_i(Decoder.ALUSrc_o),
        .data_o(ALU.src2_i)
        );	
		
ALU ALU(
        .src1_i(RF.RSdata_o),
	    .src2_i(Mux_ALUSrc.data_o),
	    .ctrl_i(AC.ALUCtrl_o),
	    .result_o(RF.RDdata_i),
		.zero_o(ALUZero)
	    );
		
// Branch PC add
Adder Adder2(
        .src1_i(sum_pc_four),     
	    .src2_i(Shifter.data_o),     
	    .sum_o(Mux_PC_Source.data1_i)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(sign_extend),
        .data_o(Adder2.src2_i)
        ); 		
		
assign pc_select = Branch & ALUZero;
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(Adder1.sum_o),
        .data1_i(Adder2.sum_o),
        .select_i(pc_select),
        .data_o(sum_pc_four)
        );	

endmodule

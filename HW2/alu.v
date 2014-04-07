`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
			  //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input  [32-1:0] src1;
input  [32-1:0] src2;
input  [4-1:0] ALU_control;
//input   [3-1:0] bonus_control; 

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero;
reg             cout;
reg             overflow;

reg             less, A_invert, B_invert, redundent;
reg    [2-1:0]  operation;
wire   [32-1:0] b_cin, b_cout, b_result;
wire            set;

assign b_cin = {b_cout[30:0], redundent};

always@( posedge clk or negedge rst_n ) begin
	if(!rst_n) begin
        result = 0;
        zero = 0;
        cout = 0;
        overflow = 0;
        less = 0;
        redundent = 0;
        A_invert = 0;
        B_invert = 0;
        operation = 0;
	end
	else begin
        result = b_result;
	end
end

always@(*) begin
    case (ALU_control)
        // AND
        4'b000: begin
            operation = 0;
            redundent = 0;
            A_invert = 0;
            B_invert = 0;
            overflow = 0;
        end
        // OR
        4'b0001: begin
            operation = 1;
            redundent = 0;
            A_invert = 0;
            B_invert = 0;
            overflow = 0;
        end
        // ADD
        4'b0010: begin
            operation = 2;
            redundent = 0;
            A_invert = 0;
            B_invert = 0;
            overflow = (src1[31] & src2[31] & ~result[31]) | (~src1[31] & ~src2[31] & result[31]);
        end
        // SUB
        4'b0110: begin
            operation = 2;
            redundent = 1;
            A_invert = 0;
            B_invert = 1;
            overflow = (~src1[31] & src2[31] & result[31]) | (src1[31] & ~src2[31] & ~result[31]);
        end
        // NOR
        4'b1100: begin
            operation = 1;
            redundent = 0;
            A_invert = 0;
            B_invert = 1;
            overflow = 0;
        end
        // SLT
        4'b0111: begin
            operation = 3;
            redundent = 1;
            A_invert = 0;
            B_invert = 0;
            overflow = ((~src1[31] & src2[31] & (~src1[31] ^ src2[31] ^ b_cout[30])) |
                    (src1[31] & ~src2[31] & ~(~src1[31] ^ src2[31] ^ b_cout[30])));
        end
        default: begin
            operation = 0;
            redundent = 0;
            A_invert = 0;
            B_invert = 0;
            overflow = 0;
        end
    endcase
end

assign set = overflow;

alu_top alu_top0(
               .src1(src1[0]),       //1 bit source 1 (input)
               .src2(src2[0]),       //1 bit source 2 (input)
               .less(set),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[0]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[0]),     //1 bit result   (output)
               .cout(b_cout[0])       //1 bit carry out(output)
               );

alu_top alu_top1(
               .src1(src1[1]),       //1 bit source 1 (input)
               .src2(src2[1]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[1]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[1]),     //1 bit result   (output)
               .cout(b_cout[1])       //1 bit carry out(output)
               );

alu_top alu_top2(
               .src1(src1[2]),       //1 bit source 1 (input)
               .src2(src2[2]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[2]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[2]),     //1 bit result   (output)
               .cout(b_cout[2])       //1 bit carry out(output)
               );

alu_top alu_top3(
               .src1(src1[3]),       //1 bit source 1 (input)
               .src2(src2[3]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[3]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[3]),     //1 bit result   (output)
               .cout(b_cout[3])       //1 bit carry out(output)
               );

alu_top alu_top4(
               .src1(src1[4]),       //1 bit source 1 (input)
               .src2(src2[4]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[4]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[4]),     //1 bit result   (output)
               .cout(b_cout[4])       //1 bit carry out(output)
               );

alu_top alu_top5(
               .src1(src1[5]),       //1 bit source 1 (input)
               .src2(src2[5]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[5]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[5]),     //1 bit result   (output)
               .cout(b_cout[5])       //1 bit carry out(output)
               );

alu_top alu_top6(
               .src1(src1[6]),       //1 bit source 1 (input)
               .src2(src2[6]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[6]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[6]),     //1 bit result   (output)
               .cout(b_cout[6])       //1 bit carry out(output)
               );

alu_top alu_top7(
               .src1(src1[7]),       //1 bit source 1 (input)
               .src2(src2[7]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[7]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[7]),     //1 bit result   (output)
               .cout(b_cout[7])       //1 bit carry out(output)
               );

alu_top alu_top8(
               .src1(src1[8]),       //1 bit source 1 (input)
               .src2(src2[8]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[8]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[8]),     //1 bit result   (output)
               .cout(b_cout[8])       //1 bit carry out(output)
               );

alu_top alu_top9(
               .src1(src1[9]),       //1 bit source 1 (input)
               .src2(src2[9]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[9]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[9]),     //1 bit result   (output)
               .cout(b_cout[9])      //1 bit carry out(output)
               );

alu_top alu_top10(
               .src1(src1[10]),       //1 bit source 1 (input)
               .src2(src2[10]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[10]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[10]),     //1 bit result   (output)
               .cout(b_cout[10])       //1 bit carry out(output)
               );

alu_top alu_top11(
               .src1(src1[11]),       //1 bit source 1 (input)
               .src2(src2[11]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[11]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[11]),     //1 bit result   (output)
               .cout(b_cout[11])       //1 bit carry out(output)
               );

alu_top alu_top12(
               .src1(src1[12]),       //1 bit source 1 (input)
               .src2(src2[12]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[12]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[12]),     //1 bit result   (output)
               .cout(b_cout[12])       //1 bit carry out(output)
               );

alu_top alu_top13(
               .src1(src1[13]),       //1 bit source 1 (input)
               .src2(src2[13]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[13]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[13]),     //1 bit result   (output)
               .cout(b_cout[13])       //1 bit carry out(output)
               );

alu_top alu_top14(
               .src1(src1[14]),       //1 bit source 1 (input)
               .src2(src2[14]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[14]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[14]),     //1 bit result   (output)
               .cout(b_cout[14])       //1 bit carry out(output)
               );

alu_top alu_top15(
               .src1(src1[15]),       //1 bit source 1 (input)
               .src2(src2[15]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[15]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[15]),     //1 bit result   (output)
               .cout(b_cout[15])       //1 bit carry out(output)
               );

alu_top alu_top16(
               .src1(src1[16]),       //1 bit source 1 (input)
               .src2(src2[16]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[16]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[16]),     //1 bit result   (output)
               .cout(b_cout[16])       //1 bit carry out(output)
               );

alu_top alu_top17(
               .src1(src1[17]),       //1 bit source 1 (input)
               .src2(src2[17]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[17]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[17]),     //1 bit result   (output)
               .cout(b_cout[17])       //1 bit carry out(output)
               );

alu_top alu_top18(
               .src1(src1[18]),       //1 bit source 1 (input)
               .src2(src2[18]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[18]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[18]),     //1 bit result   (output)
               .cout(b_cout[18])       //1 bit carry out(output)
               );

alu_top alu_top19(
               .src1(src1[19]),       //1 bit source 1 (input)
               .src2(src2[19]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[19]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[19]),     //1 bit result   (output)
               .cout(b_cout[19])       //1 bit carry out(output)
               );

alu_top alu_top20(
               .src1(src1[20]),       //1 bit source 1 (input)
               .src2(src2[20]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[20]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[20]),     //1 bit result   (output)
               .cout(b_cout[20])       //1 bit carry out(output)
               );

alu_top alu_top21(
               .src1(src1[21]),       //1 bit source 1 (input)
               .src2(src2[21]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[21]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[21]),     //1 bit result   (output)
               .cout(b_cout[21])       //1 bit carry out(output)
               );

alu_top alu_top22(
               .src1(src1[22]),       //1 bit source 1 (input)
               .src2(src2[22]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[22]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[22]),     //1 bit result   (output)
               .cout(b_cout[22])       //1 bit carry out(output)
               );

alu_top alu_top23(
               .src1(src1[23]),       //1 bit source 1 (input)
               .src2(src2[23]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[23]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[23]),     //1 bit result   (output)
               .cout(b_cout[23])       //1 bit carry out(output)
               );

alu_top alu_top24(
               .src1(src1[24]),       //1 bit source 1 (input)
               .src2(src2[24]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[24]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[24]),     //1 bit result   (output)
               .cout(b_cout[24])       //1 bit carry out(output)
               );

alu_top alu_top25(
               .src1(src1[25]),       //1 bit source 1 (input)
               .src2(src2[25]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[25]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[25]),     //1 bit result   (output)
               .cout(b_cout[25])       //1 bit carry out(output)
               );

alu_top alu_top26(
               .src1(src1[26]),       //1 bit source 1 (input)
               .src2(src2[26]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[26]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[26]),     //1 bit result   (output)
               .cout(b_cout[26])       //1 bit carry out(output)
               );

alu_top alu_top27(
               .src1(src1[27]),       //1 bit source 1 (input)
               .src2(src2[27]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[27]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[27]),     //1 bit result   (output)
               .cout(b_cout[27])       //1 bit carry out(output)
               );

alu_top alu_top28(
               .src1(src1[28]),       //1 bit source 1 (input)
               .src2(src2[28]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[28]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[28]),     //1 bit result   (output)
               .cout(b_cout[28])       //1 bit carry out(output)
               );

alu_top alu_top29(
               .src1(src1[29]),       //1 bit source 1 (input)
               .src2(src2[29]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[29]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[29]),     //1 bit result   (output)
               .cout(b_cout[29])       //1 bit carry out(output)
               );

alu_top alu_top30(
               .src1(src1[30]),       //1 bit source 1 (input)
               .src2(src2[30]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[30]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[30]),     //1 bit result   (output)
               .cout(b_cout[30])       //1 bit carry out(output)
               );

alu_top alu_top31(
               .src1(src1[31]),       //1 bit source 1 (input)
               .src2(src2[31]),       //1 bit source 2 (input)
               .less(less),       //1 bit less     (input)
               .A_invert(A_invert),   //1 bit A_invert (input)
               .B_invert(B_invert),   //1 bit B_invert (input)
               .cin(b_cin[31]),        //1 bit carry in (input)
               .operation(operation),  //operation      (input)
               .result(b_result[31]),     //1 bit result   (output)
               .cout(b_cout[31])       //1 bit carry out(output)
               );

endmodule

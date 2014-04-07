`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
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

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output reg    result;
output reg    cout;

always@(*)
begin
    case (operation)
        // AND
        2'b00: begin
            if (A_invert & B_invert) result = ~src1 & ~src2;
            else if (A_invert & ~B_invert) result = ~src1 & src2;
            else if (~A_invert & B_invert) result = src1 & ~src2;
            else result = src1 & src2;
            cout = 0;
        end
        // OR
        2'b01: begin
            if (A_invert & B_invert) result = ~src1 | ~src2;
            else if (A_invert & ~B_invert) result = ~src1 | src2;
            else if (~A_invert & B_invert) result = src1 | ~src2;
            else result = src1 | src2;
            cout = 0;
        end
        // ADD
        2'b10: begin
            if (A_invert & B_invert) begin
                result = ~src1 ^ ~src2 ^ cin;
                cout = (~src1 & ~src2) | ((~src1 | ~src2) & cin);
            end 
            else if (A_invert & ~B_invert) begin
                result = ~src1 ^ src2 ^ cin;
                cout = (~src1 & src2) | ((~src1 | src2) & cin);
            end
            else if (~A_invert & B_invert) begin
                result = src1 ^ ~src2 ^ cin;
                cout = (src1 & ~src2) | ((src1 | ~src2) & cin);
            end
            else begin
                result = src1 ^ src2 ^ cin;
                cout = (src1 & src2) | ((src1 | src2) & cin);
            end
        end
        // SLT
        4'b11: begin
            cout = (~src1 & src2) | ((~src1 | src2) & cin);
            result = less;
        end
        default: begin
            result = result;
            cout = cout;
        end
    endcase
end

endmodule

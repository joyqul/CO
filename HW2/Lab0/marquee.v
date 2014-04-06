`timescale 1ns/10ps
module marquee(
  clk,
  rst,
  indataA,
  indataB,
  outdata
  );

input clk;
input rst;  
input  [2:0] indataA;
input  [2:0] indataB;

output reg [5:0] outdata;


reg [1:0] counter_r;


// To do:
// Please fulfill the code to make your output waveform the same as our specification

// To do:
// Please add sequential code here:
always@(posedge clk)begin
    if(rst)begin
        counter_r = 0;
        outdata = 0;
    end
    else begin
        case (counter_r)
            0: outdata = indataA | indataB;
            1: outdata = indataA & indataB;
            2: outdata = indataA ^ indataB;
            3: outdata = {indataA, indataB};
            default: outdata = outdata;
        endcase
        if (counter_r == 3) counter_r = 0;
        else counter_r = counter_r + 1;
    end
end

endmodule

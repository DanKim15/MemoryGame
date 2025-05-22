`timescale 1ns/1ps

module Lfsr22TB;

  reg r_clk;
  wire [21:0] w_data;
  
  Lfsr22 dut(
    .i_clk(r_clk),
    .o_data(w_data));

  initial begin
    r_clk = 0;
    forever #5 r_clk = ~r_clk;
  end

  initial 
  begin
    force dut.o_data = 22'h000001;
    #1;
    release dut.o_data;

    repeat (16) @(posedge r_clk);

  end

endmodule

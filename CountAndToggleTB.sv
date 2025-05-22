`timescale 1ns/1ps

module CountAndToggleTB;

  reg r_clk, r_en;
  wire w_toggle;
  
  CountAndToggle #(.COUNT_LIMIT(5)) dut(
    .i_clk(r_clk),
    .i_en(r_en),
	 .o_toggle(w_toggle));

  initial begin
    dut.o_toggle = 0;
    dut.r_count  = 0;
	 r_en <= 1'b1;
  end
  initial begin
    r_clk = 0;
    forever #5 r_clk = ~r_clk;
  end

  initial 
  begin
    repeat (16) @(posedge r_clk);
  
  end

endmodule
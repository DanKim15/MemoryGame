`timescale 1ns/1ps

module StateMachineTB();
	localparam CLK_PER_SEC = 6;
  localparam GAME_LIMIT = 3;
	reg r_clk = 1'b0;
	reg [4:0] r_sw;
	wire [3:0] w_led;
	wire [3:0] w_score;
	

	
	StateMachineGame #(.CLK_PER_SEC(CLK_PER_SEC), .GAME_LIMIT(GAME_LIMIT)) game_inst(
		.i_clk(r_clk),
		.i_sw(r_sw),
		.o_led(w_led),
		.o_score(w_score));
	
	task set_sw;
		input i_0, i_1, i_2, i_3, i_4;
		begin
			@(posedge r_clk);
			r_sw[0] <= i_0;
			r_sw[1] <= i_1;
			r_sw[2] <= i_2;
			r_sw[3] <= i_3;
			r_sw[4] <= i_4;
			@(posedge r_clk);
			r_sw[0] <= 0'b0;
			r_sw[1] <= 0'b0;
			r_sw[2] <= 0'b0;
			r_sw[3] <= 0'b0;
			r_sw[4] <= 0'b0;
			@(posedge r_clk);
		end
	endtask
	initial
	begin
		r_clk = 0;
		forever #5 r_clk = ~r_clk;
	end
	
	initial
	begin
		
		set_sw(0, 0, 0, 0, 0);
		repeat(CLK_PER_SEC) @(posedge r_clk);
		
		set_sw(0, 0, 0, 0, 1);
		repeat(3*CLK_PER_SEC) @(posedge r_clk);
		
		set_sw(0, 0, 0, 1, 0);
		repeat(3*CLK_PER_SEC) @(posedge r_clk);
		
		set_sw(0, 0, 1, 0, 0);
		repeat(3*CLK_PER_SEC) @(posedge r_clk);
		
		set_sw(0, 0, 0, 0, 1);
		repeat(3*CLK_PER_SEC) @(posedge r_clk);
		
		set_sw(0, 1, 0, 0, 0);
		repeat(3*CLK_PER_SEC) @(posedge r_clk);
		
		set_sw(0, 0, 0, 0, 1);
		repeat(3*CLK_PER_SEC) @(posedge r_clk);
		
		set_sw(0, 0, 0, 0, 0);
		repeat(3*CLK_PER_SEC) @(posedge r_clk);
		
		set_sw(0, 0, 0, 0, 0);
		repeat(3*CLK_PER_SEC) @(posedge r_clk);
		
		set_sw(0, 0, 0, 0, 0);
		repeat(3*CLK_PER_SEC) @(posedge r_clk);
		
	end
endmodule
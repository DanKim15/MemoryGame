module MemoryGameTopLvl(
	input i_clk,
	input [4:0] i_sw,
	output [3:0] o_led,
	output [6:0] o_sevseg);
	localparam GAME_LIMIT = 7;
	localparam CLK_PER_SEC = 50000000;
	localparam DEBOUNCE_LIMIT = 5000000;
	wire [4:0] w_sw;
	wire [6:0] w_sevseg;
	wire [3:0] w_score;
	
	DebounceFilter #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)) debounce_sw0(
		.i_clk(i_clk),
		.i_bouncy(i_sw[0]),
		.o_debounced(w_sw[0]));
		
	DebounceFilter #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)) debounce_sw1(
		.i_clk(i_clk),
		.i_bouncy(i_sw[1]),
		.o_debounced(w_sw[1]));
		
	DebounceFilter #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)) debounce_sw2(
		.i_clk(i_clk),
		.i_bouncy(i_sw[2]),
		.o_debounced(w_sw[2]));
		
	DebounceFilter #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)) debounce_sw3(
		.i_clk(i_clk),
		.i_bouncy(i_sw[3]),
		.o_debounced(w_sw[3]));
		
	DebounceFilter #(.DEBOUNCE_LIMIT(DEBOUNCE_LIMIT)) debounce_sw4(
		.i_clk(i_clk),
		.i_bouncy(i_sw[4]),
		.o_debounced(w_sw[4]));
		
	StateMachineGame #(.CLK_PER_SEC(CLK_PER_SEC), .GAME_LIMIT(GAME_LIMIT)) state_machine_inst(
		.i_clk(i_clk),
		.i_sw(w_sw),
		.o_led(o_led),
		.o_score(w_score));
	
	BinaryToSevSeg sevseg_inst(
		.i_clk(i_clk),
		.i_bin_num(w_score),
		.o_sevseg(w_sevseg));
		
	assign o_sevseg[0] = w_sevseg[0];
	assign o_sevseg[1] = w_sevseg[1];
	assign o_sevseg[2] = w_sevseg[2];
	assign o_sevseg[3] = w_sevseg[3];
	assign o_sevseg[4] = w_sevseg[4];
	assign o_sevseg[5] = w_sevseg[5];
	assign o_sevseg[6] = w_sevseg[6];
		
		
endmodule
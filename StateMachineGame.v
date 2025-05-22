module StateMachineGame #(parameter CLK_PER_SEC = 50000000, parameter GAME_LIMIT = 7)(
	input i_clk,
	input [4:0] i_sw,
	output [3:0] o_led,
	output reg [3:0] o_score);
	
	localparam START = 3'd0;
	localparam PATTERN_OFF = 3'd1;
	localparam SHOW_STEP = 3'd2;
	localparam WAIT_PLAYER = 3'd3;
	localparam LOSE = 3'd4;
	localparam WIN = 3'd5;
	
	reg [2:0] r_state;
	reg r_toggle, r_dv;
	reg [4:0] r_sw;
	reg [1:0] r_pattern [10:0];
	wire [21:0] w_lfsr;
	reg [$clog2(GAME_LIMIT):0] r_step_index;
	reg [1:0] r_sw_id;
	wire w_count_en, w_toggle;
	
	always @(posedge i_clk, posedge i_sw[4])
	begin
		if (i_sw[4])
			r_state <= START;
		else
		begin
			case (r_state)

			START:
			begin
				r_state <= PATTERN_OFF;
				o_score <= 0;
				r_step_index <= 0;
			end
			
			PATTERN_OFF:
			begin
				if (r_toggle & !w_toggle)
					r_state <= SHOW_STEP;
			end
			
			SHOW_STEP:
			begin
				if (r_toggle & !w_toggle)
				begin
					if (o_score == r_step_index)
					begin
						r_state <= WAIT_PLAYER;
						r_step_index <= 0;
					end
					else
					begin
						r_step_index <= r_step_index  + 1;
						r_state <= PATTERN_OFF;
					end
				end
			end
			
			WAIT_PLAYER:
			begin
				if (r_dv)
				begin
					if (r_sw_id != r_pattern[r_step_index])
						r_state <= LOSE;
					else if (o_score == r_step_index)
					begin
						r_state <= PATTERN_OFF;
						if (o_score == GAME_LIMIT)
							r_state <= WIN;
						else
						begin
							o_score <= o_score + 1;
							r_step_index <= 0;
						end
					end
					else
						r_step_index = r_step_index + 1;
				end
			end
			
			LOSE:
				o_score <= 4'hF;
			
			WIN:
				o_score <= 4'hA;
			
			default:
				r_state <= START;
			endcase
		end
	end
	
	integer i;
	always @(posedge i_clk)
	begin
		if (r_state == START)
		begin
		for (i = 0; i < 2 * GAME_LIMIT; i = i + 2)
			r_pattern[i / 2] <= {w_lfsr[i], w_lfsr[i + 1]};
		end
	end
	
	always @(posedge i_clk)
	begin
		r_toggle <= w_toggle;
		r_sw[0] <= i_sw[0];
		r_sw[1] <= i_sw[1];
		r_sw[2] <= i_sw[2];
		r_sw[3] <= i_sw[3];
		r_sw[4] <= i_sw[4];
		if (!i_sw[0] & r_sw[0])
		begin
			r_dv <= 1'b1;
			r_sw_id <= 2'b00;
		end
		
		else if (!i_sw[1] & r_sw[1])
		begin
			r_dv <= 1'b1;
			r_sw_id <= 2'b01;
		end
		
		else if (!i_sw[2] & r_sw[2])
		begin
			r_dv <= 1'b1;
			r_sw_id <= 2'b10;
		end
		
		else if (!i_sw[3] & r_sw[3])
		begin
			r_dv <= 1'b1;
			r_sw_id <= 2'b11;
		end
		else
			r_dv <= 1'b0;

	end
	
	assign w_count_en = (r_state == PATTERN_OFF || r_state == SHOW_STEP );
	CountAndToggle #(.COUNT_LIMIT(CLK_PER_SEC/4)) cat_inst(
		.i_clk(i_clk),
		.i_en(w_count_en),
		.o_toggle(w_toggle));
	
	Lfsr22 lfsr_inst(
		.i_clk(i_clk),
		.o_data(w_lfsr));
		
	assign o_led[0] = (SHOW_STEP == r_state && r_pattern[r_step_index] == 2'b00) ? 1'b1 : i_sw[0];
	assign o_led[1] = (SHOW_STEP == r_state && r_pattern[r_step_index] == 2'b01) ? 1'b1 : i_sw[1];
	assign o_led[2] = (SHOW_STEP == r_state && r_pattern[r_step_index] == 2'b10) ? 1'b1 : i_sw[2];
	assign o_led[3] = (SHOW_STEP == r_state && r_pattern[r_step_index] == 2'b11) ? 1'b1 : i_sw[3]; 	
	
	
	
endmodule
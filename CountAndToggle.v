module CountAndToggle #(COUNT_LIMIT = 1000000)(
	input i_clk,
	input i_en,
	output reg o_toggle);
	
	reg [$clog2(COUNT_LIMIT):0] r_count;
	
	always @(posedge i_clk)
	begin
		if (i_en)
		begin
			if (r_count < COUNT_LIMIT)
				r_count <= r_count + 1;
			else
				begin
					o_toggle <= ~o_toggle;
					r_count <= 0;
				end
		end
		else
			r_count <= 0;
	end
endmodule
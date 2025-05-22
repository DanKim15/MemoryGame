module Lfsr22(
	input i_clk,
	output reg [21:0] o_data);
	
	wire w_xnor;
	always @(posedge i_clk)
		o_data <= {o_data[20:0], w_xnor};
	
	assign w_xnor = o_data[21] ^~ o_data[20];
endmodule
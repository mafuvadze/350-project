module register_64 (data, enable, reset, clk, out);
	input [63:0] data;
	input reset, clk, enable;
	
	output [63:0] out;
				
	genvar i;
	generate
		for (i = 0; i < 64; i = i + 1) begin : set_data
			dflipflop dffe (data[i], clk, ~reset, 1'b1, enable, out[i]);
		end
	endgenerate
endmodule

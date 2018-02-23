module register (data, enable, reset, clk, out);
	input [31:0] data;
	input reset, clk, enable;
	
	output [31:0] out;
				
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin : set_data
			dflipflop dffe (data[i], clk, ~reset, 1'b1, enable, out[i]);
		end
	endgenerate
endmodule

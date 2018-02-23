module shl_register(enable, clk, out);
	input clk, enable;
	
	output [31:0] out;
	
	wire last;
	
	comp_32 comp (last, _ , 1'b1, out, 32'b11111111111111111111111111111111);
	
			
	dflipflop dffe (1'b1, clk, 1'b1, 1'b1, 1'b1, out[0]);
	
	
	genvar i;
	generate
		for (i = 1; i < 32; i = i + 1)
		begin : set_data
			dflipflop dffe (last ? 1'b0 : out[i-1], clk, ~enable, 1'b1, 1'b1, out[i]);
		end
	endgenerate
endmodule

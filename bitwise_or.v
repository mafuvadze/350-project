module bitwise_or(out, in_1, in_0);
	// Inputs
	input [31:0] in_0, in_1;
	
	// Outputs
	output [31:0] out;
	
	// Code
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1)
		begin : set_data
			or or_a(out[i], in_0[i], in_1[i]);
		end
	endgenerate
endmodule

module sl1(out, in, enable);
	// Inputs
	input [31:0] in;
	input enable;
	
	// Outputs
	output [31:0] out;
	
	// Code	
	genvar i;
	generate
		for (i = 1; i < 32; i = i + 1)
		begin : set_data
			assign out[i] = enable ? in[i-1] : in[i];
		end
	endgenerate
	
	assign out[0] = enable ? 1'b0 : in[0];

endmodule

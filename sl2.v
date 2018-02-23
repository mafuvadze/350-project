module sl2(out, in, enable);
	// Inputs
	input [31:0] in;
	input enable;
	
	// Outputs
	output [31:0] out;
	
	// Code
	genvar i;
	generate
		for (i = 2; i < 32; i = i + 1)
		begin : set_data
			assign out[i] = enable ? in[i-2] : in[i];
		end
	endgenerate
	
	assign out[0] = enable ? 1'b0 : in[0];
	assign out[1] = enable ? 1'b0 : in[1];
	
endmodule

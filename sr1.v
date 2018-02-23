module sr1(out, in, enable);
	// Inputs
	input [31:0] in;
	input enable;
	
	// Outputs
	output [31:0] out;
	
	// Code
	assign out[31] = in[31];
	
	genvar i;
	generate
		for (i = 0; i < 31; i = i + 1)
		begin : set_data
			assign out[i] = enable ? in[i+1] : in[i];
		end
	endgenerate
endmodule

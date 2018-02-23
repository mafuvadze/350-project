module sr4(out, in, enable);
	// Inputs
	input [31:0] in;
	input enable;
	
	// Outputs
	output [31:0] out;
	
	// Code
	assign out[31] = in[31];
	assign out[30] = enable ? in[31] : in[30];
	assign out[29] = enable ? in[31] : in[29];
	assign out[28] = enable ? in[31] : in[28];
	
	
	genvar i;
	generate
		for (i = 0; i < 28; i = i + 1)
		begin : set_data
			assign out[i] = enable ? in[i+4] : in[i];
		end
	endgenerate
endmodule

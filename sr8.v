module sr8(out, in, enable);
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
	assign out[27] = enable ? in[31] : in[27];
	assign out[26] = enable ? in[31] : in[26];
	assign out[25] = enable ? in[31] : in[25];
	assign out[24] = enable ? in[31] : in[24];
	
	genvar i;
	generate
		for (i = 0; i < 24; i = i + 1)
		begin : set_data
			assign out[i] = enable ? in[i+8] : in[i];
		end
	endgenerate
endmodule

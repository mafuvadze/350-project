module sr16(out, in, enable);
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
	assign out[23] = enable ? in[31] : in[23];
	assign out[22] = enable ? in[31] : in[22];
	assign out[21] = enable ? in[31] : in[21];
	assign out[20] = enable ? in[31] : in[20];
	assign out[19] = enable ? in[31] : in[19];
	assign out[18] = enable ? in[31] : in[18];
	assign out[17] = enable ? in[31] : in[17];
	assign out[16] = enable ? in[31] : in[16];
	
	genvar i;
	generate
		for (i = 0; i < 16; i = i + 1)
		begin : set_data
			assign out[i] = enable ? in[i+16] : in[i];
		end
	endgenerate
endmodule

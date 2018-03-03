module sl4(out, in, enable);
	// Inputs
	input [31:0] in;
	input enable;
	
	// Outputs
	output [31:0] out;
	
	// Code
	genvar i;
	generate
		for (i = 4; i < 32; i = i + 1)
		begin : set_data
			assign out[i] = enable ? in[i-4] : in[i];
		end
	endgenerate
	
	assign out[0] = enable ? 1'b0 : in[0];
	assign out[1] = enable ? 1'b0 : in[1];
	assign out[2] = enable ? 1'b0 : in[2];
	assign out[3] = enable ? 1'b0 : in[3];
	
endmodule
module sl8(out, in, enable);
	// Inputs
	input [31:0] in;
	input enable;
	
	// Outputs
	output [31:0] out;
	
	// Code
	genvar i;
	generate
		for (i = 8; i < 32; i = i + 1)
		begin : set_data
			assign out[i] = enable ? in[i-8] : in[i];
		end
	endgenerate
	
	assign out[0] = enable ? 1'b0 : in[0];
	assign out[1] = enable ? 1'b0 : in[1];
	assign out[2] = enable ? 1'b0 : in[2];
	assign out[3] = enable ? 1'b0 : in[3];
	assign out[4] = enable ? 1'b0 : in[4];
	assign out[5] = enable ? 1'b0 : in[5];
	assign out[6] = enable ? 1'b0 : in[6];
	assign out[7] = enable ? 1'b0 : in[7];
	
endmodule

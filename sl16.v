module sl16(out, in, enable);
	// Inputs
	input [31:0] in;
	input enable;
	
	// Outputs
	output [31:0] out;
	
	// Code
	genvar i;
	generate
		for (i = 16; i < 32; i = i + 1)
		begin : set_data
			assign out[i] = enable ? in[i-16] : in[i];
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
	assign out[8] = enable ? 1'b0 : in[8];
	assign out[9] = enable ? 1'b0 : in[9];
	assign out[10] = enable ? 1'b0 : in[10];
	assign out[11] = enable ? 1'b0 : in[11];
	assign out[12] = enable ? 1'b0 : in[12];
	assign out[13] = enable ? 1'b0 : in[13];
	assign out[14] = enable ? 1'b0 : in[14];
	assign out[15] = enable ? 1'b0 : in[15];

		
endmodule

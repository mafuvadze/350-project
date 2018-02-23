module sra_64(out, in);			// Shifts the input by 1 bit, keeps sign
	input [63:0] in;
	output [63:0] out;
		
	assign out[63] = in[63];
	
	genvar i;
	generate
		for (i = 0; i < 63; i = i + 1) begin : shift
			assign out[i] = in[i+1];
		end
	endgenerate
endmodule

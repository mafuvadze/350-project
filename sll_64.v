module sll_64(out, in);
	input [63:0] in;
	output [63:0] out;
			
	genvar i;
	generate
		for (i = 63; i > 0; i = i - 1) begin : shift
			assign out[i] = in[i-1];
		end
	endgenerate
	
	assign out[0] = 1'b0;

endmodule

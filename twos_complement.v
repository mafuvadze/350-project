module twos_complement (out, in);
	input [31:0]  in;
	output [31:0] out;
	
	wire [31:0] inverted;
	
	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin : invert
			assign inverted[i] = ~in[i];
		end
	endgenerate
	
	cla_32 adder (out, overflow, 32'b1, inverted, 1'b0);
	
endmodule

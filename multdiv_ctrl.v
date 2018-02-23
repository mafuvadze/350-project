module multdiv_ctrl(out, a, b);
	input a, b;
	output out;
		
	xor xor1 (out, a, b);
		
endmodule

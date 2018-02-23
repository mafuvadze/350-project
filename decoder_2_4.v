module decoder_2_4(out_0, out_1, out_2, out_3, in_0, in_1);
	// Input
	input in_0, in_1;
	
	// Output
	output out_0, out_1, out_2, out_3;
	
	// wires
	wire not_0, not_1;
	
	//Code
	not n_a(not_0, in_0);
	not n_b(not_1, in_1);
	
	and and_a(out_0, not_0, not_1);
	and and_b(out_1, in_0, not_1);
	and and_c(out_2, not_0, in_1);
	and and_d(out_3, in_0, in_1);
endmodule

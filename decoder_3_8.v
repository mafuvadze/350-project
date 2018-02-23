module decoder_3_8(out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7, in_0, in_1, in_2, enable);
	// Input
	input in_0, in_1, in_2, enable;
	
	// Output
	output out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7;
	
	// wires
	wire not_0, not_1, not_2;
	
	//Code
	not n_a(not_0, in_0);
	not n_b(not_1, in_1);
	not n_c(not_2, in_2);
	
	and and_a(out_0, not_0, not_1, not_2, enable);
	and and_b(out_1, in_0, not_1, not_2, enable);
	and and_c(out_2, not_0, in_1, not_2, enable);
	and and_d(out_3, in_0, in_1, not_2, enable);
	and and_e(out_4, not_0, not_1, in_2, enable);
	and and_f(out_5, in_0, not_1, in_2, enable);
	and and_g(out_6, not_0, in_1, in_2, enable);
	and and_h(out_7, in_0, in_1, in_2, enable);
endmodule

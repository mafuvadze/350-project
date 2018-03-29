module decoder_2_4(
	out0,
	out1,
	out2,
	out3,
	in0,
	in1
);

	input 	in0, in1;
	
	output 	out0, out1, out2, out3;
		
	and and_a(out0, ~in0, ~in1);
	and and_b(out1, in0, ~in1);
	and and_c(out2, ~in0, in1);
	and and_d(out3, in0, in1);
	
endmodule

module decoder_3_8(
	out0, out1, out2, out3, out4, out5, out6, out7,
	in0, in1, in2,
	enable
);

	input 	in0, in1, in2,
				enable;
	
	output 	out0, out1, out2, out3, out4, out5, out6, out7;
	
	and and_a(out0, ~in0, ~in1, ~in2, enable);
	and and_b(out1, in0, ~in1, ~in2, enable);
	and and_c(out2, ~in0, in1, ~in2, enable);
	and and_d(out3, in0, in1, ~in2, enable);
	and and_e(out4, ~in0, ~in1, in2, enable);
	and and_f(out5, in0, ~in1, in2, enable);
	and and_g(out6, ~in0, in1, in2, enable);
	and and_h(out7, in0, in1, in2, enable);
	
endmodule

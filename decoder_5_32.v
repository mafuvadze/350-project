module decoder_5_32(
	out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16, out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27, out28, out29, out30, out31, 
	in0, in1, in2, in3, in4
);

	input 		in0, in1, in2, in3, in4;
	
	output 		out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10, out11, out12, out13, out14, out15, out16, out17, out18, out19, out20, out21, out22, out23, out24, out25, out26, out27, out28, out29, out30, out31;
	
	wire [3:0]	enable;
	
	decoder_2_4 dec_2 (enable[0], enable[1], enable[2], enable[3], in3, .in4);
	
	decoder_3_8 dec_3_a (out0, out1, out2, out3, out4, out5, out6, out7, in0, in1, in2, enable[0]);
	decoder_3_8 dec_3_b (out8, out9, out10, out11, out12, out13, out14, out15, in0, in1, in2, enable[1]);
	decoder_3_8 dec_3_c (out16, out17, out18, out19, out20, out21, out22, out23, in0, in1, in2, enable[2]);
	decoder_3_8 dec_3_d (out24, out25, out26, out27, out28, out29, out30, out31, in0, in1, in2, enable[3]);
	
endmodule

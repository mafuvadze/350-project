module decoder_5_32(out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7, out_8, out_9, out_10, out_11, out_12, out_13, out_14, out_15, out_16, out_17, out_18, out_19, out_20, out_21, out_22, out_23, out_24, out_25, out_26, out_27, out_28, out_29, out_30, out_31, in_0, in_1, in_2, in_3, in_4);
	// Input
	input in_0, in_1, in_2, in_3, in_4;
	
	// Output
	output out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7, out_8, out_9, out_10, out_11, out_12, out_13, out_14, out_15, out_16, out_17, out_18, out_19, out_20, out_21, out_22, out_23, out_24, out_25, out_26, out_27, out_28, out_29, out_30, out_31;
	
	// wires
	wire a_0, a_1, a_2, a_3;
	
	//Code
	decoder_2_4 dec_2_a(.out_0(a_0), .out_1(a_1), .out_2(a_2), .out_3(a_3), .in_0(in_3), .in_1(in_4));
	
	decoder_3_8 dec_3_a(.out_0(out_0), .out_1(out_1), .out_2(out_2), .out_3(out_3), .out_4(out_4), .out_5(out_5), .out_6(out_6), .out_7(out_7), .in_0(in_0), .in_1(in_1), .in_2(in_2), .enable(a_0));
	decoder_3_8 dec_3_b(.out_0(out_8), .out_1(out_9), .out_2(out_10), .out_3(out_11), .out_4(out_12), .out_5(out_13), .out_6(out_14), .out_7(out_15), .in_0(in_0), .in_1(in_1), .in_2(in_2), .enable(a_1));
	decoder_3_8 dec_3_c(.out_0(out_16), .out_1(out_17), .out_2(out_18), .out_3(out_19), .out_4(out_20), .out_5(out_21), .out_6(out_22), .out_7(out_23), .in_0(in_0), .in_1(in_1), .in_2(in_2), .enable(a_2));
	decoder_3_8 dec_3_d(.out_0(out_24), .out_1(out_25), .out_2(out_26), .out_3(out_27), .out_4(out_28), .out_5(out_29), .out_6(out_30), .out_7(out_31), .in_0(in_0), .in_1(in_1), .in_2(in_2), .enable(a_3));
endmodule

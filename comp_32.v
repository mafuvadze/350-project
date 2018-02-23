module comp_32(eq, gt, enable, in_0, in_1);
	// Input
	input enable;
	input [31:0] in_0, in_1;
	
	// Output
	output eq, gt;
	
	// Wire
	wire [31:0] ain_0, ain_1;
	wire gt_1, gt_2, gt_3, gt_4, gt_5, gt_6, gt_7, gt_8, gt_9, gt_10, gt_11, gt_12, gt_13, gt_14, gt_15, gt_16;
	wire eq_1, eq_2, eq_3, eq_4, eq_5, eq_6, eq_7, eq_8, eq_9, eq_10, eq_11, eq_12, eq_13, eq_14, eq_15, eq_16;
	wire inv_gt, a_not, b_not, gt_p, eq_p, eq_and1, eq_and2;
	
	// Code
	assign ain_0 = enable ? in_0 : 32'bZ;
	assign ain_1 = enable ? in_1 : 32'bZ;
	
	not not_1(a_not, in_0[31]);
	not not_2(b_not, in_1[31]);
	and and_1(gt_p, in_1[31], a_not);
	and and_2(eq_and1, in_0[31], in_1[31]);
	and and_3(eq_and2, a_not, b_not);
	or or_1(eq_p, eq_and1, eq_and2);
	
	comp_2 comp_a(.eq_prev(eq_p), .gt_prev(gt_p), .a_0(ain_0[30]), .a_1(1'b0), .b_0(ain_1[30]), .b_1(1'b0), .eq(eq_1), .gt(gt_1));
	comp_2 comp_b(.eq_prev(eq_1), .gt_prev(gt_1), .a_0(ain_0[28]), .a_1(ain_0[29]), .b_0(ain_1[28]), .b_1(ain_1[29]), .eq(eq_2), .gt(gt_2));
	comp_2 comp_c(.eq_prev(eq_2), .gt_prev(gt_2), .a_0(ain_0[26]), .a_1(ain_0[27]), .b_0(ain_1[26]), .b_1(ain_1[27]), .eq(eq_3), .gt(gt_3));
	comp_2 comp_d(.eq_prev(eq_3), .gt_prev(gt_3), .a_0(ain_0[24]), .a_1(ain_0[25]), .b_0(ain_1[24]), .b_1(ain_1[25]), .eq(eq_4), .gt(gt_4));
	comp_2 comp_e(.eq_prev(eq_4), .gt_prev(gt_4), .a_0(ain_0[22]), .a_1(ain_0[23]), .b_0(ain_1[22]), .b_1(ain_1[23]), .eq(eq_5), .gt(gt_5));
	comp_2 comp_f(.eq_prev(eq_5), .gt_prev(gt_5), .a_0(ain_0[20]), .a_1(ain_0[21]), .b_0(ain_1[20]), .b_1(ain_1[21]), .eq(eq_6), .gt(gt_6));
	comp_2 comp_g(.eq_prev(eq_6), .gt_prev(gt_6), .a_0(ain_0[18]), .a_1(ain_0[19]), .b_0(ain_1[18]), .b_1(ain_1[19]), .eq(eq_7), .gt(gt_7));
	comp_2 comp_h(.eq_prev(eq_7), .gt_prev(gt_7), .a_0(ain_0[16]), .a_1(ain_0[17]), .b_0(ain_1[16]), .b_1(ain_1[17]), .eq(eq_8), .gt(gt_8));
	comp_2 comp_i(.eq_prev(eq_8), .gt_prev(gt_8), .a_0(ain_0[14]), .a_1(ain_0[15]), .b_0(ain_1[14]), .b_1(ain_1[15]), .eq(eq_9), .gt(gt_9));
	comp_2 comp_j(.eq_prev(eq_9), .gt_prev(gt_9), .a_0(ain_0[12]), .a_1(ain_0[13]), .b_0(ain_1[12]), .b_1(ain_1[13]), .eq(eq_10), .gt(gt_10));
	comp_2 comp_k(.eq_prev(eq_10), .gt_prev(gt_10), .a_0(ain_0[10]), .a_1(ain_0[11]), .b_0(ain_1[10]), .b_1(ain_1[11]), .eq(eq_11), .gt(gt_11));
	comp_2 comp_l(.eq_prev(eq_11), .gt_prev(gt_11), .a_0(ain_0[8]), .a_1(ain_0[9]), .b_0(ain_1[8]), .b_1(ain_1[9]), .eq(eq_12), .gt(gt_12));
	comp_2 comp_m(.eq_prev(eq_12), .gt_prev(gt_12), .a_0(ain_0[6]), .a_1(ain_0[7]), .b_0(ain_1[6]), .b_1(ain_1[7]), .eq(eq_13), .gt(gt_13));
	comp_2 comp_n(.eq_prev(eq_13), .gt_prev(gt_13), .a_0(ain_0[4]), .a_1(ain_0[5]), .b_0(ain_1[4]), .b_1(ain_1[5]), .eq(eq_14), .gt(gt_14));
	comp_2 comp_o(.eq_prev(eq_14), .gt_prev(gt_14), .a_0(ain_0[2]), .a_1(ain_0[3]), .b_0(ain_1[2]), .b_1(ain_1[3]), .eq(eq_15), .gt(gt_15));
	comp_2 comp_p(.eq_prev(eq_15), .gt_prev(gt_15), .a_0(ain_0[0]), .a_1(ain_0[1]), .b_0(ain_1[0]), .b_1(ain_1[1]), .eq(eq_16), .gt(gt_16));
	
	assign gt = gt_16;
	assign eq = eq_16;
	
endmodule

module comp_2(eq_prev, gt_prev, a_0, a_1, b_0, b_1, eq, gt);
	// Input
	input eq_prev, gt_prev;
	input a_1, a_0, b_1, b_0;
	
	// Output
	output eq, gt;
	
	// Wire
	wire gt_a, gt_b, gt_c, gt_d, gt_e;
	wire eq_a, eq_b, eq_c, eq_d, eq_e;
	wire a_1_not, a_0_not, b_1_not, b_0_not;
	
	// Code
	not not_a(a_1_not, a_1);
	not not_b(a_0_not, a_0);
	not not_c(b_1_not, b_1);
	not not_d(b_0_not, b_0);
	
	and gt_and_a(gt_a, a_1, a_0, b_1, b_0_not);
	and gt_and_b(gt_b, a_1, b_1_not);
	and gt_and_c(gt_c, a_1_not, a_0, b_1_not, b_0_not);
	
	or gt_or_a(gt_d, gt_a, gt_b, gt_c);
	and gt_and_d(gt_e, gt_d, eq_prev);
	
	or gt_or_b(gt, gt_prev, gt_e);
	
	and eq_and_a(eq_a, a_1, a_0, b_1, b_0);
	and eq_and_b(eq_b, a_1_not, a_0, b_1_not, b_0);
	and eq_and_c(eq_c, a_1, a_0_not, b_1, b_0_not);
	and eq_and_d(eq_d, a_1_not, a_0_not, b_1_not, b_0_not);
	
	or eq_or_a(eq_e, eq_a, eq_b, eq_c, eq_d);
	and eq_and_e(eq, eq_prev, eq_e);
	
endmodule

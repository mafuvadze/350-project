module mux_32(out, in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23, in_24, in_25, in_26, in_27, in_28, in_29, in_30, in_31, sel);
	// Inputs
	input [31:0] in_0, in_1, in_2, in_3, in_4, in_5, in_6, in_7, in_8, in_9, in_10, in_11, in_12, in_13, in_14, in_15, in_16, in_17, in_18, in_19, in_20, in_21, in_22, in_23, in_24, in_25, in_26, in_27, in_28, in_29, in_30, in_31;
	input [4:0] sel;
	
	// Outputs
	output [31:0] out;
	
	// Wire
	wire [31:0] a, b, c, d, e, f, g, h, i, j;
	
	// Code
	mux_4 mux_a(a, in_0, in_1, in_2, in_3, sel[1:0]);
	mux_4 mux_b(b, in_4, in_5, in_6, in_7, sel[1:0]);
	mux_4 mux_c(c, in_8, in_9, in_10, in_11, sel[1:0]);
	mux_4 mux_d(d, in_12, in_13, in_14, in_15, sel[1:0]);
	mux_4 mux_e(e, in_16, in_17, in_18, in_19, sel[1:0]);
	mux_4 mux_f(f, in_20, in_21, in_22, in_23, sel[1:0]);
	mux_4 mux_g(g, in_24, in_25, in_26, in_27, sel[1:0]);
	mux_4 mux_h(h, in_28, in_29, in_30, in_31, sel[1:0]);
	
	mux_4 mux_i(i, a, b, c, d, sel[3:2]);
	mux_4 mux_j(j, e, f, g, h, sel[3:2]);
	
	
	mux_2 mux_k(out, i, j, sel[4]);
endmodule

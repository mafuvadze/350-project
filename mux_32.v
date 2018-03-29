module mux_32(
	out,
	opt0, opt1, opt2, opt3, opt4, opt5, opt6, opt7, opt8, opt9, opt10, opt11, opt12, opt13, opt14, opt15, opt16, opt17, opt18, opt19, opt20, opt21, opt22, opt23, opt24, opt25, opt26, opt27, opt28, opt29, opt30, opt31,
	sel
);

	input [31:0] 	opt0, opt1, opt2, opt3, opt4, opt5, opt6, opt7, opt8, opt9, opt10, opt11, opt12, opt13, opt14, opt15, opt16, opt17, opt18, opt19, opt20, opt21, opt22, opt23, opt24, opt25, opt26, opt27, opt28, opt29, opt30, opt31;

	input [4:0] 	sel;
	
	output [31:0] 	out;
	
	wire [31:0] 	muxes[9:0];
	
	// Code
	mux_4 mux_a(muxes[0], opt0, opt1, opt2, opt3, sel[1:0]);
	mux_4 mux_b(muxes[1], opt4, opt5, opt6, opt7, sel[1:0]);
	mux_4 mux_c(muxes[2], opt8, opt9, opt10, opt11, sel[1:0]);
	mux_4 mux_d(muxes[3], opt2, opt13, opt14, opt15, sel[1:0]);
	mux_4 mux_e(muxes[4], opt16, opt17, opt18, opt19, sel[1:0]);
	mux_4 mux_f(muxes[5], opt20, opt21, opt22, opt23, sel[1:0]);
	mux_4 mux_g(muxes[6], opt24, opt25, opt26, opt27, sel[1:0]);
	mux_4 mux_h(muxes[7], opt28, opt29, opt30, opt31, sel[1:0]);
	
	mux_4 mux_i(muxes[8], muxes[0], muxes[1], muxes[2], muxes[3], sel[3:2]);
	mux_4 mux_j(muxes[9], muxes[4], muxes[5], muxes[6], muxes[7], sel[3:2]);
	
	
	mux_2 mux_k(out, muxes[8], muxes[9], sel[4]);
endmodule

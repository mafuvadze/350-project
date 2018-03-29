module mux_4(
	out,
	opt0, opt1, opt2, opt3,
	sel
);

	input [1:0] 	sel;
	input [31:0] 	opt0, opt1, opt2, opt3;
	
	output [31:0] 	out;
	
	wire [31:0] 	muxes[1:0];
	
	mux_2 mux_a(muxes[0], opt0, opt1, sel[0]);
	mux_2 mux_b(muxes[1], opt2, opt3, sel[0]);
	
	mux_2 mux_c(out, muxes[0], muxes[1], sel[1]);
endmodule

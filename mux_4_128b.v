module mux_4_128b(
	out,
	opt0, opt1, opt2, opt3,
	sel
);

	input [1:0] 	sel;
	input [127:0] 	opt0, opt1, opt2, opt3;
	
	output [127:0] 	out;
	
	wire [127:0] 	muxes[1:0];
	
	assign muxes[0] = sel[0] ? opt1 : opt0;
	assign muxes[1] = sel[1] ? opt3 : opt2;
	
	assign out = sel[1] ? muxes[1] : muxes[0];
	
endmodule

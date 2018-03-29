module mux_2(
	out,
	opt0, opt1,
	sel
);

	input 			sel;
	input [31:0] 	opt0, opt1;
	
	output [31:0] 	out;
	
	assign out = sel ? opt1 : opt0;
	
endmodule

module mux_2(out, in_0, in_1, sel);
	// Input
	input sel;
	input [31:0] in_0, in_1;
	
	// Output
	output [31:0] out;
	
	// Code
	assign out = sel ? in_1 : in_0;
endmodule

module mux_4(out, in_0, in_1, in_2, in_3, sel);
	// Inputs
	input [1:0] sel;
	input [31:0] in_0, in_1, in_2, in_3;
	
	// Output
	output [31:0] out;
	
	// Wires
	wire [31:0] a, b;
	
	// Code
	mux_2 mux_a(.out(a), .in_0(in_0), .in_1(in_1), .sel(sel[0]));
	mux_2 mux_b(.out(b), .in_0(in_2), .in_1(in_3), .sel(sel[0]));
	mux_2 mux_c(.out(out), .in_0(a), .in_1(b), .sel(sel[1]));
endmodule

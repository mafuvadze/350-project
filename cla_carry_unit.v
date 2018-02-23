module cla_carry_unit(C, P, G, c_in);
	// Input
	input [3:0] P, G;
	input c_in;
	
	// Output
	output [3:0] C;
	
	// Wire
	wire [2:0] PC;
	
	// Code	
	assign C[0] = c_in;
	
	and and_1(PC[0], P[0], C[0]);
	or or_1(C[1], G[0], PC[0]);
	
	and and_2(PC[1], P[1], C[1]);
	or or_2  (C[2], G[1], PC[1]);
	
	and and_3(PC[2], P[2], C[2]);
	or or_3  (C[3], G[2], PC[2]);
		
endmodule

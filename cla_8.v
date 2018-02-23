module cla_8(sum, p_out, g_out, a, b, c_in);
	// Input
	input [7:0] a, b;
	input c_in;
	
	// Output
	output [7:0] sum;
	output p_out, g_out;
	
	// Wire
	wire [7:0] P, G, PC, C;
	
	// Code
	assign C[0] = c_in;
	
	and and_1(G[0], a[0], b[0]);
	and and_2(G[1], a[1], b[1]);
	and and_3(G[2], a[2], b[2]);
	and and_4(G[3], a[3], b[3]);
	and and_5(G[4], a[4], b[4]);
	and and_6(G[5], a[5], b[5]);
	and and_7(G[6], a[6], b[6]);
	and and_8(G[7], a[7], b[7]);
	
	xor xor_1(P[0], a[0], b[0]);
	xor xor_2(P[1], a[1], b[1]);
	xor xor_3(P[2], a[2], b[2]);
	xor xor_4(P[3], a[3], b[3]);
	xor xor_5(P[4], a[4], b[4]);
	xor xor_6(P[5], a[5], b[5]);
	xor xor_7(P[6], a[6], b[6]);
	xor xor_8(P[7], a[7], b[7]);
	
	and and_9 (PC[0], P[0], C[0]);
	and and_10(PC[1], P[1], C[1]);
	and and_11(PC[2], P[2], C[2]);
	and and_12(PC[3], P[3], C[3]);
	and and_13(PC[4], P[4], C[4]);
	and and_14(PC[5], P[5], C[5]);
	and and_15(PC[6], P[6], C[6]);
	and and_16(PC[7], P[7], C[7]);
	
	or or_1 (C[1], G[0], PC[0]);
	or or_2 (C[2], G[1], PC[1]);
	or or_3 (C[3], G[2], PC[2]);
	or or_4 (C[4], G[3], PC[3]);
	or or_5 (C[5], G[4], PC[4]);
	or or_6 (C[6], G[5], PC[5]);
	or or_7 (C[7], G[6], PC[6]);
	or or_8(g_out, G[7], PC[7]);

	xor xor_9 (sum[0], P[0], C[0]);
	xor xor_10(sum[1], P[1], C[1]);
	xor xor_11(sum[2], P[2], C[2]);
	xor xor_12(sum[3], P[3], C[3]);
	xor xor_13(sum[4], P[4], C[4]);
	xor xor_14(sum[5], P[5], C[5]);
	xor xor_15(sum[6], P[6], C[6]);
	xor xor_16(sum[7], P[7], C[7]);
	
	and and_17(p_out, P[7], P[6], P[5], P[4], P[3], P[2], P[1], P[0]);

endmodule

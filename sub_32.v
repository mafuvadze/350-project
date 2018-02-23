module sub_32(sum, a, b);
	input [31:0] a, b;
	
	output [31:0] sum;
	
	wire [31:0] bn;
	wire [3:0] po, go;
	wire [3:0] C;
	
	genvar i;
	generate
		for (i = 0; i < 32 ; i = i + 1) begin: invert
			not not_sub (bn[i], b[i]);
		end 
	endgenerate
	
	cla_8 add_1(.sum(sum[7:0]),   .p_out(po[0]), .g_out(go[0]), .a(a[7:0]),   .b(bn[7:0]),   .c_in(C[0]));
	cla_8 add_2(.sum(sum[15:8]),  .p_out(po[1]), .g_out(go[1]), .a(a[15:8]),  .b(bn[15:8]),  .c_in(C[1]));
	cla_8 add_3(.sum(sum[23:16]), .p_out(po[2]), .g_out(go[2]), .a(a[23:16]), .b(bn[23:16]), .c_in(C[2]));
	cla_8 add_4(.sum(sum[31:24]), .p_out(po[3]), .g_out(go[3]), .a(a[31:24]), .b(bn[31:24]), .c_in(C[3]));
	
	cla_carry_unit carry(.C(C), .P(po), .G(go), .c_in(1'b1));
	
endmodule

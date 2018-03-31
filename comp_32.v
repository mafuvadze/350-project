module comp_32(
	neq,
	lt,
	num0,
	num1
);

	input signed [31:0] num0, num1;
	
	output neq, lt;

	assign neq 	= num0 != num1;
	assign lt	= num0 < num1;
	
endmodule

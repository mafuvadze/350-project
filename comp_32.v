module comp_32(
	neq,
	lt,
	num0,
	num1
);

	input [31:0] data_operandA, data_operandB;
	
	output neq, lt;

	assign neq 	= data_operandA != data_operandB;
	assign lt	= (data_operandA[31] == 1 & data_operandB[31] == 0)
		| ((data_operandA[31] == data_operandB[31]) & data_operandA < data_operandB);
	
endmodule

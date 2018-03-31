module alu(
	data_operandA,
	data_operandB,
	ctrl_ALUopcode,
	ctrl_shiftamt,
	data_result,
	isNotEqual,
	isLessThan,
	overflow
);

   input signed [31:0] data_operandA,
						data_operandB;
   input [4:0] 	ctrl_ALUopcode,
						ctrl_shiftamt;

   output [31:0] 	data_result;
   output 			isNotEqual,
						isLessThan,
						overflow;
	
	wire [31:0] 	sum,
						diff,
						band,
						bor,
						sll,
						sra;

	assign sum 	= data_operandA + data_operandB;
	assign diff = data_operandA - data_operandB;
	assign band = data_operandA & data_operandB;
	assign bor 	= data_operandA | data_operandB;
	assign sll 	= data_operandA << ctrl_shiftamt;
	assign sra 	= data_operandA >>> ctrl_shiftamt;

	comp_32 comparator (
		isNotEqual,
		isLessThan,
		data_operandA,
		data_operandA
	);
	
	mux_32 mux (
		.out	(data_result),
		.opt0	(sum),
		.opt1	(diff),
		.opt2	(band),
		.opt3	(bor),
		.opt4	(sll),
		.opt5	(sra),
		.sel	(ctrl_ALUopcode)
	);
	
endmodule

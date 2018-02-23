module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;
	
	wire [31:0] not_data_operandB, o_add, o_sub, o_and, o_or, o_sll, o_sra;
	wire [3:0] ovf;
	wire [6:0] temp;
	wire eq, gt, ngt, is_add;

	// ADD
   cla_32 add(.sum(o_add), .a(data_operandA), .b(data_operandB), .c_in(1'b0));
   
	
	// SUBSTACT
	
	genvar i;
	generate
		for (i = 0; i < 32 ; i = i + 1) begin: invert
			not not_sub(not_data_operandB[i], data_operandB[i]);
		end 
	endgenerate
	
	cla_32 sub(.sum(o_sub), .a(data_operandA), .b(not_data_operandB), .c_in(1'b1));

	// BITWISE AND
	bitwise_and band(.out(o_and), .in_1(data_operandA), .in_0(data_operandB));
	
	// BITWISE OR
	bitwise_or bor(.out(o_or), .in_1(data_operandA), .in_0(data_operandB));
	
	// SHIFT LEFT
	sll shift_left(.out(o_sll), .in(data_operandA), .amt(ctrl_shiftamt));
	
	// SHIFT RIGHT
	sra shift_right(.out(o_sra), .in(data_operandA), .amt(ctrl_shiftamt));
	
	// COMPARATOR
	comp_32 comp(eq, gt, 1'b1, data_operandA, data_operandB);
	not not_1(isNotEqual, eq);
	not not_2(ngt, gt);
	and and_1(isLessThan, ngt, isNotEqual);
	
	// OVERFLOW
	
	nor and_add(is_add, ctrl_ALUopcode[4], ctrl_ALUopcode[3], ctrl_ALUopcode[2], ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
	
	not n_1(temp[0], data_operandA[31]);
	not n_2(temp[1], data_operandB[31]);
	not n_3(temp[2], o_add[31]);
	not n_4(temp[3], not_data_operandB);
	not n_5(temp[4], o_sub);

	
	and and_2(ovf[0], temp[0], temp[1], o_add[31]);
	and and_3(ovf[1], data_operandA[31], data_operandB[31], temp[2]);
	
	and and_4(ovf[2], temp[0], temp[3], o_sub[31]);
	and and_5(ovf[3], data_operandA[31], not_data_operandB[31], temp[4]);
	
	or o_1(temp[5], ovf[0], ovf[1]);
	or o_2(temp[6], ovf[2], ovf[3]);
	
	assign overflow = is_add ? temp[5] : temp[6];
	
	// SELECTOR
	mux_32 mux(data_result, o_add, o_sub, o_and, o_or, o_sll, o_sra, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, 32'bZ, ctrl_ALUopcode);
	
endmodule

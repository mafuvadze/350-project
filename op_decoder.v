module op_decoder (mult_or_div, mult, bne, blt, bex, jump, j2, weDM, weReg, weRegDM, ALUop, immediate, weStatus, weReturn, instr);
	input [31:0] 		instr;
	output				mult_or_div,
							mult,
							bne,
							blt,
							bex,
							jump,			// Jump
							j2,			// J-type 2 
							weDM,			// Write enable for data memory
							weReg,		//	Write enable for rd
							weRegDM,		// Write enable val to reg from data memory
							ALUop,		//	Denote arithmetic operation
							immediate,	//	Has immidiate instr
							weStatus,	// Write enable to status reg
							weReturn;	// Write enable to return reg

	wire [4:0]			opcode,
							ALUopcode;
	wire 					alu,
							j,
							jal,
							jr,
							addi,
							sw,
							lw,
							setx,
							div,
							mult;
	
	assign opcode = instr[31:27];
	assign ALUopcode = instr[6:2];
	
	decoder_5_32 opdecoder (
		.out_0(alu),
		.out_1(j),
		.out_2(bne),
		.out_3(jal),
		.out_4(jr),
		.out_5(addi),
		.out_6(blt),
		.out_7(sw),
		.out_8(lw),
		.out_9(setx),
		.out_10(bex),
		.in_0(opcode[0]),
		.in_1(opcode[1]),
		.in_2(opcode[2]),
		.in_3(opcode[3]),
		.in_4(opcode[4])
	);
	
	decoder_5_32 multdecoder (
		.out_6(mult),
		.out_7(div),
		.in_0(ALUopcode[0]),
		.in_1(ALUopcode[1]),
		.in_2(ALUopcode[2]),
		.in_3(ALUopcode[3]),
		.in_4(ALUopcode[4])
	);
	
	or or_jump 		(jump, j, jal, jr);
	or or_j2 		(j2, jr, 1'b0);
	or or_weDM 		(weDM, sw, 1'b0);
	or or_weReg 	(weReg, alu, jal, addi, lw, setx);
	or or_weRegDM 	(weRegDM, lw, 1'b0);
	or or_ALUop 	(ALUop, alu, addi);
	or or_imm 		(immediate, bne, lw, sw, blt, addi);
	or or_weStatus (weStatus, alu, setx, addi);
	or or_weReturn (weReturn, jal, 1'b0);
	assign mult_or_div = ALUop & (mult | div);
	
endmodule

module op_decoder (branch, j1, j2, weDM, weReg, weRegDM, ALUop, immediate, weStatus, weReturn, instr);
	input [31:0] 		instr;
	output				branch,		// Branch instruction
							j1,			// J-type 1
							j2,			// J-type 2 
							weDM,			// Write enable for data memory
							weReg,		//	Write enable for rd
							weRegDM,		// Write enable val to reg from data memory
							ALUop,		//	Denote arithmetic operation
							immediate,	//	Has immidiate instr
							weStatus,	// Write enable to status reg
							weReturn;	// Write enable to return reg

	wire [4:0]			opcode;
	wire 					alu,
							j,
							bne,
							jal,
							jr,
							addi,
							blt,
							sw,
							lw,
							setx,
							bex;
	
	assign opcode = instr[31:27];
	
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
		.out_11(),
		.out_12(),
		.out_13(),
		.out_14(),
		.out_15(),
		.out_16(),
		.out_17(),
		.out_18(),
		.out_19(),
		.out_20(),
		.out_21(),
		.out_22(),
		.out_23(),
		.out_24(),
		.out_25(),
		.out_26(),
		.out_27(),
		.out_28(),
		.out_29(),
		.out_30(),
		.out_31(),
		.in_0(opcode[0]),
		.in_1(opcode[1]),
		.in_2(opcode[2]),
		.in_3(opcode[3]),
		.in_4(opcode[4])
	);
	
	or or_1 (branch, bne, bex, blt);
	or or_2 (j1, j, jal, setx, bex);
	or or_3 (j2, jr, 1'b0);
	or or_4 (weDM, sw, 1'b0);
	or or_5 (weReg, alu, jal, addi, lw, setx);
	or or_6 (weRegDM, lw, 1'b0);
	or or_7 (ALUop, alu, addi);
	or or_8 (immediate, bne, lw, sw, blt, addi);
	or or_9 (weStatus, alu, setx, addi);
	or or_10(weReturn, jal, 1'b0);
	
endmodule

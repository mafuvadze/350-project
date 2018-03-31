module op_decoder (target, shamt, ALUopcode, rs, rt, rd, imm_val, bne, blt, jal, jr, jump, j2, rd_read, weDM, weReg, weRegDM, ALUop, immediate, weStatus, weReturn, instr);
	input [31:0] 		instr;
	output				bne,
							blt,
							jump,
							jal,
							j2,
							jr,
							rd_read,
							weDM,
							weReg,
							weRegDM,
							ALUop,
							immediate,
							weStatus,
							weReturn;
	output [4:0]		rs,
							rt,
							rd,
							ALUopcode,
							shamt;
	output [31:0]		imm_val,
							target;

	wire [4:0]			opcode;
	wire 					alu,
							j,
							addi,
							sw,
							lw,
							div,
							mult;
	
	assign opcode = instr[31:27];
	assign ALUopcode = instr[6:2];
	
	decoder_5_32 opdecoder (
		.out0	(alu),
		.out1	(j),
		.out2	(bne),
		.out3	(jal),
		.out4	(jr),
		.out5	(addi),
		.out6	(blt),
		.out7	(sw),
		.out8	(lw),
		.in0	(opcode[0]),
		.in1	(opcode[1]),
		.in2	(opcode[2]),
		.in3	(opcode[3]),
		.in4	(opcode[4])
	);

	or or_jump 		(jump, j, jal, jr);
	or or_j2 		(j2, jr, 1'b0);
	or or_weDM 		(weDM, sw, 1'b0);
	or or_weReg 	(weReg, alu, jal, addi, lw);
	or or_weRegDM 	(weRegDM, lw, 1'b0);
	or or_ALUop 	(ALUop, alu);
	or or_imm 		(immediate, bne, lw, sw, blt, addi);
	or or_weStatus (weStatus, alu, addi);
	or or_weReturn (weReturn, jal, 1'b0);
	
	assign rd_read = weDM
		|	(bne | blt)
		|	jr;
		
	assign shamt	= instr[11:7];
	assign target	= {5'b0, instr[26:0]};
	
	assign rd		= instr[26:22];
	assign rs		= instr[21:17];
	assign rt		= instr[16:12];
	assign imm_val	= instr[16] ? {15'b1, instr[16:0]} : {15'b0, instr[16:0]};
	
endmodule

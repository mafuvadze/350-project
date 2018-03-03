/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input 			clock,
						reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] 	q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output 			wren;
    input [31:0] 	q_dmem;

    // Regfile
    output 			ctrl_writeEnable;
    output [4:0]  ctrl_writeReg,
						ctrl_readRegA,
						ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0]  data_readRegA,
						data_readRegB;
	 
	 wire [31:0] 	fetch_imem_extended,
						fetch_PC_increment,
						fetch_PC,
						fetch_PC_next,
						fetch_PC_next_latched,
						fetch_IR_latched,
						decode_imm,
						decode_PC_next_latched,
						decode_IR_latched,
						decode_imm_latched,
						decode_data_readRegA_latched,
						decode_data_readRegB_latched,
						execute_dataA,
						execute_data_latched,
						execute_dataB,
						execute_multdiv_result,
						execute_target,
						execute_PC_next,
						execute_PC_next_latched,
						execute_PC_plus1_latched,
						execute_bne_blt_or_jump,
						execute_ALU_result,
						execute_ALU_result_latched,
						memory_ALU_result_latched,
						memory_PC_plus1_latched,
						memory_data_read_latched;
	 wire [16:0]	decode_imm_raw;
	 wire [13:0]	decode_ctrls,
	 					decode_ctrls_latched,
						execute_ctrls,
						execute_ctrls_latched,
						memory_ctrls_latched;
	 wire [11:0]	fetch_jump_branch_pc;
	 wire [4:0]		rstatus,
						rzero,
						r31,
						decode_rs,
						decode_rt,
						decode_rd,
						decode_regB,
						execute_rd_latched,
						execute_shamt,
						execute_aluop,
						memory_rd_latched,
						memory_ctrl_writeReg,
						add_aluop;
	 wire 			decode_uses_rd,
						decode_jr,
						decode_bne_or_blt,
						decode_weDM,
						decode_bex,
						decode_uses_imm,
						decode_imm_neg,
						decode_mult_or_div,
						decode_mult,
						decode_div,
						execute_uses_addition,
						execute_mult_or_div,
						execute_branch_taken,
						execute_jump_branch_taken_latched,
						execute_is_aluop,
						execute_eq,
						execute_gt,
						execute_jump,
						execute_j2,
						execute_bne_taken,
						execute_blt_taken,
						execute_bex_taken,
						execute_uses_imm,
						execute_multdiv_ready,
						execute_branch_or_jump,
						memory_branch_or_jump,
						memory_jump,
						writeback_jal,
						writeback_is_aluop,
						stall,
						stall_multdiv,
						mult_ctrl,
						div_ctrl,
						HIGH,
						LOW;
	 
	 /* CONSTANTS */
	 assign HIGH 	 				= 1'b1;
	 assign LOW 	 				= 1'b0;
	 assign rstatus 				= 5'd30;
	 assign rzero   				= 5'b0;
	 assign r31		 				= 5'd31;
	 assign fetch_PC_increment = 32'd1;
	 assign add_aluop				= 5'b0;

	 /* STALL LOGIC */
	 assign execute_mult_or_div 	= decode_ctrls_latched[12];
	 assign stall_multdiv 			= execute_mult_or_div & ~execute_multdiv_ready;
	 assign stall 						= stall_multdiv;
		
	 /* FETCH STAGE */
	 assign fetch_jump_branch_pc 	= memory_jump ? execute_PC_next_latched[11:0] : execute_ALU_result_latched[11:0];
	 assign address_imem 			= execute_jump_branch_taken_latched ? fetch_jump_branch_pc : fetch_PC[11:0];
	 assign fetch_imem_extended 	= {20'b0, address_imem};
	 
	 register pc_reg (
		.data	 (fetch_PC_next),
		.enable(~stall),
		.reset (reset),
		.clk	 (~clock),
		.out	 (fetch_PC)
	 );
	 
	 cla_32 pc_next (
		.sum		(fetch_PC_next),
		.overflow(),
		.a			(fetch_imem_extended),
		.b			(fetch_PC_increment),
		.c_in		(LOW)
	 );
	 
	 FD_latch fd_latch (
		.out_IR	   (fetch_IR_latched),
		.out_PC_next(fetch_PC_next_latched),
		.wren	      (~stall),								
		.clock	   (~clock),
		.reset	   (reset | memory_branch_or_jump),
		.in_IR	   (q_imem),
		.in_PC_next	(fetch_PC)
	 );
	 
	/* DECODE STAGE */
		op_decoder opdec (
		.mult				(decode_ctrls[13]),
		.mult_or_div	(decode_ctrls[12]),
		.bne				(decode_ctrls[11]),
		.blt				(decode_ctrls[10]),
		.bex				(decode_ctrls[9]),
		.jump				(decode_ctrls[8]),
		.j2				(decode_ctrls[7]),
		.weDM				(decode_ctrls[6]),
		.weReg			(decode_ctrls[5]),
		.weRegDM			(decode_ctrls[4]),
		.ALUop			(decode_ctrls[3]),
		.immediate		(decode_ctrls[2]),
		.weReturn		(decode_ctrls[1]),
		.weStatus		(decode_ctrls[0]),
		.instr			(fetch_IR_latched)
	);
	
	assign decode_jr 			 	= decode_ctrls[8] & decode_ctrls[7];
	assign decode_bne_or_blt 	= decode_ctrls[10] | decode_ctrls[11];
	assign decode_weDM 			= decode_ctrls[6];
	assign decode_bex 			= decode_ctrls[9];
	
	assign decode_uses_rd = ~decode_bex
		&	(decode_weDM
		|	decode_bne_or_blt
		|	decode_jr);
	
	
	assign decode_rs = fetch_IR_latched[21:17];
	assign decode_rt = fetch_IR_latched[16:12];
	assign decode_rd = fetch_IR_latched[26:22];
	
	assign decode_regB 		= decode_uses_rd ? decode_rd : decode_rt;
	assign decode_imm_neg 	= fetch_IR_latched[16];
	assign decode_imm_raw	= fetch_IR_latched[16:0];
						
	assign ctrl_readRegA = decode_bex 		? rstatus : decode_rs;
	assign ctrl_readRegB = decode_bex 		? rzero : decode_regB;
	assign decode_imm 	= decode_imm_neg 	? {15'b1, decode_imm_raw} : {15'b0, decode_imm_raw};
	
	// Reset multdiv
	assign decode_mult_or_div 		= decode_ctrls[12];
	assign execute_mult_or_div 	= decode_ctrls_latched[12];
	
	assign execute_mult 				= decode_ctrls[13];
	assign execute_div				= ~decode_ctrls[13];
	
	assign mult_ctrl 		= decode_mult_or_div & ~execute_mult_or_div & execute_mult;
	assign div_ctrl		= decode_mult_or_div & ~execute_mult_or_div & execute_div;
	
	
	DX_latch dx_latch (
		.out_PC_next		(decode_PC_next_latched),												
		.out_ctrl_signals	(decode_ctrls_latched),										
		.out_immediate		(decode_imm_latched),							
		.out_instr			(decode_IR_latched),
		.out_data_readRegA(decode_data_readRegA_latched),
		.out_data_readRegB(decode_data_readRegB_latched),
		.wren					(~stall),																					// TODO add logic
		.clock				(~clock),
		.reset				(reset | memory_branch_or_jump),
		.in_PC_next			(fetch_PC_next_latched),
		.in_ctrl_signals	(decode_ctrls),
		.in_immediate		(decode_imm),
		.in_instr			(fetch_IR_latched),
		.in_data_readRegA	(data_readRegA),
		.in_data_readRegB	(data_readRegB)
	);
	
	/* EXECUTE STAGE */
	assign execute_bne_blt_or_jump = decode_ctrls_latched[11] | decode_ctrls_latched[10] | decode_ctrls_latched[8];
	assign execute_uses_imm 		 = decode_ctrls_latched[2];
	assign execute_is_aluop 		 = decode_ctrls_latched[3];
	assign execute_uses_addition	 = decode_ctrls_latched[6]
		| decode_ctrls_latched[4]
		| decode_ctrls_latched[11]
		| decode_ctrls_latched[10];
	
	assign execute_dataA = execute_bne_blt_or_jump ? decode_PC_next_latched : decode_data_readRegA_latched;
	assign execute_dataB = execute_uses_imm ? decode_imm_latched : decode_data_readRegB_latched;
	
	assign execute_aluop =execute_is_aluop? decode_IR_latched[6:2] : add_aluop;
	assign execute_shamt	= decode_IR_latched[11:7];
		
	alu alu (
		.data_operandA	(execute_dataA),
		.data_operandB	(execute_dataB),
		.ctrl_ALUopcode(execute_aluop),
		.ctrl_shiftamt	(execute_shamt),
		.data_result	(execute_ALU_result),
		.isNotEqual		(),
		.isLessThan		(),
		.overflow		()
	);
	
	// rd < rs or rd != rs
	comp_32 branch_comp (
		.eq	 (execute_eq),
		.gt	 (execute_gt),
		.enable(HIGH),
		.in_0	 (decode_data_readRegB_latched),
		.in_1	 (decode_data_readRegA_latched)
	);
	
	multdiv mult_div (
		.data_operandA	(execute_dataA),
		.data_operandB	(execute_dataB), 
		.ctrl_MULT	  	(mult_ctrl),
		.ctrl_DIV	  	(div_ctrl),
		.clock		  	(clock),  
		.data_result  	(execute_multdiv_result),
		.data_exception(),
		.data_resultRDY(execute_multdiv_ready)
	);

	
	// Handle branches and jumps
	assign execute_branch_or_jump = execute_branch_taken | decode_ctrls_latched[8];
	assign execute_bne_taken		= decode_ctrls_latched[11] & ~execute_eq;
	assign execute_blt_taken		= decode_ctrls_latched[10] & ~execute_eq & ~execute_gt;
	assign execute_bex_taken		= decode_ctrls_latched[9] & ~execute_eq;
	assign execute_jump				= decode_ctrls_latched[8];
	assign execute_j2					= decode_ctrls_latched[7];
	
	assign execute_branch_taken = execute_bne_taken
		| execute_blt_taken
		| execute_bex_taken;
	
	assign execute_target  = {5'b0, decode_IR_latched[26:0]};
	assign execute_PC_next = execute_branch_taken ?
		32'bZ : (execute_jump ? (execute_j2 ? execute_dataB : execute_target) 
		: decode_PC_next_latched);
	assign execute_PC_next = (execute_blt_taken | execute_bne_taken) ? execute_ALU_result : 32'bZ;
	assign execute_PC_next = execute_bex_taken ? execute_target : 32'bZ;

		
	XM_latch xm_latch (
		.out_PC_next	  (execute_PC_next_latched),
		.out_PC_plus1	  (execute_PC_plus1_latched),
		.out_ctrl_signals(execute_ctrls_latched),									
		.out_ALU_result  (execute_ALU_result_latched),
		.out_data_reg	  (execute_data_latched),
		.out_rd			  (execute_rd_latched),
		.out_branch_taken(execute_jump_branch_taken_latched),
		.wren				  (HIGH),																					// TODO add logic
		.clock			  (~clock),
		.reset			  (reset | memory_branch_or_jump),
		.in_PC_next		  (execute_PC_next),
		.in_PC_plus1	  (decode_PC_next_latched),
		.in_ctrl_signals (decode_ctrls_latched),
		.in_ALU_result	  (decode_ctrls_latched[12] ? execute_multdiv_result : execute_ALU_result),
		.in_data_reg	  (decode_data_readRegB_latched),
		.in_rd			  (decode_IR_latched[26:22]),
		.in_branch_taken (execute_branch_or_jump)
	);
	
	/* MEMORY STAGE */
	assign memory_branch_or_jump = execute_jump_branch_taken_latched;
	assign address_dmem = execute_ALU_result_latched[11:0];
	assign data 		  = execute_data_latched;
	assign wren 		  = execute_ctrls_latched[6];
	assign memory_jump  = execute_ctrls_latched[8];
	
	MW_latch mx_latch (
		.out_ALU_result	(memory_ALU_result_latched),
		.out_data_read		(memory_data_read_latched),
		.out_rd				(memory_ctrl_writeReg),
		.out_ctrl_signals	(memory_ctrls_latched),
		.out_PC_next		(memory_PC_plus1_latched),
		.wren					(HIGH),																					// TODO add logic
		.clock				(~clock),
		.reset				(reset),
		.in_ALU_result		(execute_ALU_result_latched),
		.in_data_read		(q_dmem),
		.in_rd				(execute_rd_latched),
		.in_ctrl_signals	(execute_ctrls_latched),
		.in_PC_next			(execute_PC_plus1_latched)
	);
	
	/* WRITEBACK STAGE */
	assign writeback_is_aluop  = memory_ctrls_latched[3];
	assign writeback_jal 		= memory_ctrls_latched[8] & memory_ctrls_latched[1];
	assign ctrl_writeEnable 	= memory_ctrls_latched[5];
	
	assign ctrl_writeReg = writeback_jal ? r31 : memory_ctrl_writeReg;
	assign data_writeReg = writeback_jal ? memory_PC_plus1_latched
		: (memory_ctrls_latched[3] ? memory_ALU_result_latched : q_dmem);
//		: (memory_ctrls_latched[3] ? memory_ALU_result_latched : memory_data_read_latched);

endmodule

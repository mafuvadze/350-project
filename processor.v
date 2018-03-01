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
    output wren;
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
						execute_PC_next,
						execute_PC_next_latched,
						execute_ALU_result,
						execute_ALU_result_latched,
						memory_ALU_result_latched,
						memory_data_read_latched;
	 wire [11:0]	decode_ctrls,
	 					decode_ctrls_latched,
						execute_ctrls,
						execute_ctrls_latched,
						memory_ctrls_latched;
	 wire [4:0]		rstatus,
						rzero,
						execute_rd_latched,
						memory_rd_latched;
	 wire 			decode_uses_rd,
						execute_branch_taken,
						execute_eq,
						execute_gt,
						HIGH,
						LOW;
	 
	 /* CONSTANTS */
	 assign HIGH 	 = 1'b1;
	 assign LOW 	 = 1'b0;
	 assign rstatus = 5'd30;
	 assign rzero   = 5'b0;	
		
	 /* FETCH STAGE */
	 assign address_imem 			= execute_branch_taken ? 12'bZ : fetch_PC;
	 assign fetch_imem_extended 	= {20'b0, address_imem};
	 assign fetch_PC_increment 	= 32'd1; /*ISA is word addressed*/
	 
	 // Store the current PC. Write on falling edge of clock
	 register pc_reg (
		.data	 (fetch_PC_next),
		.enable(HIGH),
		.reset (reset),
		.clk	 (~clock),
		.out	 (fetch_PC)
	 );
	 
	 // Calculate the next instruction counter
	 cla_32 pc_next (
		.sum		(fetch_PC_next),
		.overflow(),
		.a			(fetch_imem_extended),
		.b			(fetch_PC_increment),
		.c_in		(LOW)
	 );
	 
	 // Latch the results of the fetch stage on falling edge
	 FD_latch fd_latch (
		.out_IR	   (fetch_IR_latched),
		.out_PC_next(fetch_PC_next_latched),
		.wren	      (HIGH),								
		.clock	   (~clock),
		.reset	   (reset | execute_branch_taken),
		.in_IR	   (q_imem),
		.in_PC_next	(fetch_PC)
	 );
	 
	/* DECODE STAGE */
	
	// Get control signals based on the 32-bit instruction
	op_decoder opdec (
		.bne				(decode_ctrls[11]),
		.blt				(decode_ctrls[10]),
		.bex				(decode_ctrls[9]),
		.j1				(decode_ctrls[8]),
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
	
	assign decode_uses_rd = ((decode_ctrls[6] & ~decode_ctrls[9]) | (decode_ctrls[10] | decode_ctrls[11]));
	assign ctrl_readRegA = decode_ctrls[9] ?
		rstatus : fetch_IR_latched[21:17];
	assign ctrl_readRegB = decode_ctrls[9] ?
		rzero : decode_uses_rd ?
		fetch_IR_latched[26:22] : fetch_IR_latched[16:12];
	assign decode_imm = fetch_IR_latched[16] ?													// Sign extension
		{15'b1, fetch_IR_latched[16:0]} : {15'b0, fetch_IR_latched[16:0]};
	
	// Latch the results of the decode stage on falling edge
	DX_latch dx_latch (
		.out_PC_next		(decode_PC_next_latched),												
		.out_ctrl_signals	(decode_ctrls_latched),										
		.out_immediate		(decode_imm_latched),							
		.out_instr			(decode_IR_latched),
		.out_data_readRegA(decode_data_readRegA_latched),
		.out_data_readRegB(decode_data_readRegB_latched),
		.wren					(HIGH),																					// TODO add logic
		.clock				(~clock),
		.reset				(reset | execute_branch_taken),
		.in_PC_next			(fetch_PC_next_latched),
		.in_ctrl_signals	(decode_ctrls),
		.in_immediate		(decode_imm),
		.in_instr			(fetch_IR_latched),
		.in_data_readRegA	(data_readRegA),
		.in_data_readRegB	(data_readRegB)
	);
	
	/* EXECUTE STAGE */
	assign execute_dataA = (decode_ctrls_latched[11] | decode_ctrls_latched[10]) ?							// Use PC if a branch instr
		decode_PC_next_latched : decode_data_readRegA_latched;
	assign execute_dataB = decode_ctrls_latched[2] ?				// Use imm if an ALUinB instr
		decode_imm_latched : decode_data_readRegB_latched;
	
	// Perform calculations
	alu alu (
		.data_operandA	(execute_dataA),
		.data_operandB	(execute_dataB),
		.ctrl_ALUopcode(decode_IR_latched[6:2]),
		.ctrl_shiftamt	(decode_IR_latched[11:7]),
		.data_result	(execute_ALU_result),
		.isNotEqual		(),
		.isLessThan		(),
		.overflow		()
	);
	
	// Compare value to see if branch is taken or not
	comp_32 branch_comp (
		.eq	 (execute_eq),
		.gt	 (execute_gt),
		.enable(HIGH),
		.in_0	 (decode_data_readRegA_latched),
		.in_1	 (decode_data_readRegB_latched)
	);
	
	// Branches
	assign execute_branch_taken = (decode_ctrls_latched[11] & ~execute_eq) |
		(decode_ctrls_latched[10] & (~execute_eq & ~execute_gt)) |
		(decode_ctrls_latched[9] & ~execute_eq);	
		
	assign execute_PC_next = execute_branch_taken ? 32'bZ : decode_PC_next_latched;
	assign execute_PC_next = (execute_branch_taken & (decode_ctrls_latched[11] | decode_ctrls_latched[10])) ?
		execute_ALU_result : 32'bZ;
	assign execute_PC_next = (execute_branch_taken & decode_ctrls_latched[9]) ?
		{5'b0, decode_IR_latched[26:0]} : 32'bZ;
		
	// Latch the results of the execute stage on falling edge
	XM_latch xm_latch (
		.out_PC_next	  (execute_PC_next_latched),											
		.out_ctrl_signals(execute_ctrls_latched),									
		.out_ALU_result  (execute_ALU_result_latched),
		.out_data_reg	  (execute_data_latched),
		.out_rd			  (execute_rd_latched),
		.wren				  (HIGH),																					// TODO add logic
		.clock			  (~clock),
		.reset			  (reset),
		.in_PC_next		  (execute_PC_next),
		.in_ctrl_signals (decode_ctrls_latched),
		.in_ALU_result	  (execute_ALU_result),
		.in_data_reg	  (decode_data_readRegB_latched),
		.in_rd			  (decode_IR_latched[26:22])
	);
	
	/* MEMORY STAGE */
	assign address_imem = execute_branch_taken ? execute_PC_next_latched[11:0] : 12'bZ;
	assign address_dmem = execute_ALU_result_latched[11:0];
	assign data 		  = execute_data_latched;
	assign wren 		  = execute_ctrls_latched[6];
	
	// Latch the results of the memory stage on falling edge
	MW_latch mx_latch (
		.out_ALU_result	(memory_ALU_result_latched),
		.out_data_read		(memory_data_read_latched),
		.out_rd				(ctrl_writeReg),
		.out_ctrl_signals	(memory_ctrls_latched),
		.wren					(HIGH),																					// TODO add logic
		.clock				(~clock),
		.reset				(reset),
		.in_ALU_result		(execute_ALU_result_latched),
		.in_data_read		(q_dmem),
		.in_rd				(execute_rd_latched),
		.in_ctrl_signals	(execute_ctrls_latched)
	);
	
	/* WRITEBACK STAGE */
	assign data_writeReg = memory_ctrls_latched[3] ?
		memory_ALU_result_latched  : memory_data_read_latched;
	assign ctrl_writeEnable = memory_ctrls_latched[5];

endmodule

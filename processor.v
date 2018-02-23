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
	 
	 wire [31:0] 	imem_extended,
						PC_plus_1,
						PC_increment,
						fetch_PC_next,
						fetch_IR,
						decode_imm,
						decode_PC_next,
						decode_IR,
						decode_ctrls_latched,
						decode_imm_latched,
						decode_data_readRegA,
						decode_data_readRegB,
						execute_dataB;
	 wire [9:0]		decode_ctrls,
						execute_ctrls;
	 wire 			HIGH,
						LOW;
	 
	 // Constants
	 assign HIGH = 1'b1;
	 assign LOW  = 1'b0;
	 
	 // Fetch
	 assign imem_extended = {20'b0, address_imem};
	 assign PC_increment = 32'd4;
	 
	 register pc_reg (
		.data(imem_extended),
		.enable(HIGH),
		.reset(reset),
		.clk(clock),
		.out(PC)
	 );
	 
	 cla_32 pc_next (
		.sum(PC_plus_1),
		.overflow(),
		.a(PC),
		.b(PC_increment),
		.c_in(LOW)
	 );
	 
	 FD_latch (
		.out_IR(fetch_IR),
		.out_PC_next(fetch_PC_next),
		.wren(),									// TODO: add logic for wren. Stalling/Nop?
		.clock(clock),
		.reset(reset),
		.in_IR(q_imem),
		.in_PC_next(PC_plus_1)
	 );
	 
	// Decode
	op_decoder opdec (
		.branch			(decode_ctrls[9]),
		.j1				(decode_ctrls[8]),
		.j2				(decode_ctrls[7]),
		.weDM				(decode_ctrls[6]),
		.weReg			(decode_ctrls[5]),
		.weRegDM			(decode_ctrls[4]),
		.ALUop			(decode_ctrls[3]),
		.immediate		(decode_ctrls[2]),
		.weReturn		(decode_ctrls[1]),
		.weStatus		(decode_ctrls[0]),
		.instr			(fetch_IR)
	);
	
	assign ctrl_readRegA = fetch_IR[21:17];
	assign ctrl_readRegB = fetch_IR[16:12];
	assign decode_imm = fetch_IR[16] ?								// Sign extension
		{16'b0, fetch_IR[16:0]} : {16'b1, fetch_IR[16:0]};
		
	DX_latch (
		.out_PC_next(decode_PC_next),												
		.out_ctrl_signals(decode_ctrls_latched),										
		.out_immediate(decode_imm_latched),							
		.out_instr(decode_IR),
		.out_data_readRegA(decode_data_readRegA),
		.out_data_readRegB(decode_data_readRegB),
		.wren(),													// TODO add logic
		.clock(clock),
		.reset(reset),
		.in_PC_next(fetch_PC_next),
		.in_ctrl_signals(decode_ctrls),
		.in_immediate(decode_imm),
		.in_instr(fetch_IR),
		.in_data_readRegA(data_readRegA),
		.in_data_readRegB(data_readRegB)
	);
	
	// Execute
	assign execute_dataB = decode_ctrls_latched[2] ?
		decode_imm_latched : decode_data_readRegB;
		
	alu alu (
		.data_operandA(decode_data_readRegA),
		.data_operandB(execute_dataB),
		.ctrl_ALUopcode(decode_IR[6:2]),
		.ctrl_shiftamt(decode_IR[11:7]),
		.data_result(),
		.isNotEqual(),
		.isLessThan(),
		.overflow()
	);
	
	comp_32 branch_comp (
		.eq(),
		.gt(),
		.enable(),
		.in_0(),
		.in_1()
	);


endmodule

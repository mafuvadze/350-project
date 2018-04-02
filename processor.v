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
	output [11:0] 	address_imem;
	input [31:0] 	q_imem;

	// Dmem
	output [11:0] 	address_dmem;
	output [31:0] 	data;
	output 			wren;
	input [31:0] 	q_dmem;

	// Regfile
	output 			ctrl_writeEnable;
	output [4:0]  	ctrl_writeReg,
						ctrl_readRegA,
						ctrl_readRegB;
	output [31:0] 	data_writeReg;
	input [31:0]  	data_readRegA,
						data_readRegB;
						
	// Bypass/Stall controls
	wire 				wx_bypassA,
						wx_bypassB,
						mx_bypassA,
						mx_bypassB,
						stall,
						mx_lw_bypass;
						
	// Fetch
	reg [31:0]		pc;
	
	// FD latch
	reg [31:0] 		fd_pc_next,
						fd_IR;

	// Decode
	wire [4:0]		d_rs,
						d_rt,
						d_rd;
	wire 				d_rd_read;
	
	op_decoder d_decode (
		.rs				(d_rs),
		.rt				(d_rt),
		.rd				(d_rd),
		.rd_read			(d_rd_read),
		.instr			(fd_IR)
	);
	
	assign ctrl_readRegA = d_rs;
	assign ctrl_readRegB	= d_rd_read ? d_rd : d_rt;
	
	// DX Latch
	reg [31:0]		dx_readRegA,
						dx_readRegB,
						dx_IR,
						dx_pc_next;
	reg [4:0]		dx_regA,
						dx_regB;
	
	// Execute
	wire [31:0]		e_ALUresult,
						e_flush,
						e_pc_next,
						e_jump_pc,
						e_imm_val,
						e_target,
						e_regA,
						e_regB;
	wire [4:0]		e_ALUopcode,
						e_shamt;	
	wire 				e_jr,
						e_blt,
						e_bne,
						e_jump,
						e_immediate,
						e_ALUop,
						e_branch_taken,
						e_neq,
						e_lt;
	
	op_decoder e_decode (
		.jr				(e_jr),
		.bne				(e_bne),
		.blt				(e_blt),
		.jump				(e_jump),
		.immediate		(e_immediate),
		.ALUopcode		(e_ALUopcode),
		.ALUop			(e_ALUop),
		.shamt			(e_shamt),
		.imm_val			(e_imm_val),
		.target			(e_target),
		.instr			(dx_IR)
	);
	
	alu alu (
		.data_operandA	(e_regA),
		.data_operandB	(e_immediate ? e_imm_val : e_regB),
		.ctrl_ALUopcode(e_ALUop ? e_ALUopcode : 5'b0),
		.ctrl_shiftamt	(e_shamt),
		.data_result	(e_ALUresult)
	);
	
	comp_32 comp(
		.neq	(e_neq),
		.lt	(e_lt),
		.num0	(e_regB), // rd
		.num1	(e_regA)	// rs
	);
	
	assign e_branch_taken = (e_blt & e_lt) | (e_bne & e_neq);
	assign e_flush 		 = (e_branch_taken | e_jump);
	assign e_jump_pc		 = e_jr ? dx_readRegB : e_target;
	assign e_pc_next		 = e_branch_taken ? (dx_pc_next + e_imm_val) : e_jump_pc; 
	
	// XM Latch
	reg [31:0]				xm_pc_next,
								xm_ALUresult,
								xm_data_rd,
								xm_IR,
								xm_link;
	reg						xm_flush;
	
	// Memory
	wire [31:0]				m_data_writeReg;
	wire [4:0]				m_ctrl_writeReg, m_rd;
	wire						m_jal,
								m_weRegDM,
								m_weReg,
								m_ctrl_writeEnable;
								
	op_decoder m_decode (
		.weDM				(wren),
		.weRegDM			(m_weRegDM),
		.rd				(m_rd),
		.jal				(m_jal),
		.weReg			(m_weReg),
		.instr			(xm_IR)
	);
	
	assign address_imem = xm_flush ? xm_pc_next[11:0] : (pc + 1);
	assign address_dmem = xm_ALUresult[11:0];
	assign data 		  = xm_data_rd;
	
	assign m_ctrl_writeEnable	= m_weReg;
	assign m_data_writeReg 		= m_jal ? xm_link : (m_weRegDM ? q_dmem : xm_ALUresult);
	assign m_ctrl_writeReg 		= m_jal ? 5'd31 : m_rd;
	
	// MW Latch
	reg [31:0]			mw_data_writeReg,
							mw_IR,
							mw_link;
	reg [4:0]			mw_ctrl_writeReg;
	reg					mw_ctrl_writeEnable;
	
	// Writeback	
	assign ctrl_writeEnable = mw_ctrl_writeEnable;
	assign ctrl_writeReg 	= mw_ctrl_writeReg;
	assign data_writeReg 	= mw_data_writeReg;
	
	// Latches
	always @(negedge clock) begin
		if (~stall) begin
			// FD latches
			pc 			<= {20'b0, address_imem};
			fd_pc_next  <= pc + 1;
			fd_IR		   <= q_imem;
		
			// DX latches
			dx_regA		<= ctrl_readRegA;
			dx_regB		<= ctrl_readRegB;
			dx_pc_next	<= fd_pc_next;
			dx_IR		  	<= fd_IR;
			dx_readRegA <= data_readRegA;
			dx_readRegB <= data_readRegB;
		
			// XM latches
			xm_link			<= dx_pc_next;
			xm_IR				<= dx_IR;
			xm_data_rd		<= e_regB;
			xm_flush			<= e_flush;
			xm_pc_next		<= e_pc_next;
			xm_ALUresult	<= e_ALUresult;
		end else begin
			// FD latches
			fd_pc_next  <= 0;
			fd_IR		   <= 0;
		
			// DX latches
			dx_regA		<= 0;
			dx_regB		<= 0;
			dx_pc_next	<= 0;
			dx_IR		  	<= 0;
			dx_readRegA <= 0;
			dx_readRegB <= 0;
		
			// XM latches
			xm_link			<= 0;
			xm_data_rd		<= 0;
			xm_IR				<= 0;
			xm_flush			<= 0;
			xm_pc_next		<= 0;
			xm_ALUresult	<= 0;
		end
	
		// MW latches
		mw_data_writeReg 		<= m_data_writeReg;
		mw_ctrl_writeReg 		<= m_ctrl_writeReg;
		mw_ctrl_writeEnable 	<= m_ctrl_writeEnable;
		mw_IR						<= xm_IR;
		mw_link					<= xm_link;
	end
	
	// Initialize registers
	initial begin
		pc					= -1;
		fd_pc_next  	= 0;
		fd_IR		   	= 0;
		dx_regA			= 0;
		dx_regB			= 0;
		dx_pc_next		= 0;
		dx_IR		  		= 0;
		dx_readRegA 	= 0;
		dx_readRegB 	= 0;
		xm_flush			= 0;
		xm_link			= 0;
		xm_pc_next		= 0;
		xm_ALUresult	= 0;
		xm_data_rd		= 0;
		xm_IR				= 0;
		mw_IR				= 0;
		mw_link			= 0;
		mw_data_writeReg 		= 0;
		mw_ctrl_writeReg 		= 0;
		mw_ctrl_writeEnable 	= 0;
	end
	
	// Flush and reset
		always @(xm_flush or reset) begin
		if (xm_flush | reset) begin
			fd_pc_next  <= 0;
			fd_IR		   <= 0;
			dx_regA		<= 0;
			dx_regB		<= 0;
			dx_pc_next	<= 0;
			dx_IR		  	<= 0;
			dx_readRegA <= 0;
			dx_readRegB <= 0;
		end
		
		if (reset) begin
			pc				<= 0;
			xm_flush		<= 0;
			xm_link		<= 0;
			xm_pc_next	<= 0;
			xm_ALUresult<= 0;
			xm_data_rd	<= 0;
			xm_IR			<= 0;
			mw_IR			<= 0;
			mw_link		<= 0;
			mw_data_writeReg 		= 0;
			mw_ctrl_writeReg 		= 0;
			mw_ctrl_writeEnable 	= 0;
		end
	end
	
	// Bypass/Stall
	assign mx_lw_bypass = m_weRegDM
		& ((m_ctrl_writeEnable & (dx_regA == m_ctrl_writeReg) & m_ctrl_writeReg != 0)
		| (m_ctrl_writeEnable & (dx_regB == m_ctrl_writeReg) & m_ctrl_writeReg != 0));
	
	assign stall		= mx_lw_bypass;
	
	assign wx_bypassA = ctrl_writeEnable & (dx_regA == ctrl_writeReg) & (ctrl_writeReg != 0);
	assign wx_bypassB = ctrl_writeEnable & (dx_regB == ctrl_writeReg) & (ctrl_writeReg != 0);
	
	assign mx_bypassA = m_ctrl_writeEnable & ~m_weRegDM & (dx_regA == m_ctrl_writeReg) & m_ctrl_writeReg != 0;
	assign mx_bypassB = m_ctrl_writeEnable & ~m_weRegDM & (dx_regB == m_ctrl_writeReg) & m_ctrl_writeReg != 0;
	
	assign e_regA		= mx_bypassA ? m_data_writeReg : (wx_bypassA ? data_writeReg : dx_readRegA);
	assign e_regB		= mx_bypassB ? m_data_writeReg : (wx_bypassB ? data_writeReg : dx_readRegB);	
	
endmodule

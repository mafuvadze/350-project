/**
 * NOTE: you should not need to change this file! This file will be swapped out for a grading
 * "skeleton" for testing. We will also remove your imem and dmem file.
 *
 * NOTE: skeleton should be your top-level module!
 *
 * This skeleton file serves as a wrapper around the processor to provide certain control signals
 * and interfaces to memory elements. This structure allows for easier testing, as it is easier to
 * inspect which signals the processor tries to assert when.
 */

module skeleton(CLOCK_50, GPIO, LEDR, SW);
    input 			CLOCK_50;
	 input [1:0]	SW;
	 output [17:0]	LEDR;
	 inout [35:0]	GPIO;

	 wire 			clock,
						reset,
						fgpa_state,
						write_done;
	 
	 reg				data_ready;
	 
	 assign 			reset = 0;
	 assign			fpga_state = SW[0];
	 
	// GPIO protocol
	clock_divider_50mhz_1hz clk_divider (
		.in_clock	(CLOCK_50),
		.out_clock 	(clock)
	);
	
	initial begin
		data_ready = 1;
	end
	
	always @(posedge clock) begin
		if (data_ready & write_done) data_ready = 0;
	end
	
	gpio_protocol comm (
		.GPIO			(GPIO),
		.clock		(clock),
		.data_ready	(data_ready),
		.done			(write_done),
		.state		(fpga_state),
		.message_in	(),
		.message_out({32'b101010110, 32'd3145, 32'd29455, 32'd939415})
	);
	
	assign LEDR[2] = data_ready;
	assign LEDR[1]	= write_done;
	assign LEDR[0] = GPIO[32];
	assign LEDR[17:3] = GPIO[17:0];


	 
    /** IMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_imem;
    wire [31:0] q_imem;
    imem my_imem(
        .address    (address_imem),            // address of data
        .clock      (~clock),                  // you may need to invert the clock
        .q          (q_imem)                   // the raw instruction
    );

    /** DMEM **/
    // Figure out how to generate a Quartus syncram component and commit the generated verilog file.
    // Make sure you configure it correctly!
    wire [11:0] address_dmem;
    wire [31:0] data;
    wire wren;
    wire [31:0] q_dmem;
    dmem my_dmem(
        .address    (address_dmem),       	  // address of data
        .clock      (~clock),                  // may need to invert the clock
        .data	     (data),    					  // data you want to write
        .wren	     (wren),      				  // write enable
        .q          (q_dmem)    					  // data from dmem
    );

    /** REGFILE **/
    // Instantiate your regfile
    wire ctrl_writeEnable;
    wire [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    wire [31:0] data_writeReg;
    wire [31:0] data_readRegA, data_readRegB;
    regfile my_regfile (
        clock,
        ctrl_writeEnable,
        reset,
        ctrl_writeReg,
        ctrl_readRegA,
        ctrl_readRegB,
        data_writeReg,
        data_readRegA,
        data_readRegB
    );

    /** PROCESSOR **/
    processor my_processor(
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

endmodule

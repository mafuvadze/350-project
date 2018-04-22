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

module skeleton(
	CLOCK_50,
	GPIO,
	LEDR,
	SW,
	PS2_CLK,
	PS2_DAT,
	LCD_DATA,
	LCD_RW,
	LCD_EN,
	LCD_RS,
	LCD_ON,
	LCD_BLON,
	HEX0,
	HEX1,
	KEY
);
    input 			CLOCK_50;
	 input [1:0]	SW;
	 input [3:0]	KEY;
	 
	 
	 output [17:0]	LEDR;
	 output [7:0]	LCD_DATA;
	 output [6:0]	HEX0,
						HEX1;
	 output 			LCD_RW,
						LCD_EN,
						LCD_RS,
						LCD_ON,
						LCD_BLON;
	 
	 inout [35:0]	GPIO;
	 inout			PS2_DAT,
						PS2_CLK;

	 wire 			clock,
						RESETN,
						reset,
						fgpa_state,
						write_done,
						data_pending,
						clock_1hz,
						scan_code_ready,
						letter_case_out;
	 wire [7:0]		ps2_scan_code,
						ps2_ascii;
	 wire [127:0]	message_in_wire,
						message_out;
												
	 reg				data_ready;
	 reg [4:0]		message_out_counter;
	 reg [7:0]		message_out_seg [15:0];
	 reg [127:0]	message_in;
	 	 
	 assign 			reset = 0;
	 assign			fpga_state = SW[0];
	 assign 			data_pending = SW[1];
	 
	 assign 			RESETN = KEY[0];
	 
	// GPIO protocol
	clock_divider_50mhz_1hz clk_divider (
		.in_clock	(CLOCK_50),
		.out_clock 	(clock_1hz)
	);
	
	initial begin
		message_out_counter = 0;
		data_ready = 0;
		message_in = 0;
	end
	
	always @(posedge data_pending or posedge write_done) begin
		if (write_done) data_ready = 0;
		else data_ready = 1;
	end
	
	gpio_protocol comm (
		.GPIO			(GPIO),
		.clock		(clock_1hz),
		.data_ready	(data_ready),
		.done			(write_done),
		.state		(fpga_state),
		.message_in	(message_in_wire),
		.message_out(message_out)
	);
	
	assign message_out = {
		message_out_seg[0],
		message_out_seg[1],
		message_out_seg[2],
		message_out_seg[3],
		message_out_seg[4],
		message_out_seg[5],
		message_out_seg[6],
		message_out_seg[7],
		message_out_seg[8],
		message_out_seg[9],
		message_out_seg[10],
		message_out_seg[11],
		message_out_seg[12],
		message_out_seg[13],
		message_out_seg[14],
		message_out_seg[15]
	};
	
	assign LEDR[2] = fpga_state ? GPIO[35] : GPIO[34];
	assign LEDR[1]	= write_done;
	assign LEDR[0] = GPIO[32];
	assign LEDR[17:3] = GPIO[17:0];


	// PS2
	ps2_keyboard ps2 (
		.clk					(CLOCK_50),
		.ps2d					(PS2_DAT),
		.ps2c					(PS2_CLK),
		.reset				(reset),
		.scan_code			(ps2_scan_code),
		.scan_code_ready	(scan_code_ready),
		.letter_case_out	(letter_case_out)
	);
	
	key2ascii convert (
		.letter_case	(letter_case_out),
		.scan_code		(ps2_scan_code),
		.ascii_code		(ps2_ascii)
	);
		
	lcd mylcd (
		CLOCK_50,
		~RESETN,
		scan_code_ready,
		ps2_ascii,
		LCD_DATA,
		LCD_RW,
		LCD_EN,
		LCD_RS,
		LCD_ON,
		LCD_BLON
	);
	
//	Hexadecimal_To_Seven_Segment hex1 (
//		ps2_out[3:0],
//		HEX0
//	);
//	
//	Hexadecimal_To_Seven_Segment hex2 (
//		ps2_out[7:4],
//		HEX1
//	);
	
	
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

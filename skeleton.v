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
	KEY,
	AUD_ADCDAT,
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,
	I2C_SDAT,
	AUD_XCK,
	AUD_DACDAT,
	I2C_SCLK
);
	 input 			CLOCK_50,
						AUD_ADCDAT;
	 input [1:0]	SW;
	 input [3:0]	KEY;
	 
	 
	 output [17:0]	LEDR;
	 output [7:0]	LCD_DATA;
	 output 			LCD_RW,
						LCD_EN,
						LCD_RS,
						LCD_ON,
						LCD_BLON,
						AUD_XCK,
						AUD_DACDAT,
						I2C_SCLK;
	 
	 inout [35:0]	GPIO;
	 inout			PS2_DAT,
						PS2_CLK,
						AUD_BCLK,
						AUD_ADCLRCK,
						AUD_DACLRCK,
						I2C_SDAT;	
					
	 wire 			clock,
						HIGH,
						LOW,
						RESETN,
						reset,
						fgpa_state,
						write_done,
						data_pending,
						clock_1hz,
						scan_code_ready,
						letter_case_out,
						audio_in_available,
						read_audio_in,
						audio_out_allowed,
						write_audio_out,
						lcd_reset;
	 wire [7:0]		ps2_scan_code,
						ps2_ascii;
	 wire [31:0]	left_channel_audio_in,
						right_channel_audio_in,
						left_channel_audio_out,
						right_channel_audio_out;
	 wire [127:0]	message_in_wire,
						message_out;
																		
	 reg				data_ready;
	 reg [31:0]		sound,
						counter;
	 reg [127:0]	message_in,
						name;
		 
	 assign 			HIGH				= 1;
	 assign 			LOW				= 0;
	 assign 			reset 			= LOW;
	 assign			lcd_reset		= ~KEY[0] | ~KEY[1] | ~KEY[2] | ~KEY[3];
	 assign			fpga_state 		= SW[0];
	 assign 			data_pending 	= SW[1];
	 assign 			RESETN 			= KEY[0];
	 
	// GPIO protocol
	clock_divider_50mhz_1hz clk_divider (
		.in_clock	(CLOCK_50),
		.out_clock 	(clock_1hz)
	);

	initial begin
		name		  = {80'h20202020202020202020, 8'd58, 8'd117, 8'd115, 8'd101, 8'd110, 8'd65};
		data_ready = LOW;
		message_in = LOW;
		counter 	  = 32'b0;
		sound 	  = 32'b0;
	end

	always @(posedge data_pending or posedge write_done) begin
		if (write_done) data_ready = LOW;
		else data_ready = HIGH;
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

	assign LEDR[2] 	= fpga_state ? GPIO[35] : GPIO[34];
	assign LEDR[1]		= write_done;
	assign LEDR[0] 	= GPIO[32];
	assign LEDR[6:3] 	= KEY;


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
		.letter_case		(letter_case_out),
		.scan_code			(ps2_scan_code),
		.ascii_code			(ps2_ascii)
	);
				
	lcd mylcd (
		CLOCK_50,
		lcd_reset,
		scan_code_ready,
		ps2_ascii,
		name,
		message_out,
		LCD_DATA,
		LCD_RW,
		LCD_EN,
		LCD_RS,
		LCD_ON,
		LCD_BLON
	);
	 
	 always @(posedge CLOCK_50) begin
		if (counter == (32'd1250000)) counter <= 32'b0;
		
		if (~write_done) sound <= 32'b0;
		else sound <= sound + 32'd100000000;
		
		counter <= counter+1;
	end

	Audio_Controller Audio_Controller (
		.CLOCK_50						(CLOCK_50),
		.reset							(~RESETN),
		.read_audio_in					(read_audio_in),
		.left_channel_audio_out		(left_channel_audio_out),
		.right_channel_audio_out	(right_channel_audio_out),
		.write_audio_out				(write_audio_out),
		.AUD_ADCDAT						(AUD_ADCDAT),
		.AUD_BCLK						(AUD_BCLK),
		.AUD_ADCLRCK					(AUD_ADCLRCK),
		.AUD_DACLRCK					(AUD_DACLRCK),
		.audio_in_available			(audio_in_available),
		.left_channel_audio_in		(left_channel_audio_in),
		.right_channel_audio_in		(right_channel_audio_in),
		.audio_out_allowed			(audio_out_allowed),
		.AUD_XCK							(AUD_XCK),
		.AUD_DACDAT						(AUD_DACDAT),

	);

	assign read_audio_in					= 1'b1;
	assign left_channel_audio_out		= left_channel_audio_in + sound;
	assign right_channel_audio_out	= right_channel_audio_in + sound;
	assign write_audio_out				= 1'b1;

	always @(negedge KEY[1] or negedge KEY[2] or negedge KEY[3]) begin
		if (~KEY[1]) name = {80'h20202020202020202020, 8'd58, 8'd117, 8'd115, 8'd101, 8'd110, 8'd65};
		else if (~KEY[2]) name = {72'h202020202020202020, 8'd58, 8'd97, 8'd114, 8'd117, 8'd107, 8'd97, 8'd83};
		else if (~KEY[3]) name = {56'h20202020202020, 8'd58, 8'd108, 8'd108, 8'd101, 8'd104, 8'd99, 8'd116, 8'd105, 8'd77};
	end

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

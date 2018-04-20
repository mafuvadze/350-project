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

module skeleton(CLOCK_50, GPIO, LEDR, SW, 	
	VGA_CLK,   														//	VGA Clock
	VGA_HS,															//	VGA H_SYNC
	VGA_VS,															//	VGA V_SYNC
	VGA_BLANK,														//	VGA BLANK
	VGA_SYNC,														//	VGA SYNC
	VGA_R,   														//	VGA Red[9:0]
	VGA_G,	 														//	VGA Green[9:0]
	VGA_B												//	VGA Blue[9:0]
);
    input 			CLOCK_50;
	 input [1:0]	SW;
	 output [17:0]	LEDR;
	 inout [35:0]	GPIO;

     
     	////////////////////////	VGA	////////////////////////////
	 output			VGA_CLK;   				//	VGA Clock
	 output			VGA_HS;					//	VGA H_SYNC
	 output			VGA_VS;					//	VGA V_SYNC
	 output			VGA_BLANK;				//	VGA BLANK
	 output			VGA_SYNC;				//	VGA SYNC
	 output	[7:0]	VGA_R;   				//	VGA Red[9:0]
	 output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
	 output	[7:0]	VGA_B;   				//	VGA Blue[9:0]

     
     
	 wire 			clock,
						reset,
						fgpa_state,
						write_done,
						data_pending;
						
	reg				data_ready;
	 	 
	 assign 			reset = 0;
	 assign			fpga_state = SW[0];
	 assign 			data_pending = SW[1];
	 
	// GPIO protocol
	clock_divider_50mhz_1hz clk_divider (
		.in_clock	(CLOCK_50),
		.out_clock 	(clock)
	);
	
	initial begin
		data_ready = 0;
	end
	
	always @(posedge data_pending or posedge write_done) begin
		if (write_done) data_ready = 0;
		else data_ready = 1;
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
	
	assign LEDR[2] = fpga_state ? GPIO[35] : GPIO[34];
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
    
    

    Reset_Delay			r0	(.iCLK(CLOCK_50),.oRESET(DLY_RST)	);
	 VGA_Audio_PLL 		p1	(.areset(~DLY_RST),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);
    vga_controller3 vga_ctrl(.iRST_n(DLY_RST),
								 .iVGA_CLK(VGA_CLK),
								 .oBLANK_n(VGA_BLANK),
								 .oHS(VGA_HS),
								 .oVS(VGA_VS),
								 .b_data(VGA_B),
								 .g_data(VGA_G),
								 .r_data(VGA_R));
	

endmodule

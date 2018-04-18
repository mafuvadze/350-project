module skeleton(resetn, 
	ps2_clock, ps2_data, 										// ps2 related I/O
	debug_data_in, debug_addr, leds, 						// extra debugging ports
	lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon,// LCD info
	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8,		// seven segements
	CLOCK_50);  													// 50 MHz clock
		


	////////////////////////	PS2	////////////////////////////
	input 			resetn;
	inout 			ps2_data, ps2_clock;	
	input				CLOCK_50;
	
	////////////////////////	LCD and Seven Segment	////////////////////////////
	output 			   lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
	output 	[7:0] 	leds, lcd_data;
	output 	[6:0] 	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;
	output 	[31:0] 	debug_data_in;
	output   [11:0]   debug_addr;
	
	
	wire			 clock;
	wire			 lcd_write_en;
	wire 	[31:0] lcd_write_data;
	wire	[7:0]	 ps2_key_data;
	wire			 ps2_key_pressed;
	wire	[7:0]	 ps2_out;	
	
	// clock divider (by 5, i.e., 10 MHz)
	pll div(CLOCK_50,inclock);
	//assign clock = CLOCK_50;
	
	// divide-by-two 50MHz to 25MHz
	reg clock_25; 
	always @(posedge CLOCK_50)
		clock_25 <= ~clock_25;
	
	assign clock = clock_25; 

	
	// your processor
	processor myprocessor(clock, ~resetn, /*ps2_key_pressed, ps2_out, lcd_write_en, lcd_write_data,*/ debug_data_in, debug_addr);
	
	// keyboard controller
	PS2_Interface myps2(clock, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, ps2_out);
	
	// SAKURA'S CODE
	//convert scan codes to ascii
	reg [7:0] ps2_data_ascii; 
	
	
	always @* begin
	
	case(ps2_out)
	
		8'h1C: ps2_data_ascii <= 8'd97;  //a
		8'h32: ps2_data_ascii <= 8'd98;  //b 
		8'h21: ps2_data_ascii <= 8'd99;  //c
		8'h23: ps2_data_ascii <= 8'd100; //d
		8'h24: ps2_data_ascii <= 8'd101; //e
		8'h2B: ps2_data_ascii <= 8'd102; //f 
		8'h34: ps2_data_ascii <= 8'd103; //g
		8'h33: ps2_data_ascii <= 8'd104; //h
		8'h43: ps2_data_ascii <= 8'd105; //i
		8'h3B: ps2_data_ascii <= 8'd106; //j
		8'h42: ps2_data_ascii <= 8'd107; //k
		8'h4B: ps2_data_ascii <= 8'd108; //l
		8'h3A: ps2_data_ascii <= 8'd109; //m
		8'h31: ps2_data_ascii <= 8'd110; //n
		8'h44: ps2_data_ascii <= 8'd111; //o
		8'h4D: ps2_data_ascii <= 8'd112; //p
		8'h15: ps2_data_ascii <= 8'd113; //q
		8'h2D: ps2_data_ascii <= 8'd114; //r
		8'h1B: ps2_data_ascii <= 8'd115; //s
		8'h2C: ps2_data_ascii <= 8'd116; //t
		8'h3C: ps2_data_ascii <= 8'd117; //u
		8'h2A: ps2_data_ascii <= 8'd118; //v
		8'h1D: ps2_data_ascii <= 8'd119; //w
		8'h22: ps2_data_ascii <= 8'd120; //x
		8'h35: ps2_data_ascii <= 8'd121; //y
		8'h1A: ps2_data_ascii <= 8'd122; //z
		8'h29: ps2_data_ascii <= 8'd32;  //space 
		8'h66: ps2_data_ascii <= 8'd127; //del
		default: ps2_data_ascii <= 8'd32;  //default to space
		
	endcase 
	end
	
	wire [7:0] ps2_to_lcd; 
	assign ps2_to_lcd = ps2_data_ascii; 
	
	
	//change lcd controller from ps2_out to ps2_data_ascii 
		
	// lcd controller
	lcd mylcd(clock, ~resetn, 1'b1, ps2_to_lcd, lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
	
	// example for sending ps2 data to the first two seven segment displays
	Hexadecimal_To_Seven_Segment hex1(ps2_out[3:0], seg1);
	Hexadecimal_To_Seven_Segment hex2(ps2_out[7:4], seg2);
	
	// the other seven segment displays are currently set to 0
	Hexadecimal_To_Seven_Segment hex3(4'b0, seg3);
	Hexadecimal_To_Seven_Segment hex4(4'b0, seg4);
	Hexadecimal_To_Seven_Segment hex5(4'b0, seg5);
	Hexadecimal_To_Seven_Segment hex6(4'b0, seg6);
	Hexadecimal_To_Seven_Segment hex7(4'b0, seg7);
	Hexadecimal_To_Seven_Segment hex8(4'b0, seg8);
	
	// some LEDs that you could use for debugging if you wanted
	//assign leds = 8'b00101011;
	assign leds[0] = ps2_key_pressed; 
							
	
endmodule

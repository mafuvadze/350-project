//module vga_controller(
//   iRST_n,
//   iVGA_CLK,
//   oBLANK_n,
//   PS2KeyboardData,											// PS2 Keyboard data bus
//		PS2KeyboardClk,											// PS2 Keyboard data clock
//		vga_h_sync,													// VGA Output Horizontal Sync signal
//		vga_v_sync,													// VGA Output Vertical Sync signal
//		vga_r,														// Red value for current scanning pixel
//		vga_g,														// Green value for current scanning pixel
//		vga_b	
//   user1_x_long, user1_y_long, user2_x_long, user2_y_long,
//		butt_posedge_in, butt_posedge_out
//);
//
//	input iRST_n;
//	input iVGA_CLK;
//	output reg oBLANK_n;
//	inout		PS2KeyboardData, PS2KeyboardClk;
//	output 	vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b;                     
//	///////// ////                     
//	reg [23:0] bgr_data;
//	wire VGA_CLK_n;
//	wire [7:0] index;
//	wire [23:0] bgr_data_raw;
//	wire cBLANK_n,cHS,cVS,rst;
//////
//
//
//	parameter RAM_size     = 10'd512;				// Size of the RAM
//	parameter write_area   = RAM_size - 10'd2;	// Allowable write area in the RAM (last location used as a null location)
//	parameter char_dim     = 10'd16;					// Dimension of a character (16x16 bits)
//	parameter char_scale_i = 10'd2;					// Initial character scale
//	parameter row_length_i = 10'd18;					// Initial length of a row (number of columns)
//	parameter col_length_i = 10'd29;					// Initial length of a column (number of rows)
//	
//	reg [9:0] char_scale;
//	reg [9:0] row_length;
//	reg [9:0] col_length;
//	reg [9:0] scroll;
//	
//	reg text_red;
//	reg text_green;
//	reg text_blue;
//	
//	wire inDisplayArea;
//	wire [9:0] CounterX;
//	wire [9:0] CounterY;
//	
//	wire [9:0] CounterXDiv;
//	wire [9:0] CounterYDiv; 
//	assign CounterXDiv = CounterX / char_scale;
//	assign CounterYDiv = CounterY / char_scale;
//	
//	wire shouldDraw;
//	assign shouldDraw = CounterXDiv < char_dim * row_length && CounterYDiv < char_dim * col_length;
//	
//	wire [0:255] relativePixel;
//	assign relativePixel = CounterXDiv % char_dim + CounterYDiv % char_dim * char_dim;
//	
//	wire drawCursor;
//	assign drawCursor = read_address == document_pointer && Cursor[relativePixel] && cursor_clk;
//	
//	assign read_address = (CounterXDiv / char_dim + CounterYDiv / char_dim * row_length + scroll * row_length) < RAM_size - 1'b1 ? 
//															(CounterXDiv / char_dim + CounterYDiv / char_dim * row_length + scroll * row_length) :
//															RAM_size - 1'b1;
//	
//	hvsync_generator vgaSyncGen(
//		// Inputs
//		.clk(iVGA_CLK),
//		.reset(Reset),
//		
//		// Outputs
//		.vga_h_sync(vga_h_sync),
//		.vga_v_sync(vga_v_sync),
//		.inDisplayArea(inDisplayArea),
//		.CounterX(CounterX),
//		.CounterY(CounterY)
//	);
//	
//	always @(posedge VGA_clk) begin
//		vga_r <= Red   & inDisplayArea;
//		vga_g <= Green & inDisplayArea;
//		vga_b <= Blue  & inDisplayArea;
//	end
//	
//	wire Red   = shouldDraw && ((~drawCursor && text_red   && toDraw[relativePixel]) || (drawCursor && !text_red) || (drawCursor && text_red && text_green && text_blue));
//	wire Blue  = shouldDraw && ((~drawCursor && text_blue  && toDraw[relativePixel]) || (drawCursor && !text_blue));
//	wire Green = shouldDraw && ((~drawCursor && text_green && toDraw[relativePixel]) || (drawCursor && !text_green));
//	
//	wire [0:255] toDraw;
//	assign toDraw = 	RAM_data == 8'h70 ? Block :
//							RAM_data == 8'h49 ? Period :
//							RAM_data == 8'h41 ? Comma :
//							RAM_data == 8'h52 ? Apost :
//							RAM_data == 8'h16 ? ExlPnt :
//							RAM_data == 8'h1C ? A :
//							RAM_data == 8'h32 ? B :
//							RAM_data == 8'h21 ? C :
//							RAM_data == 8'h23 ? D :
//							RAM_data == 8'h24 ? E :
//							RAM_data == 8'h2B ? F :
//							RAM_data == 8'h34 ? G :
//							RAM_data == 8'h33 ? H :
//							RAM_data == 8'h43 ? I :
//							RAM_data == 8'h3B ? J :
//							RAM_data == 8'h42 ? K :
//							RAM_data == 8'h4B ? L :
//							RAM_data == 8'h3A ? M :
//							RAM_data == 8'h31 ? N :
//							RAM_data == 8'h44 ? O :
//							RAM_data == 8'h4D ? P :
//							RAM_data == 8'h15 ? Q :
//							RAM_data == 8'h2D ? R :
//							RAM_data == 8'h1B ? S :
//							RAM_data == 8'h2C ? T :
//							RAM_data == 8'h3C ? U :
//							RAM_data == 8'h2A ? V :
//							RAM_data == 8'h1D ? W :
//							RAM_data == 8'h22 ? X :
//							RAM_data == 8'h35 ? Y :
//							RAM_data == 8'h1A ? Z :
//							256'd0;
//	
//	parameter [0:255] Cursor = 256'hC000C000C000C000C000C000C000C000C000C000C000C000C000C000C000C000;
//	parameter [0:255] Block  = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
//	parameter [0:255] Period = 256'h0000000000000000000000000000000000000000000000000000E000E000E000;
//	parameter [0:255] Comma  = 256'h000000000000000000000000000000000000000000000000000070007000E000;
//	parameter [0:255] Apost  = 256'h070007000E000000000000000000000000000000000000000000000000000000;
//	parameter [0:255] ExlPnt = 256'hF000F000F000F000F000F000F000F000F000F000F00000000000F000F000F000;
//	parameter [0:255] A      = 256'h00001FE03870387070387038E01CE01CE01CFFFCFFFCE01CE01CE01CE01CE01C;
//	parameter [0:255] B      = 256'h0000FFC0FFF0F078F03CF03CF038FFE0FFE0F038F03CF03CF03CF07CFFF8FFE0;
//	parameter [0:255] C      = 256'h00001FF07FFCF81EF01EE000E000E000E000E000E000E000E01EF01E7FFC1FF0;
//	parameter [0:255] D      = 256'h0000FFE0FFF8F03CF01CF00EF00EF00EF00EF00EF00EF00EF01CF03CFFF8FFE0;
//	parameter [0:255] E      = 256'h0000FFFEFFFEE000E000E000E000FFFEFFFEE000E000E000E000E000FFFEFFFE;
//	parameter [0:255] F      = 256'h0000FFFEFFFEF000F000F000F000FFFEFFFEF000F000F000F000F000F000F000;
//	parameter [0:255] G      = 256'h00003FF07FF8F01EE00EC000C000C000C000C07EC07EC00EC00EF01E7FF83FF0;
//	parameter [0:255] H      = 256'h0000E00EE00EE00EE00EE00EE00EFFFEFFFEE00EE00EE00EE00EE00EE00EE00E;
//	parameter [0:255] I      = 256'h0000FFFCFFFC07800780078007800780078007800780078007800780FFFCFFFC;
//	parameter [0:255] J      = 256'h00003FFC3FFC001C001C001C001C001C001C001CE01CE01CE01CF03C7FF83FF0;
//	parameter [0:255] K      = 256'h0000E00EE00EE01CE038E070E0E0FFC0FFC0E0E0E070E038E01CE00EE00EE00E;
//	parameter [0:255] L      = 256'h0000E000E000E000E000E000E000E000E000E000E000E000E000E000FFFCFFFC;
//	parameter [0:255] M      = 256'h0000F87CFCFCFCFCECDCEFDCE79CE31CE01CE01CE01CE01CE01CE01CE01CE01C;
//	parameter [0:255] N      = 256'h0000F81CF81CEC1CEC1CE61CE61CE31CE31CE31CE19CE19CE0DCE0DCE07CE07C;
//	parameter [0:255] O      = 256'h00003FF07878E01CE01CE01CE01CE01CE01CE01CE01CE01CE01CF03C78783FF0;
//	parameter [0:255] P      = 256'h0000FFC0FFF8F07CF03CF03CF03CF07CFFF8FFC0F000F000F000F000F000F000;
//	parameter [0:255] Q      = 256'h00003FF07878E01CE01CE01CE01CE01CE01CE01CE01CE01CE01CF03C787C0FDE;
//	parameter [0:255] R      = 256'h0000FFF0FFFCF01EF01EF01EF01EFFF0FFC0F0F0F078F03CF03CF01EF01EF01E;
//	parameter [0:255] S      = 256'h00000FF03FFCE01EE00EE00EF0007FF01FFC001EE00EE00EF00E781E3FFC07F8;
//	parameter [0:255] T      = 256'h0000FFFEFFFE0380038003800380038003800380038003800380038003800380;
//	parameter [0:255] U      = 256'h0000E00EE00EE00EE00EE00EE00EE00EE00EE00EE00EE00EE00EE00E783C1FF0;
//	parameter [0:255] V      = 256'h0000E00EF01EF01E783C783C3C783C783C781EF01EF00FE00FE007C003800100;
//	parameter [0:255] W      = 256'h0000E01CE01CE01CE01CE01CE01CE01CE01CE31CE79CEFDCECDCFCFCFCFCF87C;
//	parameter [0:255] X      = 256'h0000F01EF01E78783CF03CF01FE00FC007800FC01FE03CF03CF07878F03CF03C;
//	parameter [0:255] Y      = 256'h0000E00EE00E701C781C3C780FE007C003800380038003800380038003800380;
//	parameter [0:255] Z      = 256'h0000FFFEFFFE001E003C007800F001E003C00F001E003C007800F000FFFEFFFE;
//
//endmodule

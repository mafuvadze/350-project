module vga_controller3(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 background_switch_black,
							 background_switch_white,
							 background_switch_blue,
							 background_switch_red,
							 background_switch_green);

	
input iRST_n;
input iVGA_CLK;
input background_switch_black,
							 background_switch_white,
							 background_switch_blue,
							 background_switch_red,
							 background_switch_green;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Addresss generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDR ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here
	reg [18:0] xCor, yCor;
	reg [15:0] counter;

	wire [15:0] comparator_counter;
	assign comparator_counter = 16'd0;

	integer squareSize = 128;
	integer squareSize_sprite1 = 64;
	integer xSize = 640;
	integer ySize = 550;


initial
begin
	counter <= comparator_counter;
	xCor <= 19'd670; //xSize + squareSize 640 + 256/2 = 640 + 128 = 768 //PREV: 670
	yCor <= 19'd580; //ySize + squareSize 480 + 128 = 608 //PREV: 580
end

always@(posedge iVGA_CLK)
begin
	counter <= counter + 1'd1;
end

wire [7:0] indexInput;
reg [7:0] background_input;
wire isY, isX;
wire isPlayer;

wire background_switch;
assign background_switch = 
	background_switch_black || 
	background_switch_white || 
	background_switch_blue || 
	background_switch_green || 
	background_switch_red;

always @(posedge iVGA_CLK)
begin
	if (background_switch_black)
		background_input <= 8'd1;
	else if (background_switch_white)
		background_input <= 8'd0;
	else if (background_switch_blue)
		background_input <= 8'd0;
	else if (background_switch_green)
		background_input <= 8'd0;
	else if (background_switch_red)
		background_input <= 8'd0;
end
	
assign indexInput = background_switch ? background_input : index;
assign isX = xCor >= (ADDR%xSize + xSize - squareSize) && xCor <= (ADDR%xSize + xSize + squareSize);
assign isY = yCor >= (ADDR/ySize + ySize - squareSize) && yCor <= (ADDR/ySize + ySize + squareSize);
and isS(isPlayer, isX, isY);

//	wordRom wordRom (
//		.address(),
//		.clock(VGA_CLK_n),
//		.q()
//	);
//	characterRom charRom (
//		.address(),
//		.clock(VGA_CLK_n),
//		.q()
//	);

//always @(posedge iVGA_CLK, negedge iRST_n)
//begin
//	if(background_switch)
//		
//	else
//end
	
//////Color table output
img_index	img_index_inst (
	.address ( indexInput ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_raw)
	);	
//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset,
	 ctrl_writeReg,
    ctrl_readRegA,
	 ctrl_readRegB,
	 data_writeReg,
    data_readRegA,
	 data_readRegB
);

   input 				clock,
							ctrl_writeEnable,
							ctrl_reset;
   input [4:0] 		ctrl_writeReg,
							ctrl_readRegA,
							ctrl_readRegB;
   input [31:0] 		data_writeReg;

   output [31:0] 		data_readRegA,
							data_readRegB;
							
	reg [31:0] 			regfile32 [31:0];
	
	assign data_readRegA = regfile32[ctrl_readRegA];
	assign data_readRegB = regfile32[ctrl_readRegB];
	
	always @(posedge clock) begin
      if (ctrl_reset) begin
			 regfile32[0] <= 0;
			 regfile32[1] <= 0;
			 regfile32[2] <= 0;
			 regfile32[3] <= 0;
			 regfile32[4] <= 0;
			 regfile32[5] <= 0;
			 regfile32[6] <= 0;
			 regfile32[7] <= 0;
			 regfile32[8] <= 0;
			 regfile32[9] <= 0;
			 regfile32[10] <= 0;
			 regfile32[11] <= 0;
			 regfile32[12] <= 0;
			 regfile32[13] <= 0;
			 regfile32[14] <= 0;
			 regfile32[15] <= 0;
			 regfile32[16] <= 0;
			 regfile32[17] <= 0;
			 regfile32[18] <= 0;
			 regfile32[19] <= 0;
			 regfile32[20] <= 0;
			 regfile32[21] <= 0;
			 regfile32[22] <= 0;
			 regfile32[23] <= 0;
			 regfile32[24] <= 0;
			 regfile32[25] <= 0;
			 regfile32[26] <= 0;
			 regfile32[27] <= 0;
			 regfile32[28] <= 0;
			 regfile32[29] <= 0;
			 regfile32[30] <= 0;
			 regfile32[31] <= 0;
      end else begin
			if (ctrl_writeEnable & (ctrl_writeReg != 5'b0)) regfile32[ctrl_writeReg] <= data_writeReg;
      end
   end
	
endmodule

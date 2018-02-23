module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
	
	// Wires
	wire [31:0] out_0, out_1, out_2, out_3, out_4, out_5, out_6, out_7, out_8, out_9, out_10, out_11, out_12, out_13, out_14, out_15, out_16, out_17, out_18, out_19, out_20, out_21, out_22, out_23, out_24, out_25, out_26, out_27, out_28, out_29, out_30, out_31;
	wire enable_0, enable_1, enable_2, enable_3, enable_4, enable_5, enable_6, enable_7, enable_8, enable_9, enable_10, enable_11, enable_12, enable_13, enable_14, enable_15, enable_16, enable_17, enable_18, enable_19, enable_20, enable_21, enable_22, enable_23, enable_24, enable_25, enable_26, enable_27, enable_28, enable_29, enable_30, enable_31;
	wire dec_0, dec_1, dec_2, dec_3, dec_4, dec_5, dec_6, dec_7, dec_8, dec_9, dec_10, dec_11, dec_12, dec_13, dec_14, dec_15, dec_16, dec_17, dec_18, dec_19, dec_20, dec_21, dec_22, dec_23, dec_24, dec_25, dec_26, dec_27, dec_28, dec_29, dec_30, dec_31;

   // Code
	decoder_5_32 decoder_a(.out_0(dec_0), .out_1(dec_1), .out_2(dec_2), .out_3(dec_3), .out_4(dec_4), .out_5(dec_5), .out_6(dec_6), .out_7(dec_7), .out_8(dec_8), .out_9(dec_9), .out_10(dec_10), .out_11(dec_11), .out_12(dec_12), .out_13(dec_13), .out_14(dec_14), .out_15(dec_15), .out_16(dec_16), .out_17(dec_17), .out_18(dec_18), .out_19(dec_19), .out_20(dec_20), .out_21(dec_21), .out_22(dec_22), .out_23(dec_23), .out_24(dec_24), .out_25(dec_25), .out_26(dec_26), .out_27(dec_27), .out_28(dec_28), .out_29(dec_29), .out_30(dec_30), .out_31(dec_31), .in_0(ctrl_writeReg[0]), .in_1(ctrl_writeReg[1]), .in_2(ctrl_writeReg[2]), .in_3(ctrl_writeReg[3]), .in_4(ctrl_writeReg[4]));

	and and_0(enable_0, 1'b0, dec_0);
	and and_1(enable_1, ctrl_writeEnable, dec_1);
	and and_2(enable_2, ctrl_writeEnable, dec_2);
	and and_3(enable_3, ctrl_writeEnable, dec_3);
	and and_4(enable_4, ctrl_writeEnable, dec_4);
	and and_5(enable_5, ctrl_writeEnable, dec_5);
	and and_6(enable_6, ctrl_writeEnable, dec_6);
	and and_7(enable_7, ctrl_writeEnable, dec_7);
	and and_8(enable_8, ctrl_writeEnable, dec_8);
	and and_9(enable_9, ctrl_writeEnable, dec_9);
	and and_10(enable_10, ctrl_writeEnable, dec_10);
	and and_11(enable_11, ctrl_writeEnable, dec_11);
	and and_12(enable_12, ctrl_writeEnable, dec_12);
	and and_13(enable_13, ctrl_writeEnable, dec_13);
	and and_14(enable_14, ctrl_writeEnable, dec_14);
	and and_15(enable_15, ctrl_writeEnable, dec_15);
	and and_16(enable_16, ctrl_writeEnable, dec_16);
	and and_17(enable_17, ctrl_writeEnable, dec_17);
	and and_18(enable_18, ctrl_writeEnable, dec_18);
	and and_19(enable_19, ctrl_writeEnable, dec_19);
	and and_20(enable_20, ctrl_writeEnable, dec_20);
	and and_21(enable_21, ctrl_writeEnable, dec_21);
	and and_22(enable_22, ctrl_writeEnable, dec_22);
	and and_23(enable_23, ctrl_writeEnable, dec_23);
	and and_24(enable_24, ctrl_writeEnable, dec_24);
	and and_25(enable_25, ctrl_writeEnable, dec_25);
	and and_26(enable_26, ctrl_writeEnable, dec_26);
	and and_27(enable_27, ctrl_writeEnable, dec_27);
	and and_28(enable_28, ctrl_writeEnable, dec_28);
	and and_29(enable_29, ctrl_writeEnable, dec_29);
	and and_30(enable_30, ctrl_writeEnable, dec_30);
	and and_31(enable_31, ctrl_writeEnable, dec_31);
	
	register reg_0(.data(data_writeReg), .enable(enable_0), .reset(ctrl_reset), .clk(clk), .out(out_0));
	register reg_1(.data(data_writeReg), .enable(enable_1), .reset(ctrl_reset), .clk(clk), .out(out_1));
	register reg_2(.data(data_writeReg), .enable(enable_2), .reset(ctrl_reset), .clk(clk), .out(out_2));
	register reg_3(.data(data_writeReg), .enable(enable_3), .reset(ctrl_reset), .clk(clk), .out(out_3));
	register reg_4(.data(data_writeReg), .enable(enable_4), .reset(ctrl_reset), .clk(clk), .out(out_4));
	register reg_5(.data(data_writeReg), .enable(enable_5), .reset(ctrl_reset), .clk(clk), .out(out_5));
	register reg_6(.data(data_writeReg), .enable(enable_6), .reset(ctrl_reset), .clk(clk), .out(out_6));
	register reg_7(.data(data_writeReg), .enable(enable_7), .reset(ctrl_reset), .clk(clk), .out(out_7));
	register reg_8(.data(data_writeReg), .enable(enable_8), .reset(ctrl_reset), .clk(clk), .out(out_8));
	register reg_9(.data(data_writeReg), .enable(enable_9), .reset(ctrl_reset), .clk(clk), .out(out_9));
	register reg_10(.data(data_writeReg), .enable(enable_10), .reset(ctrl_reset), .clk(clk), .out(out_10));
	register reg_11(.data(data_writeReg), .enable(enable_11), .reset(ctrl_reset), .clk(clk), .out(out_11));
	register reg_12(.data(data_writeReg), .enable(enable_12), .reset(ctrl_reset), .clk(clk), .out(out_12));
	register reg_13(.data(data_writeReg), .enable(enable_13), .reset(ctrl_reset), .clk(clk), .out(out_13));
	register reg_14(.data(data_writeReg), .enable(enable_14), .reset(ctrl_reset), .clk(clk), .out(out_14));
	register reg_15(.data(data_writeReg), .enable(enable_15), .reset(ctrl_reset), .clk(clk), .out(out_15));
	register reg_16(.data(data_writeReg), .enable(enable_16), .reset(ctrl_reset), .clk(clk), .out(out_16));
	register reg_17(.data(data_writeReg), .enable(enable_17), .reset(ctrl_reset), .clk(clk), .out(out_17));
	register reg_18(.data(data_writeReg), .enable(enable_18), .reset(ctrl_reset), .clk(clk), .out(out_18));
	register reg_19(.data(data_writeReg), .enable(enable_19), .reset(ctrl_reset), .clk(clk), .out(out_19));
	register reg_20(.data(data_writeReg), .enable(enable_20), .reset(ctrl_reset), .clk(clk), .out(out_20));
	register reg_21(.data(data_writeReg), .enable(enable_21), .reset(ctrl_reset), .clk(clk), .out(out_21));
	register reg_22(.data(data_writeReg), .enable(enable_22), .reset(ctrl_reset), .clk(clk), .out(out_22));
	register reg_23(.data(data_writeReg), .enable(enable_23), .reset(ctrl_reset), .clk(clk), .out(out_23));
	register reg_24(.data(data_writeReg), .enable(enable_24), .reset(ctrl_reset), .clk(clk), .out(out_24));
	register reg_25(.data(data_writeReg), .enable(enable_25), .reset(ctrl_reset), .clk(clk), .out(out_25));
	register reg_26(.data(data_writeReg), .enable(enable_26), .reset(ctrl_reset), .clk(clk), .out(out_26));
	register reg_27(.data(data_writeReg), .enable(enable_27), .reset(ctrl_reset), .clk(clk), .out(out_27));
	register reg_28(.data(data_writeReg), .enable(enable_28), .reset(ctrl_reset), .clk(clk), .out(out_28));
	register reg_29(.data(data_writeReg), .enable(enable_29), .reset(ctrl_reset), .clk(clk), .out(out_29));
	register reg_30(.data(data_writeReg), .enable(enable_30), .reset(ctrl_reset), .clk(clk), .out(out_30));
	register reg_31(.data(data_writeReg), .enable(enable_31), .reset(ctrl_reset), .clk(clk), .out(out_31));
	
	mux_32 mux_1(.out(data_readRegA), .in_0(out_0), .in_1(out_1), .in_2(out_2), .in_3(out_3), .in_4(out_4), .in_5(out_5), .in_6(out_6), .in_7(out_7), .in_8(out_8), .in_9(out_9), .in_10(out_10), .in_11(out_11), .in_12(out_12), .in_13(out_13), .in_14(out_14), .in_15(out_15), .in_16(out_16), .in_17(out_17), .in_18(out_18), .in_19(out_19), .in_20(out_20), .in_21(out_21), .in_22(out_22), .in_23(out_23), .in_24(out_24), .in_25(out_25), .in_26(out_26), .in_27(out_27), .in_28(out_28), .in_29(out_29), .in_30(out_30), .in_31(out_31), .sel(ctrl_readRegA));
	mux_32 mux_2(.out(data_readRegB), .in_0(out_0), .in_1(out_1), .in_2(out_2), .in_3(out_3), .in_4(out_4), .in_5(out_5), .in_6(out_6), .in_7(out_7), .in_8(out_8), .in_9(out_9), .in_10(out_10), .in_11(out_11), .in_12(out_12), .in_13(out_13), .in_14(out_14), .in_15(out_15), .in_16(out_16), .in_17(out_17), .in_18(out_18), .in_19(out_19), .in_20(out_20), .in_21(out_21), .in_22(out_22), .in_23(out_23), .in_24(out_24), .in_25(out_25), .in_26(out_26), .in_27(out_27), .in_28(out_28), .in_29(out_29), .in_30(out_30), .in_31(out_31), .sel(ctrl_readRegB));
endmodule

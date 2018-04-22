module bcd_converter (
	data,
	bcd
);

	input [7:0] 	data;
	output [7:0] 	bcd;
	
	wire [3:0]		sub_10,
						sub_20,
						sub_30;
	
	wire [7:0]		temp_20,
						temp_10;
	
	assign sub_10 = data - 10;
	assign sub_20 = data - 20;
	assign sub_30 = data - 30;
	
	assign bcd = (data > 29) ? {4'd3, sub_30} : temp_20;
	
	assign temp_20 = (data > 19) ? {4'd2, sub_20} : temp_10;
	assign temp_10 = (data > 9) ? {4'b1, sub_10} : data;

endmodule

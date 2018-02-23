module mult (result, ready, exception, enable, clock, multiplicand, multiplier);

	input [31:0] 	multiplicand,
						multiplier;
	input 			clock,
						enable;
	
	output [31:0] 	result;
	output    		ready,
						exception;
	
   wire [63:0] 	product,
						prev,
						temp3,
						temp4,
						temp5,
						temp8,
						temp9;
	wire [31:0] 	counter,
						cycle,
						temp1,
						temp2,
						sum,
						diff;
	wire        	overflow,
						add,
						one_multiplier,
						one_multiplicand,
						zero_multiplier,
						zero_multiplicand,
						zero_result,
						arithmetic,
						temp6,
						temp7;
		
	register_64 register1 (temp4, ~ready, 1'b0, clock, temp5);		// Holds current product
	register_64 register2 (temp3, ~ready, 1'b0, clock, prev);		// Holds prev value
	shl_register register3 (enable, clock, counter);
	
	genvar c;
	generate
		for (c = 0; c < 31; c = c + 1) begin : cycle_ctrl
			xor xor1 (cycle[c], counter[c], counter[c+1]);
		end
	endgenerate
	
	xor xor2 (cycle[31], counter[31], 1'b0);
	
	sra_64 shift (temp4, temp3);
	comp_32 comp (one_multiplier, gt, 1'b1, multiplier, 32'b1);
	comp_32 comp2 (one_multiplicand, gt, 1'b1, multiplicand, 32'b1);
	comp_32 comp3 (zero_multiplier, gt, 1'b1, multiplier, 32'b0);
	comp_32 comp4 (zero_multiplicand, gt, 1'b1, multiplicand, 32'b0);
	comp_32 comp5 (zero_result, gt, 1'b1, result, 32'b0);

	// Sub/Add
	cla_32 adder (sum, overflow, product[63:32], multiplicand, 1'b0);
	sub_32 subtr (diff, product[63:32], multiplicand);
	
	// Operation control
	xor xor3 (arithmetic, product[0], prev[0]);
	assign add = prev[0];
	
	// Cycle 0
	assign temp3 = cycle[0] ? product : 64'bZ;
	assign product = cycle[0] ? {31'b0, multiplier, 1'b0} : temp5;
						
	// Cycle 1-31
	genvar i;
	generate
		for (i = 1; i < 32; i = i + 1) begin : cycles
			assign temp3 = cycle[i] ? 
								(arithmetic ?
									(add ? {sum, product[31:0]} : {diff, product[31:0]})
									: product)
								: 64'bZ;
		end
	endgenerate
	
	assign exception = (multiplier[31] & multiplicand[31] & result[31]) |
							 (~multiplier[31] & ~multiplicand[31] & result[31]) |
							 (~zero_multiplier & ~zero_multiplicand & zero_result);
	assign ready = cycle[31];
	sra_64 shift2 (temp8, product);
	sra_64 shift3 (temp9, temp8);
	assign result = (one_multiplier | one_multiplicand) ? (one_multiplier ? multiplicand : multiplier) : temp9[31:0];
		
endmodule

module div (result, ready, exception, enable, clock, dividend, divisor);
	
	input [31:0] 	dividend,
						divisor;
	input 			clock,
						enable;
	
	output [31:0] 	result;
	output    		ready,
						exception;
	
   wire [63:0] 	div,
						temp1,
						temp2,
						temp4;
	wire [31:0] 	counter,
						cycle,
						diff,
						divisor_2s_compl,
						dividend_2s_compl,
						answer_2s_compl,
						_divisor,
						_dividend,
						temp3,
						temp5;
	wire        	eq,
						gt,
						neg;
	
	
	register_64 register1 (temp4, ~ready, 1'b0, clock, temp2);		
	register register2 (temp3, ~ready, 1'b0, clock, temp5);
	shl_register register3 (enable, clock, counter);
	
	genvar c;
	generate
		for (c = 0; c < 31; c = c + 1) begin : cycle_ctrl
			xor xor1 (cycle[c], counter[c], counter[c+1]);
		end
	endgenerate
	
	xor xor2 (cycle[31], counter[31], 1'b0);
	
	twos_complement compl (dividend_2s_compl, dividend);
	twos_complement compl2 (divisor_2s_compl, divisor);
	twos_complement compl3 (answer_2s_compl, temp3);
	
	assign _divisor = divisor[31] ? divisor_2s_compl : divisor;
	assign _dividend = dividend[31] ? dividend_2s_compl : dividend;
	
	xor xor3 (neg, divisor[31], dividend[31]);
	
	comp_32 comp (eq, gt, 1'b1, div[63:32], _divisor);
	comp_32 comp2 (exception, _ , 1'b1, divisor, 32'b0);

	sub_32 subtr (diff, div[63:32], _divisor);
	
	// Cycle 0
	assign div = cycle[0] ? {31'b0, _dividend, 1'b0} : temp2;
	assign temp1 = cycle[0] ?
						((gt | eq) ?
							{diff, div[31:0]}
							: div)
						: 64'bZ;
	assign temp3[31] = cycle[0] ? (gt | eq) : temp5[31];

// Cycle 1-31
	genvar i;
	generate
		for (i = 1; i < 32; i = i + 1) begin : cycles
			assign temp1 = cycle[i] ?
						((gt | eq) ?
							{diff, div[31:0]}
							: div)
						: 64'bZ;
			assign temp3[31-i] = cycle[i] ? (gt | eq) : temp5[31-i];
		end
	endgenerate
	
	assign ready = cycle[31];
	assign temp4 = temp1 << 1;
	assign result = neg ? answer_2s_compl : temp3;
	
endmodule

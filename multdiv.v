module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    
	 input [31:0] 	data_operandA,
						data_operandB;
    input 			ctrl_MULT,
						ctrl_DIV,
						clock;

    output [31:0] data_result;
    output 			data_exception,
						data_resultRDY;
	 
	 wire [31:0] 	div_ans,
						mult_ans;
	 wire 			mult_exception,
						div_exception,
						mult_ready,
						div_ready,
						mult,
						div;
	 
	 mult multiply (
						.result(mult_ans),
						.ready(mult_ready),
						.exception(mult_exception),
						.enable(ctrl_MULT),
						.clock(clock),
						.multiplicand(data_operandA),
						.multiplier(data_operandB));
	 
	 div divide (
						.result(div_ans),
						.ready(div_ready),
						.exception(div_exception),
						.enable(ctrl_DIV),
						.clock(clock),
						.dividend(data_operandA),
						.divisor(data_operandB));
						
	assign data_result = mult ? mult_ans : div ? div_ans : mult_ans;
	assign data_exception = mult ? mult_exception : div ? div_exception: mult_exception;
	assign data_resultRDY = mult ? mult_ready : div ? div_ready : mult_ready;	

	//dflipflop(d, clk, clrn, prn, ena, q);
	dflipflop dff1 (1'b1, clock, ~ctrl_DIV, 1'b1, ctrl_MULT, mult);
	dflipflop dff2 (1'b1, clock, ~ctrl_MULT, 1'b1, ctrl_DIV, div);
	
endmodule

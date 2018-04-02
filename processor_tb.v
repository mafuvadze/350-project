`timescale 1 ns / 100 ps
module processor_tb();
   reg clock, reset;
	
	wire [31:0] reg1,
					reg2,
					reg3,
					reg4,
					reg5,
					r31,
					address_imem,
					pc,
					q_imem,
					decode,
					execute,
					memory,
					writeback,
					temp,
					writeReg,
					writeData,
					writeEnable;
	
	skeleton tester (clock, reset);
	
	assign reg1 = tester.my_regfile.regfile32[1];
	assign reg2 = tester.my_regfile.regfile32[2];
	assign reg3 = tester.my_regfile.regfile32[3];
	assign reg4 = tester.my_regfile.regfile32[4];
	assign reg5 = tester.my_regfile.regfile32[5];
	assign r31 	= tester.my_regfile.regfile32[31];
	
	assign address_imem = {20'b0, tester.address_imem};
	assign pc	= tester.my_processor.pc;
	assign q_imem = tester.q_imem;
	assign temp = tester.my_processor.q_dmem;
	assign writeReg = tester.my_processor.ctrl_writeReg;
	assign writeData = tester.my_processor.data_writeReg;
	assign writeEnable = tester.my_processor.ctrl_writeEnable;
	
	assign decode = tester.my_processor.fd_IR;
	assign execute = tester.my_processor.dx_IR;
	assign memory = tester.my_processor.xm_IR;
	assign writeback = tester.my_processor.mw_IR;
	
	initial begin
		clock = 0;
		reset = 0;
		
		#2000 $stop;
	end
   
	always #10 clock = ~clock;

endmodule

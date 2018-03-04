module bypass_logic (
	uses_mx_bypass_regA,
	uses_mx_bypass_regB,
	uses_wx_bypass_regA,
	uses_wx_bypass_regB,
	execute_bypass_dataA,
	execute_bypass_dataB,
	execute_regA,
	execute_regB,
	memory_rd,
	memory_data,
	writeback_rd,
	writeback_data
);
 input [31:0]  memory_data,
					writeback_data;
 input [4:0]   execute_regA,
					execute_regB,
					memory_rd,
					writeback_rd;
 
 output [31:0] execute_bypass_dataA,
					execute_bypass_dataB;
 output     	uses_mx_bypass_regA,
					uses_mx_bypass_regB,
					uses_wx_bypass_regA,
					uses_wx_bypass_regB;
 
 wire [31:0]   execute_regA_32,
					execute_regB_32,
					memory_rd_32,
					writeback_rd_32,
					mx_bypass_dataA,
					mx_bypass_dataB,
					wx_bypass_dataA,
					wx_bypass_dataB;
 wire     		uses_wx_bypass,
					uses_mx_bypass,
					HIGH;
 
 assign HIGH				  = 1'b1;
 assign execute_regA_32   = {27'b0, execute_regA};
 assign execute_regB_32   = {27'b0, execute_regB};
 assign memory_rd_32  	  = {27'b0, memory_rd};
 assign writeback_rd_32   = {27'b0, writeback_rd};
       
 comp_32 xm_A (
  .eq  (uses_mx_bypass_regA),
  .enable(HIGH),
  .in_0  (execute_regA_32),
  .in_1  (memory_rd_32)
 );
 
 comp_32 xm_B (
  .eq  (uses_mx_bypass_regB),
  .enable(HIGH),
  .in_0  (execute_regB_32),
  .in_1  (memory_rd_32)
 );
 
 comp_32 xw_A (
  .eq  (uses_wx_bypass_regA),
  .enable(HIGH),
  .in_0  (execute_regA_32),
  .in_1  (writeback_rd_32)
 );
 
 comp_32 xw_B (
  .eq  (uses_wx_bypass_regB),
  .enable(HIGH),
  .in_0  (execute_regB_32),
  .in_1  (writeback_rd_32)
 );
  
 assign uses_wx_bypass  = uses_wx_bypass_regA | uses_wx_bypass_regB;
 assign uses_mx_bypass  = uses_mx_bypass_regA | uses_mx_bypass_regB;
 
 assign wx_bypass_dataA  = uses_wx_bypass_regA ? writeback_data : 32'bZ;
 assign wx_bypass_dataB  = uses_wx_bypass_regB ? writeback_data : 32'bZ;
 assign mx_bypass_dataA  = uses_mx_bypass_regA ? memory_data : 32'bZ;
 assign mx_bypass_dataB  = uses_mx_bypass_regB ? memory_data : 32'bZ;
 
 assign execute_bypass_dataA = uses_mx_bypass ? mx_bypass_dataA : wx_bypass_dataA;
 assign execute_bypass_dataB = uses_mx_bypass ? mx_bypass_dataB : wx_bypass_dataB;
 
endmodule


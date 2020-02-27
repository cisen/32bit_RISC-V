module tb_top;
	reg  CLK;
	reg  RSTn;
	wire overflow;

initial
 	begin
		CLK <= 0;
		forever #10 CLK <= ~CLK;
	end
initial 
 	begin
		RSTn <= 0;
		#60
		RSTn <= 1;
		#3
		$readmemh("D:/Project/verilog_pro/project_module/32_RISC-V/test_case/riscv.mif",top_inst.IMEM.mem0.memory);
	end

top_riscv top_inst(	.CLK(CLK),
					.RSTn(RSTn),
					.overflow(overflow));


endmodule
module top_riscv(
	input 	CLK,
	input 	RSTn,
	output 	overflow
);

wire 		wire_BrEn;
wire [31:0] wire_BrAddr;
wire [31:0] wire_PC;
wire 		wire_FetStall;
wire [31:0] wire_INST;
wire [31:0] wire_rs1;
wire [31:0] wire_rs2;
wire [31:0] wire_rs11;
wire [31:0] wire_rs21;
wire [31:0] wire_Imm;
wire [31:0] wire_rd;
wire [31:0] wire_Rdata;
wire [ 2:0] wire_ImmOp;	
wire 		wire_RegWen;		
wire 		wire_ComSig;		
wire 		wire_Imm_mux_Sel;
wire 		wire_Br_mux_Sel;
wire 		wire_AluSig;		
wire 		wire_Rd_mux_Sel;
wire 		wire_MemOp;		
wire 		wire_MemStall;




imm_gen imm_gen_inst (	.opcode		(wire_ImmOp		),
						.inst 		(wire_INST		),
						.imm 		(wire_Imm 		));
compare compare_inst (	.RSTn		(RSTn 			),
						.rs1		(wire_rs1 		),
						.rs2		(wire_rs2 		),
						.Com_op		(wire_ComSig	),
						.Br_en 		(wire_BrEn 		));
alu alu_inst (	.rs1		(wire_rs11 		),
				.rs2		(wire_rs21 		),
				.op 		(wire_AluSig 	),
				.rd 		(wire_rd 		),
				.overflow 	(overflow 		));
memory_wr DMEM (.CLK 		(CLK 			),   
				.RSTn 		(RSTn 			),  
				.stall 		(wire_MemStall 	), 
				.opcode 	(wire_MemOp 	),
				.RWaddr 	(wire_rd 		),
				.Wdata 		(wire_rs2 		), 
				.Rdata 		(wire_Rdata 	));
memory_wr IMEM (.CLK 		(CLK 			),   
				.RSTn 		(RSTn 			),  
				.stall 		(wire_FetStall 	), 
				.opcode 	(3'b010 		),
				.RWaddr 	(wire_PC[11:0] 	),
				.Wdata 		(32'h0 			), 
				.Rdata 		(wire_INST 		));
regfile regfile_inst (	.CLK 		(CLK 				),
						.RSTn 		(RSTn 				),
						.stall 		(0 					),
						.ren 		(1	 				),  
						.wen 		(wire_RegWen 		),  
						.wadd 		(wire_INST[11:7] 	), 
						.wdata 		(wire_BrAddr 		),
						.radd1 		(wire_INST[19:15] 	),
						.rs1 		(wire_rs1 			),  
						.radd2 		(wire_INST[24:20] 	),
						.rs2 		(wire_rs2 			));
fetch fetch_inst (	.CLK 			(CLK 				),
					.RSTn 			(RSTn 				),
					.stall 			(wire_FetStall 		),
					.br_en 			(wire_BrEn 			), 
					.br_addr 		(wire_BrAddr 		),
					.PC 			(wire_PC 			));
mux2to1 Imm_mux (	.a 			(wire_Imm 				),
					.b 			(wire_rs2 				),
					.sel 		(wire_Imm_mux_Sel 		),
					.out 		(wire_rs21 				));
mux2to1 Br_mux (	.a 			(wire_BrAddr 			),
					.b 			(wire_rs1 				),
					.sel 		(wire_Br_mux_Sel 		),
					.out 		(wire_rs11 				));
mux2to1 Rd_mux (	.a 			(wire_Rdata 			),
					.b 			(wire_rd 				),
					.sel 		(wire_Rd_mux_Sel 		),
					.out 		(wire_BrAddr 			));
decode decode_inst(	.CLK 			(CLK 					),
					.RSTn 			(RSTn 					),
					.INST 			(wire_INST 				),       
					.ImmOp 			(wire_ImmOp 			),      
					.RegWen 		(wire_RegWen 			),     
					.ComSig 		(wire_ComSig 			),     
					.AluSig 		(wire_AluSig 			),     
					.MemOp 			(wire_MemOp 			),      
					.MemStall 		(wire_MemStall 			),   
					.FetStall 		(wire_FetStall 			),   
					.Imm_mux_Sel 	(wire_Imm_mux_Sel 		),
					.Br_mux_Sel 	(wire_Br_mux_Sel 		), 
					.Rd_mux_Sel 	(wire_Rd_mux_Sel 		));

endmodule
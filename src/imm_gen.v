//****************Immediate expansion*****************//
module imm_gen(
	input 		[ 2:0] opcode,
	input 		[31:0] inst,
	output reg 	[31:0] imm
);

localparam IMM_EX0 = 3'b000;//R-type shamt extend:inst[24:20]
localparam IMM_EX1 = 3'b001;//I-type:Imm[11:0](inst[31:20])/offset32[11:0](inst[31:20])
localparam IMM_EX2 = 3'b010;//S-type:offset32=inst[31:25]+inst[11:7]
localparam IMM_EX3 = 3'b011;//B-type:offset32=inst[31:25]+inst[11:7]
localparam IMM_EX4 = 3'b100;//U-type:inst[31:12]+12'h000

wire [24:0] inst_imm;
assign inst_imm = inst[31:7];//31_______7
                      		 //24_______0


initial
 	begin
		case(opcode)
			IMM_EX0 :
			 	begin
					imm <= {27'b0,inst_imm[17:13]};
				end
			IMM_EX1 :
			 	begin
					if (inst_imm[24] == 1)
						imm <= {20'hf_ffff,inst_imm[24:13]};
					else
						imm <= {20'b0,inst_imm[24:13]};
				end
			IMM_EX2 :
			 	begin
					if (inst_imm[24] == 1)
						imm <= {20'hf_ffff,inst_imm[24:18]};
					else
						imm <= {20'b0,inst_imm[24:18]};
				end
			IMM_EX3 :
			 	begin
					if (inst_imm[24] == 1)
						imm <= {19'h7_ffff,inst_imm[24],inst_imm[0],inst_imm[23:18],inst_imm[4:1],1'b0};
					else
						imm <= {19'b0,inst_imm[24],inst_imm[0],inst_imm[23:18],inst_imm[4:1],1'b0};
				end
			IMM_EX4 :
			 	begin
					imm <= {inst_imm[24:5],12'h000};
				end
			default :imm <= 0;
		endcase
	end
endmodule

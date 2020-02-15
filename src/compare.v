//******************Jump judgment******************//
module compare(
	input 				RSTn,
	input 		[31:0] 	rs1,
	input 		[31:0] 	rs2,
	input 		[ 2:0] 	Com_op,
	output reg 			Br_en
);

localparam BEQ  = 3'b000;//rs1=rs2,jump to pc+offset32
localparam BNE  = 3'b001;//rs1!=rs2,jump to pc+offset32
localparam BLT  = 3'b010;//rs1<rs2(signed),jump to pc+offset32
localparam BLTU = 3'b011;//rs1<rs2(unsigned),jump to pc+offset32
localparam BGE  = 3'b100;//rs1>rs2(signed),jump to pc+offset32
localparam BGEU = 3'b101;//rs1>rs2(unsigned),jump to pc+offset32

//*********************Main*******************//
always @(*) 
begin
	if (!RSTn) 
		begin
			Br_en <= 0;
		end
	else 
		begin
			case(Com_op)
				BEQ  :
				 	begin
						if (rs1 == rs2)
							Br_en <= 1;
						else
							Br_en <= 0;
					end
				BNE  :
				 	begin
						if (rs1 != rs2)
							Br_en <= 1;
						else
							Br_en <= 0;
					end
				BLT  :
				 	begin
						if ((rs1[31] == 1) && (rs2[31] == 0))
							Br_en <= 1;
						else if ((rs1[31] == 0) && (rs2[31] == 1))
							Br_en <= 0;
						else if ((rs2[31] == 1) && (rs1[31] == 1))
							Br_en <= (rs1 < rs2) ? 1 : 0;
						else 
							Br_en <= (rs1 < rs2) ? 1 : 0;
					end
				BLTU :
				 	begin
						if (rs1 < rs2)
							Br_en <= 1;
						else
							Br_en <= 0;
					end
				BGE  :
				 	begin
						if ((rs1[31] == 1) && (rs2[31] == 0))
							Br_en <= 0;
						else if ((rs1[31] == 0) && (rs2[31] == 1))
							Br_en <= 1;
						else if ((rs2[31] == 1) && (rs1[31] == 1))
							Br_en <= (rs1 >= rs2) ? 1 : 0;
						else 
							Br_en <= (rs1 >= rs2) ? 1 : 0;
					end
				BGEU :
				 	begin
						if (rs1 >= rs2)
							Br_en <= 1;
						else 
							Br_en <= 0;
					end
				default:Br_en <= 0;
			endcase
		end
end
endmodule
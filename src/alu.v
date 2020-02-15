//*****************ALU module****************//
module alu#(
	parameter DATAWIDTH = 32
)
(
	input 	[ DATAWIDTH - 1 : 0 ] 	rs1,
	input 	[ DATAWIDTH - 1 : 0 ] 	rs2,
	input 	[ 3:0] 					op,
	output 	reg [ DATAWIDTH - 1 : 0 ] 	rd,
	output 							overflow
);

//*************opcode defination*************//
localparam SLL  = 4'b0000;//rd=rs1<<rs2
localparam SrL  = 4'b0001;//rd=rs1>>rs2
localparam SrA  = 4'b0010;//rd=rs1>>rs2(arithmetic)
localparam add  = 4'b0011;//rd=rs1+rs2
localparam Sub  = 4'b0100;//rd=rs1-rs2
localparam Lui  = 4'b0101;//rd={20 bit Imm,12'd0}
localparam Slt  = 4'b0110;//rd=(signed rs1 < signed rs2)?1:0
localparam Sltu = 4'b0111;//rd=(unsigned rs1 < unsigned rs2)?1:0
localparam Xor  = 4'b1000;//rd=rs1^rs2
localparam Or   = 4'b1001;//rd=rs1|rs2
localparam And  = 4'b1010;//rd=rs1&rs2
localparam Mul  = 4'b1011;//rd=(rs1*rs2)[31:0]

wire signed [ DATAWIDTH - 1 :0 ] signed_rs1;
wire signed [ DATAWIDTH - 1 :0 ] signed_rs2;
reg [63:0] rs_sra;

assign signed_rs1 = rs1;
assign signed_rs2 = rs2;
assign overflow = rd[32];

//*********************Main*******************//
initial
 	begin
		case(op)
		SLL :		rd <= rs1 << rs2;
		SrL :		rd <= rs1 >> rs2[4:0];
		SrA :		if (rs1[31] == 1)
					 	begin
							rs_sra <= {32'hffff_ffff,rs1[31:0]};
							rd <= rs_sra >> rs2[4:0];
						end
					else 
						begin
							rd <= rs1 >> rs2[4:0];
						end
		add :		rd <= rs1 + rs2;
		Sub :		rd <= rs1 - rs2;
		Lui :		rd <= { rs2[31:12],12'h000 };
		Slt :		rd <= ( signed_rs1 < signed_rs2 ) ? 1 : 0;
		Sltu: 		rd <= ( rs1 < rs2 ) ? 1 : 0;
		Xor :		rd <= rs1 ^ rs2;
		Or  :		rd <= rs1 | rs2;
		And :		rd <= rs1 & rs2;
		Mul :		rd <= rs1 * rs2;
		default:	rd <= rs1 + rs2;
		endcase
	end

endmodule
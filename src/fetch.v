//**************Fetch instruction address*************//
module fetch(
	input 			CLK,
	input 			RSTn,
	input 			stall,
	input 			br_en,  //jump enable
	input  [31:0] 	br_addr,//jump address
	
	output [31:0] 	PC,     //final address
	output [31:0]   PC_Brmux
);

reg [31:0] PC_reg;//pc address
reg [31:0] PC_Brmux_reg;

always @(posedge CLK or negedge RSTn)
begin
	if (!RSTn) 
		begin
			PC_reg <= 0;
			PC_Brmux_reg <= 0;		
		end
	else  if (!stall)
		begin
			PC_reg <= PC_reg + 3'b100;
			PC_Brmux_reg <= PC_reg;	
		end
	else 
	 	begin
			PC_reg <= PC_reg;
		end
end

assign PC = br_en ? br_addr : PC_reg;
assign PC_Brmux = PC_Brmux_reg;

endmodule
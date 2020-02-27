//**************registers module**************//
module regfile(
	input 				CLK,
	input 				RSTn,
	input 				stall,
	
	input 				ren,   //read enable
	input 				wen,   //wirte enable
	
	input 		[ 4:0] 	wadd,  //wirte data address
	input 		[31:0] 	wdata, //wirte data
	input 		[ 4:0] 	radd1, //read data address
	input 		[ 4:0] 	radd2,
	
	output reg 	[31:0] 	rs1,   //read operands
	output reg 	[31:0] 	rs2
);

reg [31:0] MEM [31:0];    //registers
integer i;

initial
 	begin
		MEM[0] <= 0;
	end

always @ ( posedge CLK or negedge RSTn )
begin
	if (!RSTn)
		begin
			for ( i = 0; i < 32; i = i + 1 )
				MEM [i] <= 0;  //initialization
		end
	else
	 	begin
			if (stall)
			 	begin
					for (i = 0; i < 32; i = i+1)
						MEM[i] <= MEM[i];
				end
			else 
				begin
					if (wen)
						MEM [wadd] <= wdata;//wirte to MEM
				end
		end
		
end

always @ ( posedge CLK or negedge RSTn )  
 	begin
		if (ren)
		 	begin
				rs1 <= MEM[radd1];
				rs2 <= MEM[radd2];
			end
		else 
			begin
				rs1 <= 0;
				rs2 <= 0;
			end
	end

endmodule




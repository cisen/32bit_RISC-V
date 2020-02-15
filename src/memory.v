//****************memory module***************//
module memory(
	input 				CLK,  //clock
	input 				RSTn, //reset,when 0,all memory clear
	input 				CEN,  //chip enable,active low
	input 				WEN,  //write enable,active low 
	input 		[31:0] 	BWEN, //bit write enable
	input 		[ 9:0] 	A,    //read or write address
	input 		[31:0] 	D,    //write data
	output reg 	[31:0] 	Q     //read data
);

reg [31:0] memory[0:1023];    //4kb=1024*32bit

//********************Main*******************//
integer i;
always @(posedge CLK or negedge RSTn) 
begin
	if (!RSTn) 
		begin
			for (i = 0;i < 1024; i = i + 1)
				memory[i] <= 0;
		end
	else if (CEN && (!WEN))   //write with BWEN
		begin
			for (i = 0;i < 1024; i = i + 1)
				memory[A][i] <= BWEN [i] ? D[i] : memory[A][i];
				//when BWEN[i] 1,memory change;when 0,do not change
		end
	else if (CEN && WEN)
		begin
			Q <= memory[A];
		end
	else 
		begin
			for (i = 0;i < 1024; i = i + 1)
				memory[i] <= memory[i];
		end
end

endmodule
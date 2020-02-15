module mux2to1(
	input 	[31:0] 	a,
	input 	[31:0]	b,
	input 			sel,
	output 	[31:0] 	out
);

assign out = sel ? a : b;
endmodule
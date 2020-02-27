//***********memory write and read module**********//
module memory_wr(
	input 				CLK,   //clock
	input 				RSTn,  //reset,active low,all memory clear
	input 				stall, //stall, when 1, no operation
	input 		[ 2:0] 	opcode,//read and write operation type
	input 		[11:0] 	RWaddr,//address
	input 		[31:0] 	Wdata, //write data
	output reg 	[31:0]	Rdata  //read data from memory
);

//****************opcode defination****************//
localparam LB   = 3'b000;//load byte(8bit),sign bit extension to 32bit
localparam LHW  = 3'b001;//load half word(16bit),sign bit extension to 32bit
localparam LW   = 3'b010;//load word(32bit)
localparam SB   = 3'b011;//store low 8bit
localparam SHW  = 3'b100;//store low 16bit
localparam SW   = 3'b101;//store word
localparam LBU  = 3'b110;//load byte(8bit unsigned),0 extension
localparam LHWU = 3'b111;//load half word(16bit unsigned),0 extension

//*********************interface********************//
//cen
reg 		cen0;
reg 		cen1;
reg 		cen2;
reg 		cen3;

reg 		wr;

reg [31:0] bwen;

reg [31:0] wdata;

//rdata
reg  [31:0] rdata_reg;
wire [31:0] rdata0;
wire [31:0] rdata1;
wire [31:0] rdata2;
wire [31:0] rdata3;



//**********************Main**********************//
//cen
always @(posedge CLK or negedge RSTn) 	//mem0 : 0000_0000_0000 - 0011_1111_1111
begin 									//mem1 : 0100_0000_0000 - 0111_1111_1111
	if (stall) 							//mem2 : 1000_0000_0000 - 1011_1111_1111
		begin 							//mem3 : 1100_0000_0000 - 1111_1111_1111
			cen0 <= 0;
			cen1 <= 0;
			cen2 <= 0;
			cen3 <= 0;
		end
	else  
		begin
			case(RWaddr[11:10])
				2'b00:	cen0 <= 1;
				2'b01:	cen1 <= 1;
				2'b10:	cen2 <= 1;
				2'b11:	cen3 <= 1;
			endcase
		end
end
//assign cen0 = (RWaddr[11:10] = 2'b00) ? 1 : 0;
//assign cen1 = (RWaddr[11:10] = 2'b01) ? 1 : 0;
//assign cen2 = (RWaddr[11:10] = 2'b10) ? 1 : 0;
//assign cen3 = (RWaddr[11:10] = 2'b11) ? 1 : 0;

//rdata
always @(posedge CLK or negedge RSTn)   //4to1 mux controlled by Rwaddr[11:10] and handling rdata_wire0-3
  begin
    case(RWaddr[11:10])
    2'b00:  rdata_reg <= rdata0;
    2'b01:  rdata_reg <= rdata1;
    2'b10:  rdata_reg <= rdata2;
    2'b11:  rdata_reg <= rdata3;
    endcase
  end
//assign rdata_reg = (RWaddr[11:10] == 2'b00) ? rdata0 : 0;
//assign rdata_reg = (RWaddr[11:10] == 2'b01) ? rdata1 : 0;
//assign rdata_reg = (RWaddr[11:10] == 2'b10) ? rdata2 : 0;
//assign rdata_reg = (RWaddr[11:10] == 2'b11) ? rdata3 : 0;

always @(posedge CLK or negedge RSTn) 
 	begin
		case(opcode)
			LB   :
			 	begin
					case(RWaddr[1:0])
          				2'b00:
          				   	begin 
          				     	if(rdata_reg[7]==1'b1)
          				     	begin
          				       		Rdata = {25'b1111_1111_1111_1111_1111_1111_1,rdata_reg[6:0]};
          				     	end
          				     	else
          				       		Rdata = {25'b0000_0000_0000_0000_0000_0000_0,rdata_reg[6:0]}; 
          				   	end
          				2'b01:
          				   	begin 
          				   	  	if(rdata_reg[15]==1'b1)
          				   	  	  	Rdata = {25'b1111_1111_1111_1111_1111_1111_1,rdata_reg[14:8]};
          				   	  	else
          				   	  	  	Rdata = {25'b0000_0000_0000_0000_0000_0000_0,rdata_reg[14:8]}; 
          				   	end             
          				2'b10:
          				   	begin 
          				   	  	if(rdata_reg[23]==1'b1)
          				   	  	  	Rdata = {25'b1111_1111_1111_1111_1111_1111_1,rdata_reg[22:16]};
          				   	  	else
          				   	  	  	Rdata = {25'b0000_0000_0000_0000_0000_0000_0,rdata_reg[22:16]}; 
          				   	end
          				2'b11:
          				   	begin 
          				   	  	if(rdata_reg[31]==1'b1)
          				   	  	  	Rdata = {25'b1111_1111_1111_1111_1111_1111_1,rdata_reg[30:24]};
          				   	  	else
          				   	  	  	Rdata = {25'b0000_0000_0000_0000_0000_0000_0,rdata_reg[30:24]}; 
          				   	end          
					endcase
				end
			LBU  :
			 	begin
					case(RWaddr[1:0])
          				2'b00:
          				   	begin 
          				   	  	Rdata = {24'b0000_0000_0000_0000_0000_0000,rdata_reg[7:0]}; 
          				   	end
          				2'b01:
          				   	begin 
          				   	  	Rdata = {24'b0000_0000_0000_0000_0000_0000,rdata_reg[15:8]}; 
          				   	end             
          				2'b10:
          				   	begin 
          				   	  	Rdata = {24'b0000_0000_0000_0000_0000_0000,rdata_reg[23:16]}; 
          				   	end
          				2'b11:
          				   	begin 
          				   	  	Rdata = {24'b0000_0000_0000_0000_0000_0000,rdata_reg[31:24]}; 
          				   	end
          			endcase	   	
				end
			LHW  :
			 	begin
					case(RWaddr[1])
          				1'b0:
          				   	begin 
          				   	  	if(rdata_reg[15]==1'b1)
          				   	  	  	Rdata = {17'b1111_1111_1111_1111_1,rdata_reg[14:0]};
          				   	  	else
          				   	  	  	Rdata = {17'b0000_0000_0000_0000_0,rdata_reg[14:0]}; 
          				   	end          
          				1'b1:
          				   	begin 
          				   	  	if(rdata_reg[31]==1'b1)
          				   	  	  	Rdata = {17'b1111_1111_1111_1111_1,rdata_reg[30:16]};
          				   	  	else
          				   	  	  	Rdata = {17'b0000_0000_0000_0000_0,rdata_reg[30:16]}; 
          				   	end            
        			endcase
				end
			LHWU :
			 	begin
					case(RWaddr[1])
          				1'b0:
          				   	begin 
          				   	  	Rdata = {16'b0000_0000_0000_0000,rdata_reg[15:0]}; 
          				   	end          
          				1'b1:
          				   	begin 
          				   	  	Rdata = {16'b0000_0000_0000_0000,rdata_reg[31:16]}; 
          				   	end            
        			endcase
				end
			LW  :
			 	begin
					Rdata = rdata_reg;
				end
			default:Rdata = 0;
		endcase
	end


always @(posedge CLK or negedge RSTn) 
 	begin
		case(opcode)
			SB  :
				begin
					wr <= 0;        
        			case(RWaddr[1:0])
        			  	2'b00:
        			  	  	begin
        			  	  	  	wdata <= Wdata;
        			  	  	  	bwen <= 32'h000000ff;
        			  	  	end 
        			  	2'b01:
        			  	  	begin
        			  	  	  	wdata <= {Wdata[31:24],Wdata[23:16],Wdata[7:0],Wdata[15:8]};
        			  	  	  	bwen <= 32'h0000ff00;
        			  	  	end                       
        			  	2'b10:
        			  	  	begin
        			  	  	  	wdata <= {Wdata[31:24],Wdata[7:0],Wdata[23:16],Wdata[15:8]};
        			  	  	  	bwen <= 32'h00ff0000;
        			  	  	end           
        			  	2'b11:
        			  	  	begin
        			  	  	  	wdata <= {Wdata[7:0],Wdata[31:24],Wdata[23:16],Wdata[15:8]};
        			  	  	  	bwen <= 32'hff000000;
        			  	  	end  
        			endcase  
				end
			SHW :
			 	begin
					wr <= 0;
        	 		case(RWaddr[1])
        	   			1'b0:
        	     			begin
        	       				wdata <= Wdata;
               					bwen <= 32'h0000ffff;
             				end
           				1'b1:
             				begin
               					wdata <= {Wdata[15:0],Wdata[31:16]};
               					bwen <= 32'hffff0000;
             				end
         			endcase
				end
			SW  :
		 		begin
					wr <= 0;
         			wdata <= Wdata;
         			bwen <= 32'hffffffff;
				end
			LB 	:
       			begin
       			  	wr <= 1;
       			  	wdata <= Wdata;
       			  	bwen <= 32'h00000000;
       			end
     		LHW:
     		  	begin
     		  	  	wr <= 1;
     		  	  	wdata <= Wdata;
     		  	  	bwen <= 32'h00000000;
     		  	end        
     		LW:
     		  	begin
     		  	  	wr <= 1;
     		  	  	wdata <= Wdata;
     		  	  	bwen <= 32'h00000000;
     		  	end
     		LBU:
     		  	begin
     		  	  	wr <= 1;
     		  	  	wdata <= Wdata;
     		  	  	bwen <= 32'h00000000;
     		  	end
     		LHWU: 
     		  	begin 
     		  	  	wr <= 1;
     		  	  	wdata <= Wdata;
     		  	  	bwen <= 32'h00000000;
     		  	end	
		endcase
	end





memory mem0(.CLK(CLK),.RSTn(RSTn),.CEN(cen0),.WEN(wr),.BWEN(bwen),.A(RWaddr[9:0]),.D(wdata),.Q(rdata0));
memory mem1(.CLK(CLK),.RSTn(RSTn),.CEN(cen1),.WEN(wr),.BWEN(bwen),.A(RWaddr[9:0]),.D(wdata),.Q(rdata1));
memory mem2(.CLK(CLK),.RSTn(RSTn),.CEN(cen2),.WEN(wr),.BWEN(bwen),.A(RWaddr[9:0]),.D(wdata),.Q(rdata2));
memory mem3(.CLK(CLK),.RSTn(RSTn),.CEN(cen3),.WEN(wr),.BWEN(bwen),.A(RWaddr[9:0]),.D(wdata),.Q(rdata3));

endmodule
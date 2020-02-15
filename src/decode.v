//************************decode************************//
module decode(
	input 				CLK,
	input 				RSTn,
	input  	   [31:0] 	INST,        //instruction
	output reg [ 2:0] 	ImmOp,       //control ImmGen module
	output reg 			RegWen,      //control regfile module
	output reg [ 2:0] 	ComSig,      //control compare module
	output reg [ 3:0] 	AluSig,      //control alu module
	output reg [ 2:0] 	MemOp,       //control mem_wr(DMEM) module
	output reg 			MemStall,    //control mem_wr(DMEN) module stall signal 
	output reg 			FetStall,    //control fetch module stall signal
	output reg 			Imm_mux_Sel, //control rs2 & imm mux
	output reg 			Br_mux_Sel,  //control rs1 & PC mux
	output reg 			Rd_mux_Sel   //control rd & Rdata mux

);


//*******************instruction Op def****************//
localparam Rtype  = 7'b0110011;
localparam Itype1 = 7'b0010011;
localparam Itype2 = 7'b0000011;
localparam Stype  = 7'b0100011;
localparam Btype  = 7'b1100011;
localparam Utype  = 7'b0110111;


//**********************Funct3 def********************//
localparam Funct3_0 = 3'b000;//Rtype add mul sub;	Itype1 addi;     	Itype2 lb; Stype sb; 	Btype beq  
localparam Funct3_1 = 3'b001;//Rtype sll ;       	Itype1 Slli;     	Itype2 lh; Stype sh; 	Btype bne
localparam Funct3_2 = 3'b010;//Rtype slt;        	Itype1 slti;     	Itype2 lw; Stype sw; 	
localparam Funct3_3 = 3'b011;//Rtype sltu;       	Itype1 sltiu;	 						 	
localparam Funct3_4 = 3'b100;//Rtype xor;        	Itype1 xori;     	Itype2 lbu;          	Btype blt
localparam Funct3_5 = 3'b101;//Rtype sra srl;    	Itype1 srai srli;	Itype2 lhu;          	Btype bge 
localparam Funct3_6 = 3'b110;//Rtype or;         	Itype1 ori;                           	 	Btype bltu
localparam Funct3_7 = 3'b111;//Rtype and;        	Itype1 addi;                          	 	Btype bgeu     


//**********************Funct7 def********************//
localparam Funct7_0 = 7'b0000000;
localparam Funct7_1 = 7'b0000001;
localparam Funct7_2 = 7'b0100000;


reg FetStall1;
reg FetStall2;


//************************Main************************//
always @(posedge CLK or negedge RSTn) 
begin
	if (!RSTn) 
		begin
			FetStall2 <= 0;		
		end
	else 
		begin
			FetStall2 <= FetStall1;	
		end
end

always @(posedge CLK or negedge RSTn) 
begin
	if (!RSTn) 
		begin
			FetStall <= 0;		
		end
	else if (FetStall1 == 1) 
		begin
			FetStall <= (FetStall2 == 0) ? 1 : 0;
		end
	else
		FetStall <= 0;
end


always@(posedge CLK or negedge RSTn)
  	begin
  		if (!RSTn)
  			FetStall1 <=1'b0;
  		else
  			begin
  				case(INST[6:0])
  	  				Rtype :
  	    				begin
  	      					case(INST[14:12])
  	        					Funct3_0: //add mul sub
  	          						begin
  	            						case(INST[31:25])
  	              							Funct7_0: //add
  	                							begin
  	                  								ImmOp		<= 3'b111;
  	                  								RegWen		<= 1;
  	                  								ComSig		<= 3'b111;
  	                  								Imm_mux_Sel	<= 1;
  	                  								Br_mux_Sel	<= 1;
  	                  								AluSig		<= 4'b0100;
  	                  								Rd_mux_Sel	<= 1;
  	                  								MemOp		<= 3'b000;
  	                  								MemStall	<= 1;
  	                  								FetStall 	<= 0;
  	                  
  	                							end
  	              							Funct7_1: //mul
  	              							  	begin
  	              							  	  	ImmOp		<= 3'b111;
  	              							  	  	RegWen		<= 1;
  	              							  	  	ComSig		<= 3'b111;
  	              							  	  	Imm_mux_Sel	<= 1;
  	              							  	  	Br_mux_Sel	<= 1;
  	              							  	  	AluSig		<= 4'b1100;
  	              							  	  	Rd_mux_Sel	<= 1;
  	              							  	  	MemOp		<= 3'b000;
  	              							  	  	MemStall	<= 1;
  	              							  	  	FetStall 	<= 0;
  	              							  	end
  	              							Funct7_2: //sub
  	              							  	begin
  	              							  	  	ImmOp		<= 3'b111;
  	              							  	  	RegWen		<= 1;
  	              							  	  	ComSig		<= 3'b111;
  	              							  	  	Imm_mux_Sel	<= 1;
  	              							  	  	Br_mux_Sel	<= 1;
  	              							  	  	AluSig		<= 4'b0101;
  	              							  	  	Rd_mux_Sel	<= 1;
  	              							  	  	MemOp		<= 3'b000;
  	              							  	  	MemStall	<= 1;
  	              							  	  	FetStall 	<= 0;
  	              							  	end 
  	              							default:
  	              							  	begin
  	              							  	  	ImmOp		<= 3'b111;
  	              							  	  	RegWen		<= 1;
  	              							  	  	ComSig		<= 3'b111;
  	              							  	  	Imm_mux_Sel	<= 1;
  	              							  	  	Br_mux_Sel	<= 1;
  	              							  	  	AluSig		<= 4'b0000;
  	              							  	  	Rd_mux_Sel	<= 1;
  	              							  	  	MemOp		<= 3'b000;
  	              							  	  	MemStall	<= 1;
  	              							  	  	FetStall 	<= 0;
  	              							  	end           
  	            						endcase 
  	          						end
  	        					Funct3_1: //sll
  	        					  	begin
  	        					  	  	ImmOp		<= 3'b111;
  	        					  	  	RegWen		<= 1;
  	        					  	  	ComSig		<= 3'b111;
  	        					  	  	Imm_mux_Sel	<= 1;
  	        					  	  	Br_mux_Sel	<= 1;
  	        					  	  	AluSig		<= 4'b0001;
  	        					  	  	Rd_mux_Sel	<= 1;
  	        					  	  	MemOp		<= 3'b000;
  	        					  	  	MemStall	<= 1;
  	        					  	  	FetStall 	<= 0;
  	        					  	end
  	        					Funct3_2: //slt
  	        					  	begin
  	        					  	  	ImmOp		<= 3'b111;
  	        					  	  	RegWen		<= 1;
  	        					  	  	ComSig		<= 3'b111;
  	        					  	  	Imm_mux_Sel	<= 1;
  	        					  	  	Br_mux_Sel	<= 1;
  	        					  	  	AluSig		<= 4'b0111;
  	        					  	  	Rd_mux_Sel	<= 1;
  	        					  	  	MemOp		<= 3'b000;
  	        					  	  	MemStall	<= 1;
  	        					  	  	FetStall 	<= 0;
  	        					  	end
  	        					Funct3_3: //sltu
  	        					  	begin
  	        					  	  	ImmOp		<= 3'b111;
  	        					  	  	RegWen		<= 1;
  	        					  	  	ComSig		<= 3'b111;
  	        					  	  	Imm_mux_Sel	<= 1;
  	        					  	  	Br_mux_Sel	<= 1;
  	        					  	  	AluSig		<= 4'b1000;
  	        					  	  	Rd_mux_Sel	<= 1;
  	        					  	  	MemOp		<= 3'b000;
  	        					  	  	MemStall	<= 1;
  	        					  	  	FetStall 	<= 0;
  	        					  	end
  	        					Funct3_4: //xor
  	        					  	begin
  	        					  	  	ImmOp		<= 3'b111;
  	        					  	  	RegWen		<= 1;
  	        					  	  	ComSig		<= 3'b111;
  	        					  	  	Imm_mux_Sel	<= 1;
  	        					  	  	Br_mux_Sel	<= 1;
  	        					  	  	AluSig		<= 4'b1001;
  	        					  	  	Rd_mux_Sel	<= 1;
  	        					  	  	MemOp		<= 3'b000;
  	        					  	  	MemStall	<= 1;
  	        					  	  	FetStall 	<= 0;
  	        					  	end            
  	        					 
  	        					Funct3_5: //sra srl
  	        					  	case(INST[31:25])
  	        					  	  	Funct7_0: //srl
  	        					  	  	  	begin
  	        					  	  	  	  	ImmOp		<= 3'b111;
  	        					  	  	  	  	RegWen		<= 1;
  	        					  	  	  	  	ComSig		<= 3'b111;
  	        					  	  	  	  	Imm_mux_Sel	<= 1;
  	        					  	  	  	  	Br_mux_Sel	<= 1;
  	        					  	  	  	  	AluSig		<= 4'b0010;
  	        					  	  	  	  	Rd_mux_Sel	<= 1;
  	        					  	  	  	  	MemOp		<= 3'b000;
  	        					  	  	  	  	MemStall	<= 1; 
  	        					  	  	  	  	FetStall 	<= 0;                
  	        					  	  	  	end
  	        					  	  	Funct7_2: //sra
  	        					  	  	  	begin
  	        					  	  	  	  	ImmOp		<= 3'b111;
  	        					  	  	  	  	RegWen		<= 1;
  	        					  	  	  	  	ComSig		<= 3'b111;
  	        					  	  	  	  	Imm_mux_Sel	<= 1;
  	        					  	  	  	  	Br_mux_Sel	<= 1;
  	        					  	  	  	  	AluSig		<= 4'b0011;
  	        					  	  	  	  	Rd_mux_Sel	<= 1;
  	        					  	  	  	  	MemOp		<= 3'b000;
  	        					  	  	  	  	MemStall	<= 1; 
  	        					  	  	  	  	FetStall 	<= 0;                         
  	        					  	  	  	end
  	        					  	  	default:
  	        					  	  	  	begin
  	        					  	  	  	  	ImmOp		<= 3'b111;
  	        					  	  	  	  	RegWen		<= 1;
  	        					  	  	  	  	ComSig		<= 3'b111;
  	        					  	  	  	  	Imm_mux_Sel	<= 1;
  	        					  	  	  	  	Br_mux_Sel	<= 1;
  	        					  	  	  	  	AluSig		<= 4'b0000;
  	        					  	  	  	  	Rd_mux_Sel	<= 1;
  	        					  	  	  	  	MemOp		<= 3'b000;
  	        					  	  	  	  	MemStall	<= 1; 
  	        					  	  	  	  	FetStall 	<= 0;                       
  	        					  	  	  	end
  	        					  endcase
  	        					Funct3_6: //or
  	        					  	begin
  	        					  	  	ImmOp		<= 3'b111;
  	        					  	  	RegWen		<= 1;
  	        					  	  	ComSig		<= 3'b111;
  	        					  	  	Imm_mux_Sel	<= 1;
  	        					  	  	Br_mux_Sel	<= 1;
  	        					  	  	AluSig		<= 4'b1010;
  	        					  	  	Rd_mux_Sel	<= 1;
  	        					  	  	MemOp		<= 3'b000;
  	        					  	  	MemStall	<= 1;
  	        					  	  	FetStall 	<= 0;
  	        					  	end              
  	        					Funct3_7: //and
  	        					  	begin
  	        					  	  	ImmOp		<= 3'b111;
  	        					  	  	RegWen		<= 1;
  	        					  	  	ComSig		<= 3'b111;
  	        					  	  	Imm_mux_Sel	<= 1;
  	        					  	  	Br_mux_Sel	<= 1;
  	        					  	  	AluSig		<= 4'b1011;
  	        					  	  	Rd_mux_Sel	<= 1;
  	        					  	  	MemOp		<= 3'b000;
  	        					  	  	MemStall	<= 1;
  	        					  	  	FetStall 	<= 0;
  	        					  	end                
  	      					endcase
  	    				end
  	  				Itype1:
  	  				  	begin
  	  				  	  	case(INST[14:12])
  	  				  	  	  	Funct3_0: //addi
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b001;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1;
  	  				  	  	  	  	  	FetStall 	<= 0;              
  	  				  	  	  	  	end
  	  				  	  	  	Funct3_1: //slli
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b000;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0001;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1; 
  	  				  	  	  	  	  	FetStall 	<= 0;             
  	  				  	  	  	  	end          
  	  				  	  	  	Funct3_2: //slti
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b001;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0111;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1; 
  	  				  	  	  	  	  	FetStall 	<= 0;             
  	  				  	  	  	  	end                  
  	  				  	  	  	Funct3_3: //sltiu
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b001;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b1000;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1; 
  	  				  	  	  	  	  	FetStall 	<= 0;             
  	  				  	  	  	  	end                  
  	  				  	  	  	Funct3_4: //xori
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b001;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b1001;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1; 
  	  				  	  	  	  	  	FetStall 	<= 0;             
  	  				  	  	  	  	end                  
  	  				  	  	  	Funct3_5: //srai srli
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	case(INST[31:25])
  	  				  	  	  	  	  	  	Funct7_0: //srli
  	  				  	  	  	  	  	  	  	begin
  	  				  	  	  	  	  	  	  	  	ImmOp		<= 3'b000;
  	  				  	  	  	  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	  	  	  	AluSig		<= 4'b0010;
  	  				  	  	  	  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	  	  	  	MemStall	<= 1;
  	  				  	  	  	  	  	  	  	  	FetStall 	<= 0;      
  	  				  	  	  	  	  	  	  	end
  	  				  	  	  	  	  	  	Funct7_2: //srai
  	  				  	  	  	  	  	  	  	begin
  	  				  	  	  	  	  	  	  	  	ImmOp		<= 3'b000;
  	  				  	  	  	  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	  	  	  	AluSig		<= 4'b0011;
  	  				  	  	  	  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	  	  	  	MemStall	<= 1;
  	  				  	  	  	  	  	  	  	  	FetStall 	<= 0;      
  	  				  	  	  	  	  	  	  	end  
  	  				  	  	  	  	  	  	default:
  	  				  	  	  	  	  	  	  	begin
  	  				  	  	  	  	  	  	  	  	ImmOp		<= 3'b111;
  	  				  	  	  	  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	  	  	  	Imm_mux_Sel	<= 1;
  	  				  	  	  	  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	  	  	  	AluSig		<= 4'b0000;
  	  				  	  	  	  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	  	  	  	MemStall	<= 1; 
  	  				  	  	  	  	  	  	  	  	FetStall 	<= 0;     
  	  				  	  	  	  	  	  	  	end               
  	  				  	  	  	  	  	endcase
  	  				  	  	  	  	end
  	  				  	  	  	Funct3_6: //ori
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b001;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b1010;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1; 
  	  				  	  	  	  	  	FetStall 	<= 0;             
  	  				  	  	  	  	end                      
  	  				  	  	  	Funct3_7: //andi
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b001;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b1011;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1;
  	  				  	  	  	  	  	FetStall 	<= 0;              
  	  				  	  	  	  	end                    
  	  				  	  	endcase
  	  				  	end
  	  				Itype2:
  	  				  	begin
  	  				  	  	case(INST[14:12])
  	  				  	  	  	Funct3_0: //lb
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b001;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 0;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 0;
  	  				  	  	  	  	  	FetStall 	<= (FetStall2==0) ? 1 : 0 ;              
  	  				  	  	  	  	end               
  	  				  	  	  	Funct3_1: //lh
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b001;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 0;
  	  				  	  	  	  	  	MemOp		<= 3'b001;
  	  				  	  	  	  	  	MemStall	<= 0; 
  	  				  	  	  	  	  	FetStall 	<= (FetStall2==0) ? 1 : 0 ;             
  	  				  	  	  	  	end                     
  	  				  	  	  	Funct3_2: //lw
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b001;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 0;
  	  				  	  	  	  	  	MemOp		<= 3'b010;
  	  				  	  	  	  	  	MemStall	<= 0;
  	  				  	  	  	  	  	FetStall 	<= (FetStall2==0) ? 1 : 0 ;              
  	  				  	  	  	  	end                   
  	  				  	  	  	Funct3_4: //lbu
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b001;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 0;
  	  				  	  	  	  	  	MemOp		<= 3'b110;
  	  				  	  	  	  	  	MemStall	<= 0;
  	  				  	  	  	  	  	FetStall 	<= (FetStall2==0) ? 1 : 0 ;              
  	  				  	  	  	  	end                   
  	  				  	  	  	Funct3_5: //lhu
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b001;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 0;
  	  				  	  	  	  	  	MemOp		<= 3'b111;
  	  				  	  	  	  	  	MemStall	<= 0;
  	  				  	  	  	  	  	FetStall 	<= (FetStall2==0) ? 1 : 0 ;              
  	  				  	  	  	  	end 
  	  				  	  	  	default:
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b111;
  	  				  	  	  	  	  	RegWen		<= 1;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 1;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0000;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 0;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1;
  	  				  	  	  	  	  	FetStall 	<= 0;              
  	  				  	  	  	  	end                            
  	  				  	  	endcase
  	  				  	end
  	  				Stype :
  	  				  	begin
  	  				  	  	case(INST[14:12])
  	  				  	  	  	Funct3_0: //sb
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b010;
  	  				  	  	  	  	  	RegWen		<= 0;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b011;
  	  				  	  	  	  	  	MemStall	<= 0;
  	  				  	  	  	  	  	FetStall 	<= 0;              
  	  				  	  	  	  	end                   
  	  				  	  	  	Funct3_1: //sh
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b010;
  	  				  	  	  	  	  	RegWen		<= 0;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b100;
  	  				  	  	  	  	  	MemStall	<= 0; 
  	  				  	  	  	  	  	FetStall 	<= 0;             
  	  				  	  	  	  	end 
  	  				  	  	  	Funct3_2: //sw
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b010;
  	  				  	  	  	  	  	RegWen		<= 0;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b101;
  	  				  	  	  	  	  	MemStall	<= 0; 
  	  				  	  	  	  	  	FetStall 	<= 0;             
  	  				  	  	  	  	end    
  	  				  	  	  	default:
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b000;
  	  				  	  	  	  	  	RegWen		<= 0;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 1;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0000;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b011;
  	  				  	  	  	  	  	MemStall	<= 1;  
  	  				  	  	  	  	  	FetStall 	<= 0;            
  	  				  	  	  	  	end                    
  	  				  	  	endcase
  	  				  	end    
  	  				Btype :
  	  				  	begin
  	  				  	  	case(INST[14:12])
  	  				  	  	  	Funct3_0: //beq
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b011;
  	  				  	  	  	  	  	RegWen		<= 0;
  	  				  	  	  	  	  	ComSig		<= 3'b000;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 0;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1;
  	  				  	  	  	  	  	FetStall 	<= 0;              
  	  				  	  	  	  	end                 
  	  				  	  	  	Funct3_1: //bne
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b011;
  	  				  	  	  	  	  	RegWen		<= 0;
  	  				  	  	  	  	  	ComSig		<= 3'b001;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 0;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1;  
  	  				  	  	  	  	  	FetStall 	<= 0;            
  	  				  	  	  	  	end                 
  	  				  	  	  	Funct3_4: //blt
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b011;
  	  				  	  	  	  	  	RegWen		<= 0;
  	  				  	  	  	  	  	ComSig		<= 3'b010;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 0;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1;  
  	  				  	  	  	  	  	FetStall 	<= 0;            
  	  				  	  	  	  	end                 
  	  				  	  	  	Funct3_5: //bge
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b011;
  	  				  	  	  	  	  	RegWen		<= 0;
  	  				  	  	  	  	  	ComSig		<= 3'b100;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 0;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1; 
  	  				  	  	  	  	  	FetStall 	<= 0;             
  	  				  	  	  	  	end                 
  	  				  	  	  	Funct3_6: //bltu
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b011;
  	  				  	  	  	  	  	RegWen		<= 0;
  	  				  	  	  	  	  	ComSig		<= 3'b011;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 0;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1; 
  	  				  	  	  	  	  	FetStall 	<= 0;             
  	  				  	  	  	  	end                 
  	  				  	  	  	Funct3_7: //bgeu
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b011;
  	  				  	  	  	  	  	RegWen		<= 0;
  	  				  	  	  	  	  	ComSig		<= 3'b101;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 0;
  	  				  	  	  	  	  	Br_mux_Sel	<= 0;
  	  				  	  	  	  	  	AluSig		<= 4'b0100;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1;  
  	  				  	  	  	  	  	FetStall 	<= 0;            
  	  				  	  	  	  	end 
  	  				  	  	  	default:
  	  				  	  	  	  	begin
  	  				  	  	  	  	  	ImmOp		<= 3'b000;
  	  				  	  	  	  	  	RegWen		<= 0;
  	  				  	  	  	  	  	ComSig		<= 3'b111;
  	  				  	  	  	  	  	Imm_mux_Sel	<= 1;
  	  				  	  	  	  	  	Br_mux_Sel	<= 1;
  	  				  	  	  	  	  	AluSig		<= 4'b0000;
  	  				  	  	  	  	  	Rd_mux_Sel	<= 1;
  	  				  	  	  	  	  	MemOp		<= 3'b000;
  	  				  	  	  	  	  	MemStall	<= 1;   
  	  				  	  	  	  	  	FetStall 	<= 0;           
  	  				  	  	  	  	end                                    
  	  				  	  	endcase
  	  				  	end    
  	  				Utype : //lui
  	  				  	begin
  	  				  	  	ImmOp		<= 3'b100;
  	  				  	  	RegWen		<= 1;
  	  				  	  	ComSig		<= 3'b111;
  	  				  	  	Imm_mux_Sel	<= 0;
  	  				  	  	Br_mux_Sel	<= 1;
  	  				  	  	AluSig		<= 4'b0110;
  	  				  	  	Rd_mux_Sel	<= 1;
  	  				  	  	MemOp		<= 3'b000;
  	  				  	  	MemStall	<= 1; 
  	  				  	  	FetStall 	<= 0;             
  	  				  	end                 
  				endcase
  			end
  	end
endmodule
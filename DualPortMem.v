module DualPortMem
#(
	parameter addrW = 8,
	parameter dataW = 16,
	parameter memDepth = 1<<addrW
)
(
	input clk,
	
	//Port A stuff
	input [dataW-1:0] dInA,
	output reg [dataW-1:0] dOutA,
	input [addrW-1:0] addrA,
	input wEnA,
	input EnA,
	
	//Port B stuff
	input [dataW-1:0] dInB,
	output reg [dataW-1:0] dOutB,
	input [addrW-1:0] addrB,
	input wEnB,
	input EnB,
	
	//collision detection
	output collision
);
	//Declaring the memory unit:
	reg [dataW-1:0] Mem [0:memDepth-1];
	
	//collison logic:
	assign collision = wEnA && wEnB && (addrA == addrB);

	//PORT A Logic:
	always @ (posedge clk)
	begin
		if(EnA)
		begin
			dOutA <= Mem[addrA]; //READ LOGIC
			if(wEnA)
				Mem[addrA] <= dInA; //WRITE LOGIC
		end		
	end
	
	//PORT B Logic:
	always @ (posedge clk)
	begin
		if(EnB)
		begin
			dOutB <= Mem[addrB]; //READ LOGIC
			if(wEnB && !collision)
				Mem[addrB] <= dInB; //WRITE LOGIC
		end		
	end
	
endmodule
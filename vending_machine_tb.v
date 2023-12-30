`timescale 1ns/100ps

module vending_machine_tb;

reg b1, b0, clk;
reg[2:0] select;
reg [2:0] amnt;

wire[2:0] change;

vending_machine vm_1(.change(change), .amnt(amnt), .select(select), .b0(b0), .b1(b1), .clk(clk));


initial
begin

	$monitor("time = %d \ b1 = %b \  b0 = %b \  clk = %b \ select = %b \  amnt = %b \  change = %b", $time,b1,b0,clk,select,amnt,change);

	//@time = 0 in SELECT STATE
	clk = 0;
	b1 = 1;
	b0 = 1;
	select = 3'b000;
	amnt = 3'b000;

	//@5ns transition to DRINK STATE
	#5 select = 3'b001;
	//@5ns transition to INSERT STATE
	#3 b0 = ~b0;
	#1 b0 = ~b0;
 	
	#5 select = 3'b000;
	// amnt > price - transition to CHANGE STATE
	#5 amnt = 3'b101;
	#3 b0 = ~b0;
	#1 b0 = ~b0;

	// tranisition to SELECT STATE-Output = 101 - 011 - 010
	#3 b0 = ~b0;
	#1 b0 = ~b0;

	
	#10 b0 = ~b0;
	
	//@5ns transition to CHIP STATE
	#5 select = 3'b010;
	//@5ns transition to INSERT STATE
	#3 b0 = ~b0;
	#1 b0 = ~b0;
 	
	#5 select = 3'b000;
	// amnt > price - transition to CHANGE STATE
	#5 amnt = 3'b001;
	#3 b0 = ~b0;
	#1 b0 = ~b0;

	// tranisition to SELECT STATE-Output = 001 - 010 -> NOT ENOUGH STAY IN CHANGE STATE
	#3 b0 = ~b0;
	#1 b0 = ~b0;

	
	#10 b0 = ~b0;
	
	
	#20 
	$stop;
	$finish;
end
always #1 clk = ~clk;

endmodule
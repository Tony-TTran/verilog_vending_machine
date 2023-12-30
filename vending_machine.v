module vending_machine(change, amnt, select, b0, b1, clk);

input b1, b0, clk;
input [2:0] select;
input [2:0] amnt;


output reg [2:0] change;

reg [2:0] price;
reg [2:0] nx_state, pr_state;
parameter SELECT = 3'b000, DRINK = 3'b001, CHIPS = 3'b010, CHOCOLATE = 3'b011, INSERT = 3'b100, AMT_DUE = 3'b101;

initial begin
	pr_state = SELECT;
end

always @(posedge clk)
begin
	if(b1 == 0)begin
		pr_state <= SELECT;
	end else begin
		pr_state <= nx_state;
	end
	
end
		

		
always @(select,b0)
begin

		case(pr_state)
			SELECT:
				begin
				change <= 3'b000;
				nx_state <= (select == 3'b000 ? SELECT:(select == 3'b001 ? DRINK : (select == 3'b010 ? CHIPS : CHOCOLATE )));
				end
			DRINK:
				begin
				change <= 3'b000;
				nx_state <= (b0 == 0 ? INSERT : DRINK);
				price <=  3'b011;
				end
			CHIPS:
				begin
				change <= 3'b000;
				nx_state <= (b0 ==0 ? INSERT : CHIPS);
				price <=  3'b010;
				end
			CHOCOLATE:
				begin
				change <= 3'b000;
				nx_state <= (b0 == 0 ? INSERT : CHOCOLATE);
				price <=  3'b010;
				end
			INSERT:
				begin
				change <= 3'b000;
				nx_state <= (amnt<price && ~b0 ? INSERT:AMT_DUE);
				end
			AMT_DUE:
				begin
				change <= amnt - price;
				nx_state <= (~b0 ? SELECT: AMT_DUE);
				end
			default : nx_state <= pr_state;
	
		endcase
end



/*always @(pr_state)
begin
	case(pr_state)
			SELECT:
				change <= 0;
			DRINK:
				change <= 0;
			CHIPS:
				change <= 0;
			CHOCOLATE:
				change <= 0;
			INSERT:
				change <= 0;
			CHANGE:
				change <= amnt - price;
	endcase
end*/

endmodule
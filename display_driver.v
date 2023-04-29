module display_driver(
	input clk,
	input reset_n,
	input enable,
	input [3:0] binary,
	output [6:0] sseg
	);
	
	reg [6:0] display;
	
	
	always @(posedge clk, negedge reset_n)
	begin
		if (~reset_n)
			display <= 7'b1111111;
		else if (enable)
		begin
			case (binary)
				0:  display <= 7'b1000000;
				1:  display <= 7'b1111001;
				2:  display <= 7'b0100100;
				3:  display <= 7'b0110000;
				4:  display <= 7'b0011001;
				5:  display <= 7'b0010010;
				6:  display <= 7'b0000010;
				7:  display <= 7'b1111000;
				8:  display <= 7'b0000000;
				9:  display <= 7'b0011000;
				10: display <= 7'b0001000;
				11: display <= 7'b0000011;
				12: display <= 7'b1000110;
				13: display <= 7'b0100001;
				14: display <= 7'b0000110;
				15: display <= 7'b0001110;
			endcase
			
		end
			
	end
	
	assign sseg = display;
	

endmodule
	
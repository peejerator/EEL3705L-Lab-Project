module timer_parameter
	#(parameter FINAL_VALUE = 255) (
	input clk,
	input reset_n,
	input enable,
	output [$clog2(FINAL_VALUE) - 1:0] done
	);
	
	
	localparam BITS = $clog2(FINAL_VALUE);
	
	reg [BITS - 1:0] Q_reg, Q_next;
	
	always @(posedge clk, negedge reset_n)
	begin
		if (~reset_n)
			Q_reg <= 'b0;
		else if(enable)
			Q_reg <= Q_next;
		else
			Q_reg <= Q_reg;
	end
	
	// Next state logic
	assign done = Q_reg == FINAL_VALUE;
	
	always @(*)
		Q_next = done ? 'b0 : Q_reg + 1;
		
endmodule
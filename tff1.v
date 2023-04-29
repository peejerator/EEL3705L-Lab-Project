module tff1(
	input clk,
	input reset_n,
	input enable,
	output reg q
	);
	
	always @(posedge clk) begin
	if (!reset_n)
		q <= 0;
	else
		if (enable)
			q <= ~q;
		else
			q <= q;
	end
endmodule
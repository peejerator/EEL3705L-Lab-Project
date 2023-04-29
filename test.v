module test (
	input  clk,
	input  reset_n,
	input  button_in,
	input  [3:0] sw, 
	output [6:0] sseg1,
	output [6:0] sseg2,
	output [6:0] sseg3,
	output [6:0] sseg4,
	output [6:0] sseg5,
	output [6:0] sseg6
	);
	
	localparam TEN_SECONDS = 499_999_999;
	
	localparam CODE_LENGTH = 3;
	
	localparam TRY_MOD = 4 * CODE_LENGTH - 1;
	localparam STATE_COUNT = CODE_LENGTH + 1;
	
	localparam CORRECT_CODE = 21'b011000001001000011001;
	
	wire [$clog2(STATE_COUNT) - 1:0] count;
	
	reg [$clog2(TRY_MOD) - 1:0] try_count;
	
	wire debounced_tick;
	
	wire lockout;
	
	wire timer_done;
	
	wire reset;
	
	wire code_correct;
	
	wire started;
	
	wire timer_count;
	
	button DEBOUNCED_BUTTON (
		.clk(clk),
		.reset_n(reset_n),
		.noisy(button_in),
		.debounced(),
		.p_edge(debounced_tick),
		.n_edge(),
		._edge()
	);
	
	mod_counter_parameter #(.FINAL_VALUE(STATE_COUNT)) uut (
		.clk(clk),
		.reset_n(reset_n),
		.enable(debounced_tick & ~lockout & (~code_correct || (count != 0))),
		.Q(count)
	);
	
	mod_counter_parameter #(.FINAL_VALUE(TRY_MOD)) uut2 (
		.clk(clk),
		.reset_n(reset_n && (~code_correct || (count != 0))),
		.enable(debounced_tick & ~lockout & ~code_correct),
		.Q(try_count)
	);
	
	timer_parameter #(.FINAL_VALUE(TEN_SECONDS)) T1 (
		.clk(clk),
		.reset_n(reset_n & (try_count != 1)),
		.enable(((try_count) == 0) & ~timer_done),
		.done(timer_done)
	);
	
	
	display_driver FIRST_DIGIT (
		.clk(clk),
		.reset_n(reset_n),
		.enable((count == 1)),
		.binary(sw),
		.sseg(sseg1)
	);
	
	display_driver SECOND_DIGIT (
		.clk(clk),
		.reset_n(reset_n & (count != 1)),
		.enable((count == 2)),
		.binary(sw),
		.sseg(sseg2)
	);
	
	display_driver THIRD_DIGIT (
		.clk(clk),
		.reset_n(reset_n & (count != 1)),
		.enable((count == 3)),
		.binary(sw),
		.sseg(sseg3)
	);
	
	display_driver CORRECT_DIGIT (
		.clk(clk),
		.reset_n(reset_n & (count != 1)),
		.enable((count == 0)),
		.binary(code_correct ? 12 : (lockout ? 14 : 15)),
		.sseg(sseg5)
	);
	
	display_driver TEST_1 (
		.clk(clk),
		.reset_n(reset_n),
		.enable(0),
		.binary(try_count),
		.sseg(sseg4)
	);
	
	display_driver TEST_2 (
		.clk(clk),
		.reset_n(reset_n),
		.enable(0),
		.binary(0),
		.sseg(sseg6)
	);
	
	tff1 TFF1 (
		.clk(clk),
		.reset_n(reset_n),
		.enable(~started & (try_count == 1)),
		.q(started)
	);
	
	assign code_correct = ({sseg1, sseg2, sseg3} === CORRECT_CODE);
	assign lockout = ((try_count) == 0) & (~timer_done) & ~code_correct & (count == 0) & started;
		
endmodule
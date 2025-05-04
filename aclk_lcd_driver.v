
module aclk_lcd_driver (
	show_a,
	show_new_time,
	alarm_time,
	current_time,
	key,
	sound_alarm,
	display_time);

input show_a, show_new_time;
input [3:0] alarm_time, current_time, key;

output reg sound_alarm;
output reg [7:0] display_time;

// internal signals
reg [3:0] display_value;

// Define the parameter constants to represent LCD numbers
parameter ZERO    = 8'h30;
parameter ONE     = 8'h31;
parameter TWO     = 8'h32;
parameter THREE   = 8'h33;
parameter FOUR    = 8'h34;
parameter FIVE    = 8'h35;
parameter SIX     = 8'h36;
parameter SEVEN   = 8'h37;
parameter EIGHT   = 8'h38;
parameter NINE    = 8'h39;
parameter ERROR   = 8'h3A;



always @(*) begin
	// Displays the key_time, alarm time or current time as per control sig
	if(show_new_time) 
		display_value = key;
	else if(show_a)
		display_value = alarm_time;
	else
		display_value = current_time;
	// generates sound_alarm logic i.e, when current_time is equal to alarm_time
	if(current_time == alarm_time)
		sound_alarm = 1'b1;
	else
		sound_alarm = 1'b0;
end

//Decoder logic
always @ (display_value)
begin
	case(display_value)
		4'd0 : display_time = ZERO;
		4'd1 : display_time = ONE;
		4'd2 : display_time = TWO;
		4'd3 : display_time = THREE;
		4'd4 : display_time = FOUR;
		4'd5 : display_time = FIVE;
		4'd6 : display_time = SIX;
		4'd7 : display_time = SEVEN;
		4'd8 : display_time = EIGHT;
		4'd9 : display_time = NINE;
	     default : display_time = ERROR;
	endcase
end
endmodule


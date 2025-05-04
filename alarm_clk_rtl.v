
// top level module
module alarm_clk_rtl (
	clk,
	key,
	reset,
	time_button,
	alarm_button,
	fast_watch,
	ms_hour,
	ls_hour,
	ms_minute,
	ls_minute,
	alarm_sound);

input clk,
	reset,
	time_button,
	alarm_button,
	fast_watch;

input [3:0] key;

output [7:0] ms_hour,
	ls_hour,
	ms_minute,
	ls_minute;

output alarm_sound;

// Define the Interconnecting internal wires
wire    one_second,
	one_minute,
	load_new_c,
	load_new_a,
	show_current_time,
	show_a,
	shift,
	reset_count;

wire [3:0] key_buffer_ls_min,
	   key_buffer_ms_min,
	   key_buffer_ls_hr,
	   key_buffer_ms_hr,
	   current_time_ms_hr,
	   current_time_ls_hr,
	   current_time_ms_min,
	   current_time_ls_min,
	   alarm_time_ms_hr,
	   alarm_time_ls_hr,
	   alarm_time_ms_min,
	   alarm_time_ls_min;

// Instantiate lower sub modules. Use interconnect(internal) signals for connecting the sub modules

// instantiate the timing generator module
aclk_timegen tgen1 (
	.clk(clk),
	.reset(reset),
	.reset_count(reset_count), 
	.fast_watch(fast_watch),
	.one_minute(one_minute),
	.one_second(one_second));

// instantiate the counter module
aclk_counter count1 (
	.clk(clk),
	.reset(reset),
	.one_minute(one_minute),
	.load_new_c(load_new_c),
	.new_current_time_ms_hr(key_buffer_ms_hr),
	.new_current_time_ls_hr(key_buffer_ls_hr),
	.new_current_time_ms_min(key_buffer_ms_min),
	.new_current_time_ls_min(key_buffer_ls_min),
	.current_time_ms_hr(current_time_ms_hr),
	.current_time_ls_hr(current_time_ls_hr),
	.current_time_ms_min(current_time_ms_min),
	.current_time_ls_min(current_time_ls_min));

// instantiate the alarm register module
aclk_areg alreg1 (
	.clk(clk),
	.reset(reset),	
	.load_new_a(load_new_a),
	.new_alarm_ms_hr(key_buffer_ms_hr),
	.new_alarm_ls_hr(key_buffer_ls_hr),
	.new_alarm_ms_min(key_buffer_ms_min),
	.new_alarm_ls_min(key_buffer_ls_min),
	.alarm_time_ms_hr(alarm_time_ms_hr),
	.alarm_time_ls_hr(alarm_time_ls_hr),
	.alarm_time_ms_min(alarm_time_ms_min),
	.alarm_time_ls_min(alarm_time_ls_min));

//instatiate the key register module
aclk_keyreg keyreg1 (
	.reset(reset),
	.clk(clk),
	.shift(shift),
	.key(key),
	.key_buffer_ls_min(key_buffer_ls_min),
	.key_buffer_ms_min(key_buffer_ms_min),
	.key_buffer_ls_hr(key_buffer_ls_hr),
	.key_buffer_ms_hr(key_buffer_ms_hr));

// instantiate the controller
aclk_controller fsm1 (
	.clk(clk),
	.reset(reset),
	.one_second(one_second),
	.alarm_button(alarm_button),
	.time_button(time_button),
	.key(key),
	.reset_count(reset_count),
	.load_new_c(load_new_c),
	.show_new_time(show_current_time),
	.show_a(show_a),
	.load_new_a(load_new_a),
	.shift(shift));

// instantiate the lcd driver 4 module
aclk_lcd_display lcd_disp (
	.alarm_time_ms_hr(alarm_time_ms_hr),
	.alarm_time_ls_hr(alarm_time_ls_hr),
	.alarm_time_ms_min(alarm_time_ms_min),
	.alarm_time_ls_min(alarm_time_ls_min),
	.current_time_ms_hr(current_time_ms_hr),
	.current_time_ls_hr(current_time_ls_hr),
	.current_time_ms_min(current_time_ms_min),
	.current_time_ls_min(current_time_ls_min),
	.key_ms_hr(key_buffer_ms_hr),
	.key_ls_hr(key_buffer_ls_hr),
	.key_ms_min(key_buffer_ms_min),
	.key_ls_min(key_buffer_ls_min),
	.show_a(show_a),
	.show_current_time(show_current_time),
	.display_ms_hr(ms_hour),
	.display_ls_hr(ls_hour),
	.display_ms_min(ms_minute),
	.display_ls_min(ls_minute),
	.sound_a(alarm_sound));
endmodule

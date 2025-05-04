
module aclk_controller(
	clk,
	reset,
	one_second,
	alarm_button,
	time_button,
	key,
	reset_count,
	load_new_c,
	show_new_time,
	show_a,
	load_new_a,
	shift);

// input & o/p declaration
input clk,reset,one_second,alarm_button,time_button;
input [3:0] key;
output reset_count,
	load_new_c,
	show_new_time,
	show_a,
	load_new_a,
	shift;

// Define internal register for next and present state
reg [2:0] next_state, pre_state;

//Define internal signal for timeout logic
wire time_out;

//define registers for counting 10 sec in KEY_ENTRY and KEY_WAITED state
reg [3:0] count1, count2;

//states definition
parameter SHOW_TIME = 3'B000;
parameter KEY_ENTRY = 3'B001;
parameter KEY_STORED = 3'B010;
parameter SHOW_ALARM = 3'B011;
parameter SET_ALARM_TIME = 3'B100;
parameter SET_CURRENT_TIME = 3'B101;
parameter KEY_WAITED = 3'B110;
parameter NOKEY = 10;


//Counts 10 sec pulses for KEY-ENTRY state
always@(posedge clk or posedge reset)
begin
	//upon reset ,set the count1 value to 0
	if(reset)
		count1 <= 4'd0;
	// else check if present state is other than key_entry , then set count1 value to 0
	else if(!(pre_state == KEY_ENTRY))
		count1 <= 4'd0;
	// else check if count1 value has reached 'd9, then set the count1 value to 0
	else if(count1 == 9)
		count1 <= 4'd0;
	// else increment the count for every one_second pulse
	else if(one_second)
		count1 <= count1 + 1'b1;
end


//Counts 10 sec pulses for KEY-WAITED state
always@(posedge clk or posedge reset)
begin
	//upon reset ,set the count2 value to 0
	if(reset)
		count2 <= 4'd0;
	// else check if present state is other than key_waited , then set count2 value to 0
	else if(!(pre_state == KEY_WAITED))
		count2 <= 4'd0;
	// else check if count2 value has reached 'd9, then set the count2 value to 0
	else if(count2 == 9)
		count2 <= 4'd0;
	// else increment the count for every one_second pulse
	else if(one_second)
		count2 <= count2 + 1'b1;
end


// Time out logic // assert time out signal whenever the count1 or count2 reaches 'd9
assign time_out = ((count1 == 9) || (count2 == 9)) ? 1 : 0;

// Present state logic
always@(posedge clk or posedge reset)
begin
	// Upon reset, assign present state as "show_time"
	if(reset)
		pre_state <= SHOW_TIME;
	// else if there is no reset then assign the present state as next state
	else 
		pre_state <= next_state;
end

// Next state logic
always@(*)
begin
	case(pre_state)
		// state transtion from show_time to other state
	     SHOW_TIME : begin
			if(alarm_button) 
				next_state = SHOW_ALARM;
			else if(key != NOKEY)
				next_state = KEY_STORED;
			else 
				next_state = SHOW_TIME;
			end

	     KEY_STORED : next_state = KEY_WAITED;

	     KEY_WAITED : begin
			  if(key == NOKEY)
				next_state = KEY_ENTRY;
			  else if(time_out == 0)
				next_state = SHOW_TIME;
			  else 
				next_state = KEY_WAITED;
			  end

	    KEY_ENTRY : begin
			if(alarm_button)
				next_state = SET_ALARM_TIME;
			else if(time_button)
				next_state = SET_CURRENT_TIME;
			else if(time_out == 0)
				next_state = SHOW_TIME;
			else if(key != NOKEY)
				next_state = KEY_STORED;
			else
				next_state = KEY_ENTRY;
			end

	   SHOW_ALARM : begin
			if(!alarm_button)
				next_state = SHOW_TIME;
			else 
				next_state = SHOW_ALARM;
			end

	  SET_ALARM_TIME : next_state = SHOW_TIME;

	  SET_CURRENT_TIME : next_state = SHOW_TIME;

	  default : next_state = SHOW_TIME;

	endcase		
end


// moore fsm o/p logic
assign show_new_time = (pre_state==KEY_ENTRY ||
			pre_state==KEY_STORED ||
			pre_state==KEY_WAITED ) ? 1 : 0;

assign show_a          = (pre_state == SHOW_ALARM) ? 1 : 0;

assign load_new_a      = (pre_state == SET_ALARM_TIME) ? 1 : 0;

assign load_new_c      = (pre_state == SET_CURRENT_TIME) ? 1 : 0;

assign reset_count     = (pre_state == SET_CURRENT_TIME) ? 1 : 0;

assign shift           = (pre_state == KEY_STORED) ? 1 : 0;

endmodule

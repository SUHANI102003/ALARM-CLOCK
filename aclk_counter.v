
module aclk_counter(
	clk,
	reset,
	one_minute,
	load_new_c,
	new_current_time_ms_hr,
	new_current_time_ls_hr,
	new_current_time_ms_min,
	new_current_time_ls_min,
	current_time_ms_hr,
	current_time_ls_hr,
	current_time_ms_min,
	current_time_ls_min);

input clk,
	reset,
	one_minute,
	load_new_c;

input [3:0] new_current_time_ms_hr,
	new_current_time_ls_hr,
	new_current_time_ms_min,
	new_current_time_ls_min;

output reg [3:0] current_time_ms_hr,
	current_time_ls_hr,
	current_time_ms_min,
	current_time_ls_min;

// Loadable binary up syn counter logic

// write always block with asyn reset
always@(posedge clk or posedge reset)
begin
	if(reset) begin
		current_time_ms_hr<= 4'd0;
		current_time_ls_hr<= 4'd0;
		current_time_ms_min<= 4'd0;
		current_time_ls_min<= 4'd0;
	end
	// else if there is no reset ,then load the counter with new current time only if load new c signal is active
	else if(load_new_c) begin
		current_time_ms_hr<= new_current_time_ms_hr;                  // 2  3     5   9   -> 00:00
		current_time_ls_hr<= new_current_time_ls_hr;                  // 0  9     5   9   -> 10:00
		current_time_ms_min<= new_current_time_ms_min;                // 0  0     5   9   -> 01:00
		current_time_ls_min<= new_current_time_ls_min;                // 0  0     0   9   -> 00:10
	end
	// else if there is no new_load_c signal ,then check for one_minute signal and implement counting algo
	else if(one_minute==1) begin
		//check for corner case
		// if current time is 23:59, then next current_time will be 00:00
		if(current_time_ms_hr == 4'd2 && current_time_ls_hr == 4'd3 &&
	 	   current_time_ms_min == 4'd5 && current_time_ls_min == 4'd9)
		begin
			current_time_ms_hr<= 4'd0;
			current_time_ls_hr<= 4'd0;
			current_time_ms_min<= 4'd0;
			current_time_ls_min<= 4'd0;
		end
		// corner case 2
		else if( current_time_ls_hr == 4'd9 &&
	 	        current_time_ms_min == 4'd5 && current_time_ls_min == 4'd9)
		begin
			current_time_ms_hr<= current_time_ms_hr + 1'd1;
			current_time_ls_hr<= 4'd0;
			current_time_ms_min<= 4'd0;
			current_time_ls_min<= 4'd0;
		end
		//corner case 3
		else if(current_time_ms_min == 4'd5 && current_time_ls_min == 4'd9)
		begin
			current_time_ls_hr<= current_time_ls_hr + 1'd1;
			current_time_ms_min<= 4'd0;
			current_time_ls_min<= 4'd0;
		end

		//corner case 4
		else if(current_time_ls_min == 4'd9)
		begin
			current_time_ms_min<= current_time_ms_min + 1'd1;
			current_time_ls_min<= 4'd0;
		end
		
		//else
		else begin
			current_time_ls_min<= current_time_ls_min + 1'd1;
		end
	end
end

endmodule

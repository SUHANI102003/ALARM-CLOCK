
module aclk_timegen(
	clk,
	reset,
	reset_count, //resets timegen whenever new current time is set
	fast_watch,
	one_minute,
	one_second);

input clk,reset,reset_count,fast_watch;
output  one_minute, one_second;

//internal registers
reg [13:0] count;
reg one_second;
reg one_minute;
reg one_minute_reg;

// one minute pulse generation
always@(posedge clk or posedge reset)
begin
	// upon reset, set the one_minute_reg to 0
	if(reset)
	begin
		count <= 14'b0;
		one_minute_reg <=1'b0;
	end
	// else check if there is a reset from alarm controller and reset one_minute_reg to 0
	else if(reset_count)
	begin
		count <= 14'b0;
		one_minute_reg <=1'b0;
	end
	// else check if count value reaches 'd15359 to generate 1 min pulse
	else if(count[13:0] == 14'd15359)
	begin
		count <= 14'b0;
		one_minute_reg <=1'b1;
	end
	// else for every posedge of clk just increment the clk
	else 
	begin
		count <= count + 1'b1;
		one_minute_reg<=1'b0;
	end
end

// one second pulse generation
always@(posedge clk or posedge reset)
begin
	// upon reset, set the one_second and counter_sec to 0
	if(reset)
	begin
		one_second <=1'b0;
	end
	// else check if there is a reset from alarm controller and reset one_second to 0
	else if(reset_count)
	begin
		one_second <=1'b0;
	end
	// else check if count value reaches 'd255 to generate 1 min pulse
	else if(count[7:0] == 8'd255)
	begin
		one_second <=1'b1;
	end
	
	else
		one_second <= 1'b0;
end

//fastwatch mode logic that makes counting faster
always@(*)
begin
	if(fast_watch)
		one_minute = one_second;
	else
	one_minute = one_minute_reg;
end
endmodule


	
	


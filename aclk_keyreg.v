
module aclk_keyreg(
	reset,
	clk,
	shift,
	key,
	key_buffer_ls_min,
	key_buffer_ms_min,
	key_buffer_ls_hr,
	key_buffer_ms_hr);

// input and output port declaration

input reset,clk,shift;
input [3:0] key;
output reg [3:0] key_buffer_ls_min, key_buffer_ms_min, key_buffer_ls_hr, key_buffer_ms_hr;


////////////////////////////////////////////////////////////
// This procedure stores the last 4 keys pressed. The FSM 
// block detects the new keys values and triggers the shift
// pulse to shift in the new key value.
/////////////////////////////////////////////////////////////

always@(posedge clk or posedge reset) 
begin
	//for asyn reset, reset the key buffer o/p register to 1'b0
	if(reset)
	begin
		key_buffer_ls_min <=1'b0;
		key_buffer_ms_min <= 1'b0;
		key_buffer_ls_hr <= 1'b0;
		key_buffer_ms_hr <= 1'b0;
	end

	// else if there is a shift, perform left shift from LS_MIN to MS_HR
	else if(shift==1)
	begin
		key_buffer_ms_hr <= key_buffer_ls_hr ;
		key_buffer_ls_hr <= key_buffer_ms_min ;
		key_buffer_ms_min <= key_buffer_ls_min ;
		key_buffer_ls_min <= key;
	end
end
endmodule

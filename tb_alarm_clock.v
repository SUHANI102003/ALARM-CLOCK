// testbench

module tb_alarm_clock();
//parameter CYCLE = 10;
reg clk;
reg [3:0] key;
reg reset, time_button, alarm_button, fast_watch;
wire [7:0] ms_hour,
	   ls_hour,
	   ms_minute,
	   ls_minute;
wire alarm_sound;

// instantiate the top level module
alarm_clk_rtl DUT (
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

 // Clock generation
    always #5 clk = ~clk;  // 10 time units period clock

    // Initial block to apply test vectors
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        time_button = 0;
        alarm_button = 0;
        fast_watch = 0;
        key = 4'b0000;

        // Apply reset
        #10 reset = 0;

        // Set current time to 12:34
        key = 4'd1;  // MS Hour = 1
        time_button = 1;
        #5000 time_button = 0;
        @(negedge clk);

        key = 4'd2;  // LS Hour = 2
        time_button = 1;
        #5000 time_button = 0;
        @(negedge clk);

        key = 4'd3;  // MS Minute = 3
        time_button = 1;
        #5000 time_button = 0;
        @(negedge clk);

        key = 4'd4;  // LS Minute = 4
        time_button = 1;
        #5000 time_button = 0;
        @(negedge clk);

        // Set alarm time to 12:35
        key = 4'd1;  // MS Hour = 1
        alarm_button = 1;
        #5000 alarm_button = 0;
        @(negedge clk);

        key = 4'd2;  // LS Hour = 2
        alarm_button = 1;
        #5000 alarm_button = 0;
        @(negedge clk);

        key = 4'd3;  // MS Minute = 3
        alarm_button = 1;
        #5000 alarm_button = 0;
        @(negedge clk);

        key = 4'd5;  // LS Minute = 5
        alarm_button = 1;
        #5000 alarm_button = 0;
        @(negedge clk);

        // Activate fastwatch mode
        fast_watch = 1;

        // Simulate time passing and check for alarm sound
        repeat (3 * 256) @(negedge clk);  // Wait for approximately 3 minutes (in fastwatch mode)

        fast_watch = 0;  // Turn off fastwatch mode

        // Wait for additional 1 minute (normal speed) to ensure observation
        repeat (60) @(negedge clk);  // Additional 1 minute

        // Monitor the results
        $monitor($time, " - Time: %d%d:%d%d | Alarm Sound: %b", ms_hour, ls_hour, ms_minute, ls_minute, alarm_sound);

        #(7*256*2);  // Run simulation for a short time to ensure results are visible

        $finish;
    end

endmodule
        


module game_state_tb();
    logic clk;// = 1'd0;
    
    always #5 clk = !clk;
    
    logic reset = 1'b0;
    logic[10:0] p1_x_in, p2_x_in;
    logic[2:0] state;
    logic p1_left, p1_right, p1_kick, p1_punch;
    logic p2_left, p2_right, p2_kick, p2_punch;
    logic start_timer = 0;
    wire expired;


    game_state(
    .vclock_in,.reset_in(reset), .p1_x_in(p1_x_in), .p2_x_in(p2_x_in), .p1_left(p1_left), .p1_right(p1_right), .p1_kick(p1_kick), .p1_punch(p1_punch),
    .p2_left(p2_left), .p2_right(p2_right), .p2_kick(p2_kick), .p2_punch(p2_punch), .state(state)
    );
    
    parameter AT_REST = 3'b000;
    parameter MOVING_BACKWARDS = 3'b001;
    parameter MOVING_FORWARDS = 3'b010;
    parameter KICKING = 3'b011;
    parameter PUNCHING = 3'b100;

    parameter KICKING_DISTANCE = 32;
    parameter PUNCHING_DISTANCE = 64;
    
    initial begin
    clk = 1'd0;
        // toggle reset
        reset <=1'b1;
        #10
        reset <= 1'b0;
        start_timer <= 1'b1;
        
        // set states
        assert (state == AT_REST);
        #1000;
        //start_timer <= 0;
        #10
        //start_timer <= 1'b1; // toggle start timer
        //time_parameters <= 4'd15;
        #1000;
        //start_timer <= 0; // toggle start timer
        //time_parameters <= 4'd0; // change time parameters
        #1000;
        //start_timer <= 1'b1;
        //time_parameters <= 4'd6; // change time parameters
    end
    

endmodule //timer_tb

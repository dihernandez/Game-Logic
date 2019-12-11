module game_state_tb();
    parameter AT_REST = 3'b000;
    parameter MOVING_BACKWARDS = 3'b001;
    parameter MOVING_FORWARDS = 3'b010;
    parameter KICKING = 3'b011;
    parameter PUNCHING = 3'b100;

    parameter KICKING_DISTANCE = 32;
    parameter PUNCHING_DISTANCE = 64;

    logic clk;// = 1'd0;
    
    always #5 clk = !clk;
    
    logic reset = 1'b0;
    logic[10:0] p1_x_in, p2_x_in;
    logic[2:0] p1_state = AT_REST;
    logic[2:0] p2_state = AT_REST;
    logic p1_left, p1_right, p1_kick, p1_punch;
    logic p2_left, p2_right, p2_kick, p2_punch;
    logic start_timer = 0;
    wire [6:0] p1_hp, p2_hp;


    game_state game(
    .vclock_in(clk),.reset_in(reset), .p1_x_in(p1_x_in), .p1_kick(p1_kick), .p1_punch(p1_punch), 
    .p2_x_in(p2_x_in), .p2_kick(p2_kick), .p2_punch(p2_punch), .p1_state(p1_state), .p2_state(p2_state), .p1_hitpoints(p1_hp), .p2_hitpoints(p2_hp)
    );
    

    
    initial begin
    clk = 1'd0;
        // toggle reset
        reset <=1'b1;
        #10
        reset <= 1'b0;
        start_timer <= 1'b1;
        
        // check state machine
        assert (p1_state == AT_REST);
        assert (p2_state == AT_REST);
        #100;
        p1_kick <= 1;
        #10
        assert (p1_state == KICKING);
        #10;
        p2_kick <= 1;
        #10
        assert (p2_state == KICKING);
        #10
        p1_kick <= 0;
        #10
        assert (p1_state == AT_REST);
        p2_kick <= 1;
        assert (p2_state == AT_REST);
        #100;
        
        
    end
    

endmodule //timer_tb

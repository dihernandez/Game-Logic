module game_state_tb();
    parameter AT_REST = 3'b00;
    parameter KICKING = 3'b01;
    parameter PUNCHING = 3'b10;

    parameter KICKING_DISTANCE = 32;
    parameter PUNCHING_DISTANCE = 64;

    logic clk;
    
    always #5 clk = !clk;
    
    logic reset = 1'b0;
    logic[10:0] p1_x_in, p2_x_in;
    logic[1:0] p1_state = AT_REST;
    logic[1:0] p2_state = AT_REST;
    logic[1:0] p2_state_testing = AT_REST;
    logic p1_left, p1_right, p1_kick, p1_punch;
    logic p2_left, p2_right, p2_kick, p2_punch;
    logic start_timer = 0;
    logic [8:0] distance_p1_to_p2_testing = 25;
    wire [6:0] p1_hp, p2_hp;


    game_state game(
    .pixel_clk(clk),.reset_in(reset), .p1_x_in(p1_x_in), .p1_kick(p1_kick), .p1_punch(p1_punch), 
    .p2_x_in(p2_x_in), .p2_kick(p2_kick), .p2_punch(p2_punch), .p1_state(p1_state), .p2_state(p2_state), .p2_state_testing(p2_state_testing), .p1_hitpoints(p1_hp), .p2_hitpoints(p2_hp),
    .distance_p1_to_p2_testing(distance_p1_to_p2_testing));
    

    
    initial begin
    clk = 1'd0;
        // toggle reset
        reset <=1'b1;
        #10
        reset <= 1'b0;
        start_timer <= 1'b1;
        p1_punch <= 0;
        p1_x_in <= 500;
        p2_x_in <= 520; // within punch and kick range
        
        // check state machine
        assert (p1_state == AT_REST);
        assert (p2_state == AT_REST);
        #100
        //p1_kick <= 1;
        p1_punch <= 1;
        #10
        //assert (p1_state == KICKING);
        #10
        //p2_kick <= 1;
        p1_punch <= 0;
        #10
        //assert (p2_state == KICKING);
       // #10
       // p1_kick <= 0;
       // #10
        //assert (p1_state == AT_REST);
      //  p2_kick <= 0;
        //assert (p2_state == AT_REST);
     //   #100
        p2_punch <= 1;
        #100
        //assert (p2_state == PUNCHING);
        //p2_x_in <= 700; //move out of range
        //#100
        //assert (p2_state == AT_REST);
        p2_punch <= 0;
     //   p1_kick <= 1;
       // #100
      //  p1_kick <= 0; // expect to stay in kick state until p1 driven down
      //  p2_punch <= 1; // stay in punch state since not driven down      
      //  p2_state_testing <= PUNCHING;
       // #10
    end
    

endmodule //timer_tb

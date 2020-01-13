`timescale 1ns / 1ps


module player_move(
    input vclock_in,        // 65MHz clock
    input pixel_clk,        // 100mhz clock
    input reset_in,         // 1 to initialize module
    input is_p1,            // 1 if is player 1 2 if is player 2
    //input [1:0] p1_motion,     // 0 for at rest, 1 for kicking, 2 for punching
    //input [1:0] p2_motion,  // 0 for rest, 1 for kicking, 2 for punching
    input [10:0] initial_x_p1,        // player starting location
    input [10:0] initial_x_p2,        // player starting location
    input p1_right_in,         // 1 when player 1 should move right
    input p1_left_in,          // 1 when player 1 should move left
    input p2_right_in,         // 1 when player 2 should move right
    input p2_left_in,          // 1 when player 2 should move left
    input [3:0] pspeed_in,  // puck speed in pixels/tick 
    input [10:0] hcount_in, // horizontal index of current pixel (0..1023)
    input [9:0]  vcount_in, // vertical index of current pixel (0..767)
    input hsync_in,         // XVGA horizontal sync signal (active low)
    input vsync_in,         // XVGA vertical sync signal (active low)
    input blank_in,         // XVGA blanking (1 means output black pixel)
    
    // controll for player combat
    input p1_kick,
    input p1_punch,
    input p2_kick,
    input p2_punch,
     
    // hitpoints    
    output logic [6:0] hp,
    // output logic [6:0] p2_hp,
    
    output logic phsync_out,       // pong game's horizontal sync
    output logic pvsync_out,       // pong game's vertical sync
    output logic pblank_out,       // pong game's blanking
    output [11:0] pixel_out  // pong game's pixel  // r=11:7, g=7:3, b=3:0 
    );
    
   parameter WIDTH = 64;
   parameter HEIGHT = 64;
   logic[10:0] x_in_p1; // player 1 in left of screen x
   logic[10:0] x_in_p2; // player 2 in right of screen x
   
   logic[4:0] buffer = 0;//(pspeed_in << 1) + 1; // account for two players moving against each other at same time
   
   wire[11:0] p1_pixel, p2_pixel;
   assign pixel_out =  is_p1 ? p1_pixel : p2_pixel;
   logic vsync_old; // keeping track of vsync state to see if it has changed from 0 to 1
   
   // expose hitpoints
   logic [6:0] p1_hitpoints, p2_hitpoints;
   assign hp = is_p1 ? p1_hitpoints : p2_hitpoints;

    wire [1:0] p1_state, p2_state; 
    
    player_1_blob #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) p1_blob(.pixel_clk_in(vclock_in), .motion(p1_state), .x_in(x_in_p1), .hcount_in(hcount_in), .y_in(500), .vcount_in(vcount_in), .pixel_out(p1_pixel));
    
    player_2_blob #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) p2_blob(.pixel_clk_in(vclock_in), .motion(p1_state), .x_in(x_in_p2), .hcount_in(hcount_in), .y_in(500), .vcount_in(vcount_in), .pixel_out(p2_pixel));
    
    // Game Logic
    game_state game(
    .pixel_clk(pixel_clk),        // 100MHz clock
    .reset_in(reset_in),         // 1 to initialize module
    .p1_x_in(x_in_p1), // player 1's x position
    .p2_x_in(x_in_p2),  // player 2's x position
    .p1_kick(p1_kick),
    .p1_punch(p1_punch),
    .p2_kick(p2_kick),
    .p2_punch(p2_punch),
    
    .p1_state(p1_state),
    .p2_state(p2_state),
    .p1_hitpoints(p1_hitpoints),
    .p2_hitpoints(p2_hitpoints)
    );
    
    
     // initialize everything
    always @(posedge vclock_in) begin
        phsync_out <= hsync_in;
        pvsync_out <= vsync_in;
        pblank_out <= blank_in;
    end    
    
    
    always @(posedge vclock_in) begin
        if(reset_in) begin
            x_in_p1 <= initial_x_p1;
            x_in_p2 <= initial_x_p2;
        end else begin
            vsync_old <= vsync_in;
            if(vsync_in == 1'b1 && vsync_old == 1'b0) begin
                player_1_move;
                player_2_move;
            end
        end
    end
    
    task player_1_move;
        begin
            if(p1_right_in) begin
               if((x_in_p1 + WIDTH + buffer) >= x_in_p2) begin // if player 2 is overlaping with player 1, stop motion
                    x_in_p1 <= x_in_p1; //stay still
                end else begin
                    x_in_p1 <= x_in_p1 + pspeed_in; // otherwise move to the right
                end 
            end else if(p1_left_in) begin
                if(x_in_p1 <= 0) begin // if player one is going off the screen, stop motion
                    x_in_p1 <= x_in_p1;
                end else begin
                    x_in_p1 <= x_in_p1 - pspeed_in; // otherwise move to the left
                end
            end
        end
    endtask 
 
    task player_2_move;
        begin
            if(p2_right_in) begin
                if(x_in_p2 >= (1024 - WIDTH)) begin
                    x_in_p2 <= x_in_p2; // stay still
                end else begin
                    x_in_p2 <= x_in_p2 + pspeed_in; 
                end
            end else if(p2_left_in) begin
                if(x_in_p2 <= (x_in_p1 + WIDTH + buffer)) begin
                    x_in_p2 <= x_in_p2;
                end else begin
                    x_in_p2 <= x_in_p2 - pspeed_in;
                end
            end
        end
    endtask  

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2019 03:14:47 PM
// Design Name: 
// Module Name: player_move
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module player_move(
  input vclock_in,        // 65MHz clock
  input reset_in,         // 1 to initialize module
  input is_p1,            // 1 if is player 1 2 if is player 2
  input [1:0] motion,     // 0 for at rest, 1 for kicking, 2 for punching
   input initial_x,        // player starting location
   input right_in,         // 1 when player 1 should move right
   input left_in,          // 1 when player 2 should move left
   input [3:0] pspeed_in,  // puck speed in pixels/tick 
   input [10:0] hcount_in, // horizontal index of current pixel (0..1023)
   input [9:0]  vcount_in, // vertical index of current pixel (0..767)
   input hsync_in,         // XVGA horizontal sync signal (active low)
   input vsync_in,         // XVGA vertical sync signal (active low)
   input blank_in,         // XVGA blanking (1 means output black pixel)
        
   output logic phsync_out,       // pong game's horizontal sync
   output logic pvsync_out,       // pong game's vertical sync
   output logic pblank_out,       // pong game's blanking
   output [11:0] pixel_out  // pong game's pixel  // r=11:7, g=7:3, b=3:0 
    );
    
   logic[10:0] x_in = initial_x; // player 1 in left of screen x
   logic x_dir = 1'b1;  // 1 means going to the right, 0 means left; starts moving right
   //wire[11:0] at_rest_pixel;
   //wire[11:0] kicking_pixel;
   //assign pixel_out = at_rest_pixel | kicking_pixel;
   wire[11:0] p1_pixel, p2_pixel;
   assign pixel_out =  is_p1 ? p1_pixel : p2_pixel;
   logic vsync_old; // keeping track of vsync state to see if it has changed from 0 to 1


    
    player_1_blob  #(.WIDTH(64), .HEIGHT(64)) p1_blob(.pixel_clk_in(vclock_in), .motion(motion), .x_in(x_in), .hcount_in(hcount_in), .y_in(500), .vcount_in(vcount_in), .pixel_out(p1_pixel));
    
    player_2_blob #(.WIDTH(64), .HEIGHT(64)) p2_blob(.pixel_clk_in(vclock_in), .motion(motion), .x_in(x_in), .hcount_in(hcount_in), .y_in(100), .vcount_in(vcount_in), .pixel_out(p2_pixel));
    // player_1_blob  #(.WIDTH(64), .HEIGHT(64)) p1_kicking_blob(.pixel_clk_in(vclock_in), .motion(2'b01), .x_in(x_in), .hcount_in(hcount_in), .y_in(300), .vcount_in(vcount_in), .pixel_out(kicking_pixel));

    
     // initialize everything and blend square and death star
    always @(posedge vclock_in) begin
        phsync_out <= hsync_in;
        pvsync_out <= vsync_in;
        pblank_out <= blank_in;
    end    
    
    
    always @(posedge vclock_in) begin
        vsync_old <= vsync_in;
        if(vsync_in == 1'b1 && vsync_old == 1'b0) begin
            player_move;
        end
    end
    
    task player_move;
        begin
            if(right_in) begin
                x_in <= x_in + pspeed_in; 
            end else if(left_in) begin
                x_in <= x_in - pspeed_in;
            end
        end
    endtask 
  

endmodule

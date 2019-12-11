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
  input [1:0] p1_motion,     // 0 for at rest, 1 for kicking, 2 for punching
  input [1:0] p2_motion,  // 0 for rest, 1 for kicking, 2 for punching
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
        
   output logic phsync_out,       // pong game's horizontal sync
   output logic pvsync_out,       // pong game's vertical sync
   output logic pblank_out,       // pong game's blanking
   output [11:0] pixel_out  // pong game's pixel  // r=11:7, g=7:3, b=3:0 
    );
    
   parameter WIDTH = 64;
   parameter HEIGHT = 64;
   logic[10:0] x_in_p1 = initial_x_p1; // player 1 in left of screen x
   logic[10:0] x_in_p2 = initial_x_p2; // player 2 in right of screen x

   wire[11:0] p1_pixel, p2_pixel;
   assign pixel_out =  is_p1 ? p1_pixel : p2_pixel;
   logic vsync_old; // keeping track of vsync state to see if it has changed from 0 to 1


    
    player_1_blob  #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) p1_blob(.pixel_clk_in(vclock_in), .motion(p1_motion), .x_in(x_in_p1), .hcount_in(hcount_in), .y_in(500), .vcount_in(vcount_in), .pixel_out(p1_pixel));
    
    player_2_blob #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) p2_blob(.pixel_clk_in(vclock_in), .motion(p2_motion), .x_in(x_in_p2), .hcount_in(hcount_in), .y_in(500), .vcount_in(vcount_in), .pixel_out(p2_pixel));
    
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
                if(is_p1) begin
                    player_1_move;
                end else begin
                    player_2_move;
                end
            end
        end
    end
    
    task player_1_move;
        begin
            if(p1_right_in) begin
               if(x_in_p2 <= (x_in_p1 + WIDTH)) begin
                    x_in_p1 <= x_in_p1; //stay still
                end
                x_in_p1 <= x_in_p1 + pspeed_in; 
            end else if(p1_left_in) begin
                if(x_in_p1 < 0) begin
                    x_in_p1 <= x_in_p1;
                end
                x_in_p1 <= x_in_p1 - pspeed_in;
            end
        end
    endtask 
 
     task player_2_move;
        begin
            if(p2_right_in) begin
                if(x_in_p2 >= (1024 - WIDTH)) begin
                    x_in_p2 <= x_in_p2; // stay still
                end
                x_in_p2 <= x_in_p2 + pspeed_in; 
            end else if(p2_left_in) begin
                if(x_in_p2 <= (x_in_p1 + WIDTH)) begin
                    x_in_p2 <= x_in_p2;
                end
                x_in_p2 <= x_in_p2 - pspeed_in;
            end
        end
    endtask  

endmodule

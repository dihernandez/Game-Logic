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
  // input up_in,            // 1 when paddle should move up
  // input down_in,          // 1 when paddle should move down
   input player_1,          //1 if player 1 (move from left edge) or 0 for ployer2 (move from right edge)
   input right_in,         // 1 when paddle should move right
   input left_in,          // 1 when paddle should move left
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
    
   logic[10:0] x_in = 11'd384; // puck in center of screen x
   logic x_dir = 1'b1;  // 1 means going to the right, 0 means left; starts moving right
   wire[11:0] player_pixel;
   assign pixel_out = player_pixel;

    
    picture_blob  #(.WIDTH(64), .HEIGHT(64)) p1_rest_blob(.pixel_clk_in(vclock_in), .x_in(x_in), .hcount_in(hcount_in), .y_in(500), .vcount_in(vcount_in), .pixel_out(player_pixel));
    
     // initialize everything and blend square and death star
    always @(posedge vclock_in) begin
        phsync_out <= hsync_in;
        pvsync_out <= vsync_in;
        pblank_out <= blank_in;
    end    
    
    
    always @(posedge vclock_in) begin
        if(player_1) begin
            p1_move;
        end //else begin
            //p2_move;
        //end
    end
    
    task p1_move;
        begin
            if(right_in) begin
                x_in <= x_in + pspeed_in; 
            end else if(left_in) begin
                x_in <= x_in - pspeed_in;
            end
        end
    endtask // move_left
   // blob #(32, 128, 12'hFFF) paddle(.x_in(paddle_x_in), .hcount_in(hcount_in), .vcount_in(vcount_in), .pixel_out(paddle_pixel));
  

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2019 02:53:59 PM
// Design Name: 
// Module Name: display_blob
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


module main(
   input clk_100mhz,
   input[15:0] sw,
   input btnc, btnu, btnl, btnr, btnd,
   output[3:0] vga_r,
   output[3:0] vga_b,
   output[3:0] vga_g,
   output vga_hs,
   output vga_vs
//   output led16_b, led16_g, led16_r,
//   output led17_b, led17_g, led17_r,
//   output[15:0] led,
//   output ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp
//   output[7:0] an    // Display location 0-7
    );
    
    wire clk_65mhz;
    clk_wiz_final clkdivider(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz), .reset(0));
    
    wire [10:0] hcount;    // pixel on current line
    wire [9:0] vcount;     // line number
    wire hsync, vsync;
    wire [11:0] p1_rest_pixel;
    wire [11:0] player_1_pixel;
    wire [11:0] player_2_pixel;
    reg [11:0] rgb;    
    wire blank;
    xvga xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount),
          .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));
          
        // btnc button is user reset
    wire reset;
    debounce db1(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnc),.clean_out(reset));
   
   
    // UP, DOWN, LEFT, RIGHT buttons for punching and kicking
    wire up, down, left, right;
    debounce db2(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnu),.clean_out(up));
    debounce db3(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnd),.clean_out(down));
    debounce db4(.reset_in(reset),.clock_in(clk_65mhz), .noisy_in(btnr), .clean_out(right));
    debounce db5(.reset_in(reset),.clock_in(clk_65mhz), .noisy_in(btnl), .clean_out(left));
      
          
    //display score------------------------------------------------------------------------------------      
    logic [11:0] p1_ones_pixel, p2_ones_pixel, p1_tens_pixel, p2_tens_pixel, p1_hundred_pixel, p2_hundred_pixel;
    logic [6:0] player_1_hp, player_2_hp;
    
    logic [3:0] p1_ones_digit, p1_tens_digit, p1_hundred_digit;
    logic [3:0] p2_ones_digit, p2_tens_digit, p2_hundred_digit;
    assign p1_ones_digit = 7; 
    assign p2_ones_digit = 9;
    
    number_display p1_ones_score(.clk(clk_65mhz), .x_in(100), .digit(p1_ones_digit), .hcount_in(hcount), .y_in(10), .vcount_in(vcount), .pixel_out(p1_ones_pixel));
    number_display p2_ones_score(.clk(clk_65mhz), .x_in(600), .digit(p2_ones_digit), .hcount_in(hcount), .y_in(10), .vcount_in(vcount), .pixel_out(p2_ones_pixel));
    
    number_display p1_tens_score(.clk(clk_65mhz), .x_in(148), .digit(p1_tens_digit), .hcount_in(hcount), .y_in(10), .vcount_in(vcount), .pixel_out(p1_tens_pixel));
    number_display p2_tens_score(.clk(clk_65mhz), .x_in(648), .digit(p2_tens_digit), .hcount_in(hcount), .y_in(10), .vcount_in(vcount), .pixel_out(p2_tens_pixel));
    
    // for testing--------------------------------------------------------------------------------
    wire [1:0] p1_motion = sw[5:4]; //use switches 5 and 4 to select between at rest, kicking, and punching
    wire [1:0] p2_motion = sw[3:2]; //use switches 3 and 2 to select between at rest, kicking, and punching

    wire phsync,pvsync,pblank;
    

    // define players and their movement logic
    
    player_move move_player_1(
    .vclock_in(clk_65mhz),        // 65MHz clock
    .reset_in(reset),         // 1 to initialize module
   .is_p1(1), 
   .initial_x_p1(100),      // p1 initial position used when is_p1 is high
   .initial_x_p2(600),         // p2 0 default when p1 selected
   .p1_right_in(sw[15]),         // 1 when player 1 should move right
   .p1_left_in(sw[14]),          // 1 when player 1 should move left
   .p2_right_in(sw[7]),         // 1 when player 2 should move right
   .p2_left_in(sw[6]),          // 1 when player 2 should move left
   .pspeed_in(4),  // player speed in pixels/tick 
   .hcount_in(hcount), // horizontal index of current pixel (0..1023)
   .vcount_in(vcount), // vertical index of current pixel (0..767)
   .hsync_in(hsync),         // XVGA horizontal sync signal (active low)
   .vsync_in(vsync),         // XVGA vertical sync signal (active low)
   .blank_in(blank),         // XVGA blanking (1 means output black pixel)
   .phsync_out(phsync),       // pong game's horizontal sync
   .pvsync_out(pvsync),       // pong game's vertical sync
   .pblank_out(pblank),       // pong game's blanking
    
     // player combat
    .p1_kick(btnd),
    .p1_punch(btnr),
    .p2_kick(btnu),
    .p2_punch(btnl),
     
     .p1_hp(player_1_hp),
     .p2_hp(player_2_hp),   
    .pixel_out(player_1_pixel)
   );
   
    player_move move_player_2(
    .vclock_in(clk_65mhz),        // 65MHz clock
    .reset_in(reset),         // 1 to initialize module

   .is_p1(0),
   .initial_x_p1(100),
   .initial_x_p2(600),
   .p1_right_in(sw[15]),         // 1 when player 1 should move right
   .p1_left_in(sw[14]),          // 1 when player 1 should move left
   .p2_right_in(sw[7]),         // 1 when player 2 should move right
   .p2_left_in(sw[6]),          // 1 when player 2 should move left
   .pspeed_in(4),  // player speed in pixels/tick 
   .hcount_in(hcount), // horizontal index of current pixel (0..1023)
   .vcount_in(vcount), // vertical index of current pixel (0..767)
   .hsync_in(hsync),         // XVGA horizontal sync signal (active low)
   .vsync_in(vsync),         // XVGA vertical sync signal (active low)
   .blank_in(blank),         // XVGA blanking (1 means output black pixel)
   .phsync_out(phsync),       // pong game's horizontal sync
   .pvsync_out(pvsync),       // pong game's vertical sync
   .pblank_out(pblank),       // pong game's blanking

    // player combat
    .p1_kick(btnd),
    .p1_punch(btnr),
    .p2_kick(btnu),
    .p2_punch(btnl),

        
   .pixel_out(player_2_pixel)
   );
    
    // .phsync_out(phsync),.pvsync_out(pvsync),.pblank_out(pblank), DON'T YOU FORGET ABOUT ME!!!! 
    
    wire [11:0] pixel;
    assign pixel = player_1_pixel | player_2_pixel | p1_ones_pixel | p2_ones_pixel | p1_tens_pixel | p2_tens_pixel | p1_hundred_pixel | p2_hundred_pixel;
    
    wire border = (hcount==0 | hcount==1023 | vcount==0 | vcount==767 |
                   hcount == 512 | vcount == 384);

    reg b,hs,vs;
    always_ff @(posedge clk_65mhz) begin
      if (sw[1:0] == 2'b01) begin
         // 1 pixel outline of visible area (white)
         hs <= hsync;
         vs <= vsync;
         rgb <= {12{border}};
         b <= blank;
      end else if (sw[1:0] == 2'b10) begin
         // color bars
         hs <= hsync;
         vs <= vsync;
         b <= blank;
         rgb <= {{4{hcount[8]}}, {4{hcount[7]}}, {4{hcount[6]}}} ;
      end else begin
         // default: pong
         hs <= hsync;
         vs <= vsync;
         b <= blank;
         rgb <= pixel;
      end
    end
    
    // the following lines are required for the Nexys4 VGA circuit - do not change
    assign vga_r = ~b ? rgb[11:8]: 0;
    assign vga_g = ~b ? rgb[7:4] : 0;
    assign vga_b = ~b ? rgb[3:0] : 0;

    assign vga_hs = ~hs;
    assign vga_vs = ~vs;
    

    
    
endmodule

//////////////////////////////////////////////////////////////////////
//
// sprites: display sprites
//
//////////////////////////////////////////////////////////////////////

module display_sprites (); 
endmodule

//////////////////////////////////////////////////////////////////////
//
// blob: generate rectangle on screen
//
//////////////////////////////////////////////////////////////////////
module blob
   #(parameter WIDTH = 64,            // default width: 64 pixels
               HEIGHT = 64,           // default height: 64 pixels
               COLOR = 12'hFFF)  // default color: white
   (input [10:0] x_in,hcount_in,
    input [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   always_comb begin
      if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) &&
	 (vcount_in >= y_in && vcount_in < (y_in+HEIGHT)))
	       pixel_out = COLOR;
      else pixel_out = 0;
   end
endmodule

////////////////////////////////////////////////////
//
// player_1_blob display player 1
//
//////////////////////////////////////////////////
module player_1_blob
   #(parameter WIDTH = 256,     // default picture width
     parameter HEIGHT = 240,   // default picture height
     parameter REST_IMAGE_OFFSET = 0,
     parameter KICK_IMAGE_OFFSET = 4096,
     parameter PUNCH_IMAGE_OFFSET = 8192
     ) 
   (input pixel_clk_in,
    input [1:0] motion, // 0 is at rest, 1 is kicking, 2 is punching
    input [10:0] x_in,hcount_in,
    input [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

    logic [13:0] image_addr;   // num of bits for 64*192 pixel ROM 12288
    logic [7:0] image_bits, red_mapped, blue_mapped, green_mapped;

   logic [13:0] offset;
   assign image_addr = ((hcount_in-x_in) + (vcount_in-y_in) * WIDTH) + offset;
   
   always @ (posedge pixel_clk_in) begin
     if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) &&
          (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
        case (motion)
            2'b00 : begin
                offset <= REST_IMAGE_OFFSET; 
            end
            
            2'b01 : begin
                offset <= KICK_IMAGE_OFFSET; 
            end
            
            2'b10 : begin
                 offset <= PUNCH_IMAGE_OFFSET;
            end
            
            default : begin 
                 offset <= REST_IMAGE_OFFSET;
            end 
        endcase
        pixel_out <= {red_mapped[3:0], green_mapped[3:0], blue_mapped[3:0]};
     end else begin
        pixel_out <= 'h000;
     end
   end
 
   p1_motions p1_motions(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits)); // rest


   p1_motions_red p1_rest_red(.clka(pixel_clk_in), .addra(image_bits), .douta(red_mapped));
   p1_motions_green p1_rest_green(.clka(pixel_clk_in), .addra(image_bits), .douta(green_mapped));
   p1_motions_blue p1_rest_blue(.clka(pixel_clk_in), .addra(image_bits), .douta(blue_mapped));


endmodule



module player_2_blob
   #(parameter WIDTH = 256,     // default picture width
     parameter HEIGHT = 240,  // default picture height
     parameter REST_IMAGE_OFFSET = 0,
     parameter KICK_IMAGE_OFFSET = 4096,
     parameter PUNCH_IMAGE_OFFSET = 8192
     )  
   (input pixel_clk_in,
    input [1:0] motion, // 0 is at rest, 1 is kicking, 2 is punching
    input [10:0] x_in,hcount_in,
    input [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

    logic [13:0] image_addr;   // num of bits for 64*192 pixel ROM 12288
    logic [7:0] image_bits, red_mapped, blue_mapped, green_mapped;

    logic [13:0] offset;
    assign image_addr = ((hcount_in-x_in) + (vcount_in-y_in) * WIDTH) + offset;
   
    always @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) &&
          (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
        case (motion)
            2'b00 : begin
                offset <= REST_IMAGE_OFFSET; 
            end
            
            2'b01 : begin
                offset <= KICK_IMAGE_OFFSET; 
            end
            
            2'b10 : begin
                 offset <= PUNCH_IMAGE_OFFSET;
            end
            
            default : begin 
                 offset <= REST_IMAGE_OFFSET;
            end 
        endcase
        pixel_out <= {red_mapped[3:0], green_mapped[3:0], blue_mapped[3:0]};
     end else begin
        pixel_out <= 'h000;
     end
   end
 
   p2_motions p2_motions(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits)); // rest


   p2_motions_red p2_rest_red(.clka(pixel_clk_in), .addra(image_bits), .douta(red_mapped));
   p2_motions_green p2_rest_green(.clka(pixel_clk_in), .addra(image_bits), .douta(green_mapped));
   p2_motions_blue p2_rest_blue(.clka(pixel_clk_in), .addra(image_bits), .douta(blue_mapped));

endmodule

module number_display #(
    parameter WIDTH = 48,            // default width: 64 pixel
               HEIGHT = 48,           // default height: 64 pixels
               COLOR = 12'hFFF,
               NUMBER_OFFSET = 2304 // the value to offset by in order to change number display value
)  // default color: white
    (
        input clk,
        input [10:0] x_in, hcount_in,
        input [9:0] y_in,vcount_in,
        input[3:0] digit, // the value to display
        output logic [11:0] pixel_out
    );
    
    logic [14:0] image_addr;   // num of bits for 23040 line COE
    logic [7:0] image_bits;
    logic [14:0] num_index;
    
    assign num_index = image_addr + digit*NUMBER_OFFSET;
    assign image_addr = ((hcount_in-x_in) + (vcount_in-y_in) * WIDTH);

    numbers num(.clka(clk), .addra(num_index), .douta(image_bits));
    
    always @(posedge clk) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) &&
          (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            pixel_out <= {image_bits[3:0], image_bits[3:0], image_bits[3:0]};
        end
    end  
endmodule

//////////////////////////////////////////////////////////////////////////////////
// Update: 8/8/2019 GH 
// Create Date: 10/02/2015 02:05:19 AM
// Module Name: xvga
//
// xvga: Generate VGA display signals (1024 x 768 @ 60Hz)
//
//                              ---- HORIZONTAL -----     ------VERTICAL -----
//                              Active                    Active
//                    Freq      Video   FP  Sync   BP      Video   FP  Sync  BP
//   640x480, 60Hz    25.175    640     16    96   48       480    11   2    31
//   800x600, 60Hz    40.000    800     40   128   88       600     1   4    23
//   1024x768, 60Hz   65.000    1024    24   136  160       768     3   6    29
//   1280x1024, 60Hz  108.00    1280    48   112  248       768     1   3    38
//   1280x720p 60Hz   75.25     1280    72    80  216       720     3   5    30
//   1920x1080 60Hz   148.5     1920    88    44  148      1080     4   5    36
//
// change the clock frequency, front porches, sync's, and back porches to create 
// other screen resolutions
////////////////////////////////////////////////////////////////////////////////

module xvga(input vclock_in,
            output reg [10:0] hcount_out,    // pixel number on current line
            output reg [9:0] vcount_out,     // line number
            output reg vsync_out, hsync_out,
            output reg blank_out);

   parameter DISPLAY_WIDTH  = 1024;      // display width
   parameter DISPLAY_HEIGHT = 768;       // number of lines

   parameter  H_FP = 24;                 // horizontal front porch
   parameter  H_SYNC_PULSE = 136;        // horizontal sync
   parameter  H_BP = 160;                // horizontal back porch

   parameter  V_FP = 3;                  // vertical front porch
   parameter  V_SYNC_PULSE = 6;          // vertical sync 
   parameter  V_BP = 29;                 // vertical back porch

   // horizontal: 1344 pixels total
   // display 1024 pixels per line
   reg hblank,vblank;
   wire hsyncon,hsyncoff,hreset,hblankon;
   assign hblankon = (hcount_out == (DISPLAY_WIDTH -1));    
   assign hsyncon = (hcount_out == (DISPLAY_WIDTH + H_FP - 1));  //1047
   assign hsyncoff = (hcount_out == (DISPLAY_WIDTH + H_FP + H_SYNC_PULSE - 1));  // 1183
   assign hreset = (hcount_out == (DISPLAY_WIDTH + H_FP + H_SYNC_PULSE + H_BP - 1));  //1343

   // vertical: 806 lines total
   // display 768 lines
   wire vsyncon,vsyncoff,vreset,vblankon;
   assign vblankon = hreset & (vcount_out == (DISPLAY_HEIGHT - 1));   // 767 
   assign vsyncon = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP - 1));  // 771
   assign vsyncoff = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP + V_SYNC_PULSE - 1));  // 777
   assign vreset = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP + V_SYNC_PULSE + V_BP - 1)); // 805

   // sync and blanking
   wire next_hblank,next_vblank;
   assign next_hblank = hreset ? 0 : hblankon ? 1 : hblank;
   assign next_vblank = vreset ? 0 : vblankon ? 1 : vblank;
   always_ff @(posedge vclock_in) begin
      hcount_out <= hreset ? 0 : hcount_out + 1;
      hblank <= next_hblank;
      hsync_out <= hsyncon ? 0 : hsyncoff ? 1 : hsync_out;  // active low

      vcount_out <= hreset ? (vreset ? 0 : vcount_out + 1) : vcount_out;
      vblank <= next_vblank;
      vsync_out <= vsyncon ? 0 : vsyncoff ? 1 : vsync_out;  // active low

      blank_out <= next_vblank | (next_hblank & ~hreset);
   end
   
endmodule


///////////////////////////////////////////////////////////////////////////////
//
// Pushbutton Debounce Module (video version - 24 bits)  
//
///////////////////////////////////////////////////////////////////////////////

module debounce (input reset_in, clock_in, noisy_in,
                 output reg clean_out);

   reg [19:0] count;
   reg new_input;

   always_ff @(posedge clock_in)
     if (reset_in) begin 
        new_input <= noisy_in; 
        clean_out <= noisy_in; 
        count <= 0; end
     else if (noisy_in != new_input) begin new_input<=noisy_in; count <= 0; end
     else if (count == 1000000) clean_out <= new_input;
     else count <= count+1;


endmodule

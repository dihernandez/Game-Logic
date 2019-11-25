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


module display_blob(
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
    reg [11:0] rgb;    
    wire blank;
    xvga xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount),
          .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));
          
    picture_blob  #(.WIDTH(64), .HEIGHT(64)) p1_rest_blob(.pixel_clk_in(clk_65mhz), .x_in(256), .hcount_in(hcount), .y_in(256), .vcount_in(vcount), .pixel_out(p1_rest_pixel));
    
    // .phsync_out(phsync),.pvsync_out(pvsync),.pblank_out(pblank), DON'T YOU FORGET ABOUT ME!!!! 
    
    wire [11:0] white_square_pixel;
    blob white_square(.x_in(0), .hcount_in(hcount), .y_in(0), .vcount_in(vcount), .pixel_out(white_square_pixel));
    wire [11:0] pixel;
    assign pixel = white_square_pixel | p1_rest_pixel;
       // btnc button is user reset
    wire reset;
    debounce db1(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnc),.clean_out(reset));
   
    // UP, DOWN, LEFT, RIGHT buttons for pong paddle
    wire up, down, left, right;
    debounce db2(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnu),.clean_out(up));
    debounce db3(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnd),.clean_out(down));
    debounce db4(.reset_in(reset),.clock_in(clk_65mhz), .noisy_in(btnr), .clean_out(right));
    debounce db5(.reset_in(reset),.clock_in(clk_65mhz), .noisy_in(btnl), .clean_out(left));

    
    
    

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
// picture_blob: display a picture
//
//////////////////////////////////////////////////
module picture_blob
   #(parameter WIDTH = 256,     // default picture width
     parameter HEIGHT = 240)    // default picture height
   (input pixel_clk_in,
    input [10:0] x_in,hcount_in,
    input [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [11:0] image_addr;   // num of bits for 64*64 pixel ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped; //can I chage to [2:0]?

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   p1_at_rest_rom p1_at_rest(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));
   // use color map to create 4 bits R, 4 bits G, 4 bits B
   // since the image is greyscale, just replicate the red pixels
   // and not bother with the other two color maps.
   p1_at_rest_blue p1_rest_blue (.clka(pixel_clk_in), .addra(image_bits), .douta(blue_mapped));
   p1_at_rest_green p1_rest_green(.clka(pixel_clk_in), .addra(image_bits), .douta(green_mapped));
   p1_at_rest_green p1_rest_red(.clka(pixel_clk_in), .addra(image_bits), .douta(red_mapped));

   //green_coe gcm (.clka(pixel_clk_in), .addra(image_bits), .douta(green_mapped));
   //blue_coe bcm (.clka(pixel_clk_in), .addra(image_bits), .douta(blue_mapped));
   // note the one clock cycle delay in pixel!
   always @ (posedge pixel_clk_in) begin
     if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) &&
          (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
        // use MSB 4 bits
        pixel_out <= {red_mapped, green_mapped, blue_mapped}; //{red_mapped[7:4], red_mapped[7:4], red_mapped[7:4]}; // greyscale
        //pixel_out <= {red_mapped[7:4], 8'h0}; // only red hues
        //pixel_out <= 'hFFF;
     end else begin
        pixel_out <= 'h000;
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


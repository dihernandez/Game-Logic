`timescale 1ns / 1ps


module player_move(
    input pixel_clk,        // 65mhz clock
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
    output [11:0] pixel_out, // pong game's pixel  // r=11:7, g=7:3, b=3:0 
    
    // for testing
    output[1:0] state // changed from single bit, fixes LED state display
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
    assign state = is_p1 ? p1_state : p2_state; 
    
    player_1_blob #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) p1_blob(.pixel_clk_in(pixel_clk), .motion(p1_state), .x_in(x_in_p1), .hcount_in(hcount_in), .y_in(500), .vcount_in(vcount_in), .pixel_out(p1_pixel));
    
    player_2_blob #(.WIDTH(WIDTH), .HEIGHT(HEIGHT)) p2_blob(.pixel_clk_in(pixel_clk), .motion(p2_state), .x_in(x_in_p2), .hcount_in(hcount_in), .y_in(500), .vcount_in(vcount_in), .pixel_out(p2_pixel));
    
    // Game Logic
    game_state game(
    .pixel_clk(pixel_clk),        // 65MHz clock
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
    always @(posedge pixel_clk) begin
        phsync_out <= hsync_in;
        pvsync_out <= vsync_in;
        pblank_out <= blank_in;
    end    
    
    
    always @(posedge pixel_clk) begin
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

// borrowed from lab 1

module seven_seg_controller(input               clk_in,
                            input               rst_in,
                            input [31:0]        val_in,
                            output logic[7:0]   cat_out,
                            output logic[7:0]   an_out
    );
  
    logic[7:0]      segment_state;
    logic[31:0]     segment_counter;
    logic [3:0]     routed_vals;
    logic [6:0]     led_out;
    
    binary_to_seven_seg my_converter ( .val_in(routed_vals), .led_out(led_out));
    assign cat_out = ~led_out;
    assign an_out = ~segment_state;

    
    always_comb begin
        case(segment_state)
            8'b0000_0001:   routed_vals = val_in[3:0];
            8'b0000_0010:   routed_vals = val_in[7:4];
            8'b0000_0100:   routed_vals = val_in[11:8];
            8'b0000_1000:   routed_vals = val_in[15:12];
            8'b0001_0000:   routed_vals = val_in[19:16];
            8'b0010_0000:   routed_vals = val_in[23:20];
            8'b0100_0000:   routed_vals = val_in[27:24];
            8'b1000_0000:   routed_vals = val_in[31:28];
            default:        routed_vals = val_in[3:0];       
        endcase
    end
    
    always_ff @(posedge clk_in)begin
        if (rst_in)begin
            segment_state <= 8'b0000_0001;
            segment_counter <= 32'b0;
        end else begin
            if (segment_counter == 32'd100_000)begin
                segment_counter <= 32'd0;
                segment_state <= {segment_state[6:0],segment_state[7]};
            end else begin
                segment_counter <= segment_counter +1;
            end
        end
    end
        
endmodule //seven_seg_controller


module binary_to_seven_seg ( input [3:0] val_in, output logic [6:0] led_out);
    always @(val_in)
    begin
        case(val_in)
            4'b0000 : led_out <= 7'b0111111; //0
            4'b0001 : led_out <= 7'b0000110; //1
            4'b0010 : led_out <= 7'b1011011; //2 
            4'b0011 : led_out <= 7'b1001111; //3
            4'b0100 : led_out <= 7'b1100110; // 4
            4'b0101 : led_out <= 7'b1101101;  //5
            4'b0110 : led_out <= 7'b1111101; // 6
            4'b0111 : led_out <= 7'b0000111; //7
            4'b1000 : led_out <= 7'b1111111; //8
            4'b1001 : led_out <= 7'b1101111; //9
            4'b1010 : led_out <= 7'b1110111; // A 
            4'b1011 : led_out <= 7'b1111100; //B
            4'b1100 : led_out <= 7'b0111001; // C
            4'b1101 : led_out <= 7'b1011110; //D
            4'b1110 : led_out <= 7'b1111001; //E
            4'b1111 : led_out <= 7'b1110001; //F
            default : led_out <= 7'b0000000; //defualt           
        endcase
    end
endmodule // binary_to_seven


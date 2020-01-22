`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2019 07:31:21 PM
// Design Name: 
// Module Name: game_state
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


module game_state(
    input pixel_clk,        // 5MHz clock
    input reset_in,         // 1 to initialize module
    input [10:0] p1_x_in, // player 1's x position
    input [10:0] p2_x_in,  // player 2's x position
    input p1_kick,
    input p1_punch,
    input p2_kick,
    input p2_punch,

    
    output [1:0] p1_state,
    output [1:0] p2_state,
    output[6:0] p1_hitpoints,
    output[6:0] p2_hitpoints,
    // for testing
    input[8:0] distance_p1_to_p2_testing,
    input[1:0] p2_state_testing
    );
    
    parameter AT_REST = 2'b00;
    parameter KICKING = 2'b01;
    parameter PUNCHING = 2'b10;

    parameter KICKING_DISTANCE = 32;
    parameter PUNCHING_DISTANCE = 64;
 
    logic[6:0] p1_hp = 100;
    logic[6:0] p2_hp = 100;
    assign p1_hitpoints = p1_hp;
    assign p2_hitpoints = p2_hp;
    
    logic[11:0] distance_p1_to_p2, distance_p2_to_p1, distance_between;
    
    // keep track of when hit action was initiated
    // what behaviour to expect when counter value is exceeded
    logic[8:0] p1_hit_time_stamp = 0;
    logic[8:0] p2_hit_time_stamp = 0;
    logic[8:0] cycle_counter = 0;
    
    logic p1_hit, p2_hit; // keep track of when a hit has landed to avoid multiple point deductions
    
    // keep track of toggled punches and kicks. This fixes the bug where lots of rapid punches took place while the button is pressed down
    logic p1_punch_previous = 0;
    logic p2_punch_previous = 0;
    logic p1_kick_previous = 0;
    logic p2_kick_previous = 0;
    logic p1_punch_on, p2_punch_on, p1_kick_on, p2_kick_on, p1_punch_off, p2_punch_off, p1_kick_off, p2_kick_off;
    assign p1_punch_on = ((p1_punch_previous == 0) && (p1_punch == 1)); //check if attack button has been let go
    assign p2_punch_on = ((p2_punch_previous == 0) && (p2_punch == 1)); 
    assign p1_kick_on = ((p1_kick_previous == 0) && (p1_kick == 1));
    assign p2_kick_on = ((p2_kick_previous == 0) && (p2_kick == 1)); 
    assign p1_punch_off = ((p1_punch_previous == 1) && (p1_punch == 0)); //check if attack button has been let go
    assign p2_punch_off = ((p2_punch_previous == 1) && (p2_punch == 0)); 
    assign p1_kick_off = ((p1_kick_previous == 1) && (p1_kick == 0));
    assign p2_kick_off = ((p2_kick_previous == 1) && (p2_kick == 0)); 

    
    logic[1:0] player_1_state = AT_REST;
    logic[1:0] p1_next_state;
    logic[1:0] player_2_state = AT_REST;
    logic[1:0] p2_next_state;
    assign p1_state = player_1_state;
    assign p2_state = player_2_state;
    
    // handle p1 state logic. NOTE: can interact wtih state 2 logic
    always @(posedge pixel_clk) begin
        if (reset_in) begin
            cycle_counter <= 0;
            player_1_state <= AT_REST;
            player_2_state <= AT_REST;
            p1_hit <= 0;
            p2_hit <= 0;
            p1_hp <= 100;
            p2_hp <= 100;
            p1_punch_previous <= 0;
            p2_punch_previous <= 0;
            p1_kick_previous <= 0;
            p2_kick_previous <= 0;
        end else begin
            cycle_counter <= cycle_counter + 1; // only need one counter
            player_1_state <= p1_next_state;
            player_2_state <= p2_next_state;
            
            p1_punch_previous <= p1_punch;
            p1_kick_previous <= p1_kick;
            p2_punch_previous <= p2_punch;
            p2_kick_previous <= p2_kick;
            
            distance_p1_to_p2 <= p2_x_in - (p1_x_in + 64); // offset for p1 width
            distance_p2_to_p1 <= (p1_x_in + 64) - p2_x_in;
            // account for overflow error
            distance_between <= distance_p1_to_p2 < distance_p2_to_p1 ? distance_p1_to_p2 : distance_p2_to_p1;
            case(p1_state)
                AT_REST: begin // stay here unless signals to move or attack
                    if(p1_punch_on && (distance_between < PUNCHING_DISTANCE)) begin
                        p1_next_state <= PUNCHING;
                        p1_hit_time_stamp <= cycle_counter;
                    end else // punching takes precedense over kicking, arbitrary
                    if(p1_kick_on &&  (distance_between < KICKING_DISTANCE)) begin
                        p1_next_state <= KICKING;
                        p1_hit_time_stamp <= cycle_counter;
                    end
                end
                
                PUNCHING: begin
                    if (p1_punch_off) begin
                        p1_next_state <= AT_REST;
                        p1_hit <= 0;
                    end else
                    if(p2_state == PUNCHING && !p1_hit) begin
                        if(p1_hit_time_stamp < p2_hit_time_stamp) begin 
                            p2_hp <= (p2_hp >= 5) ? (p2_hp - 5) : 0;
                            p1_hit <= 1;
                        end
                    end else 
                    if(!p1_hit) begin
                        p2_hp <= (p2_hp >= 5) ? (p2_hp - 5) : 0;
                        p1_hit <= 1;
                    end else begin
                        p1_next_state <= AT_REST;
                    end
    
                    p1_hit_time_stamp <= 0;
                end
                
                KICKING: begin
                    if (p1_kick_off) begin
                        p1_next_state <= AT_REST;
                        p1_hit <= 0;
                    end else
                    // handle both in kicking state
                    if(p2_state == KICKING && !p1_hit) begin
                        if(p1_hit_time_stamp < p2_hit_time_stamp) begin
                            p2_hp <= (p2_hp >= 10) ? (p2_hp - 10) : 0;
                            p1_hit <= 1;
                        end
                    end else
                     if(!p1_hit) begin // note: changed from p2_hit at 2:18 pm Jan 15th
                        p2_hp <= (p2_hp >= 10) ? (p2_hp - 10) : 0;
                        p1_hit <= 1;
                    end else begin
                        p1_next_state <= AT_REST;
                    end
                    p1_hit_time_stamp <= 0;
                end
                
                default: p1_next_state <= AT_REST;
            endcase
        //end
        
        // handle p2 state logic. NOTE: can interact wtih state 1 logic
        //always @(posedge pixel_clk) begin
            player_2_state <= p2_next_state;
            case(p2_state) /// p2_state_testing
                AT_REST: begin
                    if(p2_punch_on && (distance_between < PUNCHING_DISTANCE)) begin
                        p2_next_state <= PUNCHING;
                        p2_hit_time_stamp <= cycle_counter;
                    end else // punching takes precedence over kicking, arbitrary
                    if(p2_kick_on && (distance_between < KICKING_DISTANCE)) begin
                        p2_next_state <= KICKING;
                        p2_hit_time_stamp <= cycle_counter; // will the counter overflow?
                    end
                end
                
                PUNCHING: begin
                    if (p2_punch_off) begin
                        p2_next_state <= AT_REST;
                        p2_hit <= 0;
                    end else
                    if(p1_state == PUNCHING && !p2_hit) begin 
                        //if(p2_hit_time_stamp < p1_hit_time_stamp) begin // is p2_hit_time_stamp ever < p1_hit_time_stamp?
                            p1_hp <= (p1_hp >= 5) ? p1_hp - 5 : 0;
                            p2_hit <= 1;
                        //end
                    end else 
                    if (!p2_hit) begin
                        p1_hp <= (p1_hp >= 5) ? p1_hp - 5 : 0;
                        p2_hit <= 1;
                    end
                    
                    p2_hit_time_stamp <= 0;
                end
                
                // THIS IS DIFFERENT LOGIC
                KICKING: begin
                    if (p2_kick_off) begin
                        p2_next_state <= AT_REST;
                        p2_hit <= 0;
                    end else
                     // handle both in kicking state
                    if(p1_state == KICKING && !p2_hit) begin
                        //if(p2_hit_time_stamp < p1_hit_time_stamp && !p2_hit) begin
                            p1_hp <= (p1_hp >= 10) ? p1_hp - 10 : 0;
                            p2_hit <= 1; // added at 2:28pm 1/15
                        //end
                    end 
                    else
                     if (!p2_hit) begin
                        p1_hp <= (p1_hp >= 10) ? p1_hp - 10 : 0;
                        p2_hit <= 1;
                    end
                    p2_hit_time_stamp <= 0;
                end
            
            default: p2_next_state <= AT_REST;
            endcase
        end
    end

endmodule

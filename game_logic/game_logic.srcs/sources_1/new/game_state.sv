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
    input vclock_in,        // 65MHz clock
    //.reset_in(reset),         // 1 to initialize module
    input p1_x_in, // player 1's x position
    input p2_x_in,  // player 2's x position
    
    input p1_left,
    input p1_right,
    input p1_kick,
    input p1_punch,
    
    input p2_left,
    input p2_right,
    input p2_kick,
    input p2_punch
    );
    
    parameter AT_REST = 3'b000;
    parameter MOVING_BACKWARDS = 3'b001;
    parameter MOVING_FORWARDS = 3'b010;
    parameter KICKING = 3'b011;
    parameter PUNCHING = 3'b100;

    parameter KICKING_DISTANCE = 32;
    parameter PUNCHING_DISTANCE = 64;

    logic[6:0] p1_hitpoints = 100;
    logic[6:0] p2_hitpoints = 100;
 
    
    logic[8:0] distance_p1_to_p2_current;
    logic[8:0] distance_p1_to_p2_previous;

    logic[8:0] distance_p2_to_p1_current;
    logic[8:0] distance_p2_to_p1_previous;  
    
    // keep track of when hit action was initiated
    // what behaviour to expect when value is exceeded
    logic[8:0] p1_hit_time_stamp = 0;
    logic[8:0] p2_hit_time_stamp = 0;
    logic[8:0] cycle_counter = 0;
    
    logic[2:0] p1_state = AT_REST;
    logic[2:0] p1_next_state;
    logic[2:0] p2_state = AT_REST;
    logic[2:0] p2_next_state;
    
    // handle p1 state logic. NOTE: can interact wtih state 2 logic
    always @(posedge vclock_in) begin
        cycle_counter <= cycle_counter + 1;
        case(p1_state)
            AT_REST: begin // stay here unless signals to move or attack
                if(p1_punch &&  distance_p1_to_p2_current < PUNCHING_DISTANCE) begin
                    p1_next_state <= PUNCHING;
                    p1_hit_time_stamp <= cycle_counter;
                end
            end
            PUNCHING: begin
                // handle both in punching state
                if(p2_state == PUNCHING) begin
                    if(p1_hit_time_stamp < p2_hit_time_stamp) begin
                        p2_hitpoints <= p2_hitpoints - 5;
                    end
                end else begin
                    p2_hitpoints <= p2_hitpoints - 5;
                end
                
            end
            
            default: p1_state <= AT_REST;
        endcase
    end
    
    // handle p2 state logic. NOTE: can interact wtih state 1 logic
    always @(posedge vclock_in) begin
        case(p2_state)
            AT_REST: begin
                if(p2_punch && distance_p2_to_p1_current < PUNCHING_DISTANCE) begin
                    p2_next_state <= PUNCHING;
                    p2_hit_time_stamp <= cycle_counter;
                end
            end
            PUNCHING: begin
                // handle both in punching state
                if(p1_state == PUNCHING) begin
                    if(p2_hit_time_stamp < p1_hit_time_stamp) begin
                        p1_hitpoints <= p1_hitpoints - 5;
                    end
                end else begin
                    p1_hitpoints <= p1_hitpoints - 5;
                end
            end
        
        default: p2_state <= AT_REST;
        endcase
    end

    
    
    
endmodule

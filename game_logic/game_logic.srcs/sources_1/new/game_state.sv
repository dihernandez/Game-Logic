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
    input p2_x_in  // player 2's x position
    );
    
    parameter AT_REST = 3'b000;
    parameter MOVING_BACKWARDS = 3'b001;
    parameter MOVING_FORWARDS = 3'b010;
    parameter KICKING = 3'b011;
    parameter PUNCHING = 3'b100;
    
    logic[2:0] state = AT_REST;
    logic[2:0] next_state;
    
    always @(posedge vclock_in) begin
        case(state)
            AT_REST: begin
                
            end
            
            
            default: state <= AT_REST;
        endcase
    end

    
    
    
endmodule

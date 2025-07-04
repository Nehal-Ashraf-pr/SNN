`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:29:42 02/21/2025 
// Design Name: 
// Module Name:    Controller 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module Controller #(
    parameter delay = 70,
    parameter layer_delay = 15
)(
    input wire clk,
    input wire neuron_reset,
    input vs_in,
    input hs_in,
    input de_in,
    output reg res_ly_1,
    output reg res_ly_2,
    output reg vs_out,
    output reg hs_out,
    output reg de_out
);

    // Use individual registers instead of packed arrays
    reg [delay-1:0] vs_delay = 0;
    reg [delay-1:0] hs_delay = 0;
    reg [delay-1:0] de_delay = 0;
    
    // Layer reset delay lines
    reg [layer_delay-1:0] ly1_delay = 0;
    reg [2*layer_delay-1:0] ly2_delay = 0;

    // Shift register implementation with constant indices
    always @(posedge clk) begin
        // Main signal pipeline - use constant indices
        vs_delay <= {vs_delay[delay-2:0], vs_in};
        hs_delay <= {hs_delay[delay-2:0], hs_in};
        de_delay <= {de_delay[delay-2:0], de_in};

        // Layer reset pipelines
        ly1_delay <= {ly1_delay[layer_delay-2:0], neuron_reset};
        ly2_delay <= {ly2_delay[2*layer_delay-2:0], neuron_reset};

        // Output assignments
        vs_out <= vs_delay[delay-1];
        hs_out <= hs_delay[delay-1];
        de_out <= de_delay[delay-1];
        
        // Staggered layer resets
        res_ly_1 <= ly1_delay[layer_delay-1];
        res_ly_2 <= ly2_delay[2*layer_delay-1];
    end

    // Initial reset handling
    initial begin
        vs_delay = 0;
        hs_delay = 0;
        de_delay = 0;
        ly1_delay = 0;
        ly2_delay = 0;
    end
endmodule

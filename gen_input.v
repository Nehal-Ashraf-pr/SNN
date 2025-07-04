`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:11:57 04/03/2025 
// Design Name: 
// Module Name:    gen_input 
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

module gen_input(
    input clk,
    input reset,
    input [7:0] r_st,
    input [7:0] g_st,
    input [7:0] b_st,
    output reg r_sp,
    output reg g_sp,
    output reg b_sp
);

// 16-bit LFSR for better randomness (matches original VHDL design)
reg [15:0] random = 16'hACE1;  // Standard LFSR seed

always @(posedge clk) begin
    if (reset) begin
        random <= 16'hACE1;  // Reset to known state
    end else begin
        // Improved LFSR polynomial: x^16 + x^14 + x^13 + x^11 + 1
        random <= {random[14:0], random[15] ^ random[13] ^ random[12] ^ random[10]};
    end
end

// Spike generation with proper threshold comparison
always @(posedge clk) begin
    // Use lower 8 bits for threshold comparison
    r_sp <= (random[7:0] < r_st) ? 1'b1 : 1'b0;
    g_sp <= (random[7:0] < g_st) ? 1'b1 : 1'b0; 
    b_sp <= (random[7:0] < b_st) ? 1'b1 : 1'b0;
end


// Add this to monitor spike generation
always @(posedge clk) begin
  $display("[GEN_INPUT] Time=%0t: Spikes: r_sp=%b g_sp=%b b_sp=%b", 
           $time, r_sp, g_sp, b_sp);
end


endmodule

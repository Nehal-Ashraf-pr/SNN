`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:52:43 04/03/2025 
// Design Name: 
// Module Name:    neuron 
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
module neuron #(
    parameter signed [7:0] w_0 = 0, w_1 = 0, w_2 = 0, w_3 = 0, w_4 = 0, w_5 = 0, w_6 = 0,
    parameter signed [7:0] bias = 0,
    parameter [7:0] v_th = 256
)(
    input wire clk,
    input wire sp_0, sp_1, sp_2, sp_3, sp_4, sp_5, sp_6,
    input wire neuron_reset,
    output reg spike_out
);

    // Signed voltage and sum for proper negative/positive accumulation
    reg signed [8:0] voltage = 0; // 9 bits to avoid overflow
    reg signed [8:0] sum;

    always @(posedge clk) begin
        if (neuron_reset) begin
            voltage <= 0;
            spike_out <= 0;
        end else begin
            // Weighted sum of spikes plus bias
            sum = bias
                + (sp_0 ? w_0 : 0)
                + (sp_1 ? w_1 : 0)
                + (sp_2 ? w_2 : 0)
                + (sp_3 ? w_3 : 0)
                + (sp_4 ? w_4 : 0)
                + (sp_5 ? w_5 : 0)
                + (sp_6 ? w_6 : 0);

            voltage <= voltage + sum;

            // Spike generation and reset
            if (voltage >= $signed({1'b0, v_th})) begin
                spike_out <= 1'b1;
                voltage <= voltage - $signed({1'b0, v_th});
            end else begin
                spike_out <= 1'b0;
            end
        end

        // Debug: print voltage, threshold, and spike
        if (|{sp_0, sp_1, sp_2, sp_3, sp_4, sp_5, sp_6}) begin
            $display("[NEURON] Time=%0t: voltage=%0d threshold=%0d spike_out=%b", $time, voltage, v_th, spike_out);
        end
    end

endmodule


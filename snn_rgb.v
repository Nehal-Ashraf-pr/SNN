/*`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:40:59 04/03/2025 
// Design Name: 
// Module Name:    snn_rgb 
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

module snn_rgb (
    input wire clk, reset_n,
    input wire [2:0] enable_in,
    input wire vs_in, hs_in, de_in,
    input wire [7:0] r_in, g_in, b_in,
    output reg vs_out, hs_out, de_out,
    output reg [7:0] r_out, g_out, b_out,
    output wire clk_o,
    output wire [2:0] led
);

    //input FFs
	 reg vs_0, hs_0, de_0, vs_q, de_q;wire
	 //output 
	 vs_1, hs_1, de_1;
    reg r_out_1, g_out_1, b_out_1, reset;
    (* KEEP = "TRUE" *) wire h_0, h_1, h_2, h_3, h_4, h_5, h_6, out_0, out_1;
    (* KEEP = "TRUE" *) wire r_sp, g_sp, b_sp;reg neuron_reset = 1'b1, frame_reset = 1'b1;
	 wire res_ly_1, res_ly_2;
    reg[7:0] r_0, g_0, b_0, step;
	 
	 always @(posedge clk) begin
  if (de_in) begin
    $display("[DUT] Time=%0t: Received inputs: r_in=%d g_in=%d b_in=%d", 
             $time, r_in, g_in, b_in);
  end
end
    
	 parameter sp_steps = 32, v_th = 64, n_sp_to_activate = 20, ltc_delay = 5, total_delay = sp_steps + ltc_delay;
    Controller #(.delay(total_delay),.layer_delay(5)) control(.clk(clk),
	                                                     .neuron_reset(neuron_reset),.vs_in(vs_0),
																		  .hs_in(hs_0),.de_in(de_0),
																		  .res_ly_1(res_ly_1),.res_ly_2(res_ly_2),
																		  .vs_out(vs_1),.hs_out(hs_1),.de_out(de_1));
	   

    gen_input pseudo_random(.clk(clk),.reset(frame_reset),.r_st(r_0),.g_st(g_0),.b_st(b_0),
	                         .r_sp(r_sp),.g_sp(g_sp),.b_sp(b_sp));	
									 
    // Declare each weight as a separate parameter (NO ARRAYS!)
    
	 neuron #(.w_0(8), .w_1(37), .w_2(141),.bias(69),.v_th(v_th))hidden0 (.clk(clk),
	                                                         .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp),
                                                            .sp_3(1'b0), .sp_4(1'b0), .sp_5(1'b0),.sp_6(1'b0),																				
                                                            .neuron_reset(res_ly_1),.spike_out(h_0));

    neuron #(.w_0(44), .w_1(25), .w_2(-73),.bias(124),.v_th(v_th))hidden1 (.clk(clk),
	                                                         .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp),
                                                            .sp_3(1'b0), .sp_4(1'b0), .sp_5(1'b0),.sp_6(1'b0),																				
                                                            .neuron_reset(res_ly_1),.spike_out(h_1));

    neuron #(.w_0(20), .w_1(-39), .w_2(-23),.bias(8),.v_th(v_th))hidden2 (.clk(clk),
	                                                         .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), 
																				.sp_3(1'b0), .sp_4(1'b0), .sp_5(1'b0),.sp_6(1'b0),
                                                            .neuron_reset(res_ly_1),.spike_out(h_2));

    neuron #(.w_0(137), .w_1(72), .w_2(-113),.bias(20),.v_th(v_th))hidden3 (.clk(clk),
	                                                         .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), 
																				.sp_3(1'b0), .sp_4(1'b0), .sp_5(1'b0),.sp_6(1'b0),
                                                            .neuron_reset(res_ly_1),.spike_out(h_3));

    neuron #(.w_0(7), .w_1(45), .w_2(-37),.bias(-25),.v_th(v_th))hidden4 (.clk(clk),
	                                                         .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), 
																				.sp_3(1'b0), .sp_4(1'b0), .sp_5(1'b0),.sp_6(1'b0),
                                                            .neuron_reset(res_ly_1),.spike_out(h_4));

    neuron #(.w_0(81), .w_1(33), .w_2(55),.bias(-57),.v_th(v_th))hidden5 (.clk(clk),
	                                                         .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), 
																				.sp_3(1'b0), .sp_4(1'b0), .sp_5(1'b0),.sp_6(1'b0),
                                                            .neuron_reset(res_ly_1),.spike_out(h_5));

    neuron #(.w_0(-89), .w_1(0), .w_2(132),.bias(33),.v_th(v_th))hidden6 (.clk(clk),
	                                                         .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), 
																				.sp_3(1'b0), .sp_4(1'b0), .sp_5(1'b0),.sp_6(1'b0),
                                                            .neuron_reset(res_ly_1),.spike_out(h_6));



    // Output Layer Neurons with individual weight parameters
    neuron //#(.w_0(196), .w_1(-295), .w_2(74), .w_3(-275), .w_4(110), .w_5(-178),
             //.w_6(349),.bias(57),.v_th(v_th))
				 #(.w_0(50), .w_1(-50), .w_2(50), .w_3(-50), .w_4(50), .w_5(-50), .w_6(50),
    .bias(30), .v_th(64))  
				output0 (.clk(clk), .sp_0(h_0), .sp_1(h_1), .sp_2(h_2),
                    .sp_3(h_3), .sp_4(h_4), .sp_5(h_5),.sp_6(h_6),.neuron_reset(res_ly_2),
                    .spike_out(out_0));
						  
    neuron //#(.w_0(-255), .w_1(57), .w_2(-171), .w_3(497), .w_4(-108), .w_5(9),
             //.w_6(-386),.bias(92),.v_th(v_th))
				 #(
    .w_0(-50), .w_1(50), .w_2(-50), .w_3(50), 
    .w_4(-50), .w_5(50), .w_6(-50),
    .bias(30), .v_th(64)
)
				output1 (.clk(clk),.sp_0(h_0), .sp_1(h_1), .sp_2(h_2),
                    .sp_3(h_3), .sp_4(h_4), .sp_5(h_5),.sp_6(h_6),.neuron_reset(res_ly_2),
                    .spike_out(out_1));
						  
   reg [7:0] num_out0_sp = 0, num_out1_sp = 0; // Initialized counters

    always @(posedge clk) begin
        reset <= ~reset_n;
        {vs_0, hs_0, de_0} <= {vs_in, hs_in, de_in};
        {vs_q, de_q} <= {vs_0, de_0};
        {r_0, g_0, b_0} <= {r_in, g_in, b_in};

        frame_reset <= (vs_0 == 1'b1 && vs_q == 1'b0) ? 1'b1 : 1'b0;

        if ((de_q && !de_1) || (de_0 && step >= sp_steps)) begin
            step <= 1;
            neuron_reset <= 1'b1;
        end 
        else if (de_0) begin
            step <= step + 1;
            neuron_reset <= 1'b0;
        end 
        else begin
            step <= 1;
            neuron_reset <= 1'b0;
        end

        if (out_0) num_out0_sp <= num_out0_sp + 1;
        if (out_1) num_out1_sp <= num_out1_sp + 1;

    if (res_ly_2) begin
    $display("[DUT] PRE-ASSIGN: out0_spikes=%0d out1_spikes=%0d", num_out0_sp, num_out1_sp);
    if (num_out0_sp > num_out1_sp)
        {r_out, g_out, b_out} <= {8'd0, 8'd0, 8'd255};  // Blue
    else if (num_out1_sp > num_out0_sp)
        {r_out, g_out, b_out} <= {8'd255, 8'd255, 8'd0}; // Yellow
    else
        {r_out, g_out, b_out} <= {8'd0, 8'd0, 8'd0};    // Black
    $display("[DUT] POST-ASSIGN: r_out=%0d g_out=%0d b_out=%0d", r_out, g_out, b_out);
    num_out0_sp <= 0;
    num_out1_sp <= 0;
end

    {vs_out, hs_out, de_out} <= {vs_1, hs_1, de_1};
end
always @(posedge clk) begin
              if (de_out) begin
                 $display("[DUT] Time=%0t: Producing outputs: r_out=%d g_out=%d b_out=%d", 
                 $time, r_out, g_out, b_out);
                    end
              end

    
    

    assign clk_o = clk;
    assign led = {out_0, out_1, 1'b0};

endmodule*/


`timescale 1ns / 1ps

module snn_rgb (
    input wire clk, reset_n,
    input wire [2:0] enable_in,
    input wire vs_in, hs_in, de_in,
    input wire [7:0] r_in, g_in, b_in,
    output reg vs_out, hs_out, de_out,
    output reg [7:0] r_out, g_out, b_out,
    output wire clk_o,
    output wire [2:0] led
);

    // Internal signals
    reg vs_0, hs_0, de_0, vs_q, de_q;
    wire vs_1, hs_1, de_1;
    reg reset;
    wire h_0, h_1, h_2, h_3, h_4, h_5, h_6, out_0, out_1;
    wire r_sp, g_sp, b_sp;
    reg neuron_reset = 1'b1, frame_reset = 1'b1;
    wire res_ly_1, res_ly_2;
    reg [7:0] r_0, g_0, b_0, step;
    
    // Spike counters with initialization
    reg [7:0] num_out0_sp = 0;
    reg [7:0] num_out1_sp = 0;

    // Parameters (matches reference design)
    parameter sp_steps = 64;
    parameter v_th = 256;
    parameter n_sp_to_activate = 25;
    parameter ltc_delay = 11;
    parameter total_delay = sp_steps + ltc_delay;

    // Debug input monitoring
    always @(posedge clk) begin
        if (de_in) begin
            $display("[DUT] Input RGB: %0d,%0d,%0d", r_in, g_in, b_in);
        end
    end

    // Instantiate Controller with proper parameters
    Controller #(
        .delay(total_delay),
        .layer_delay(5)
    ) control (
        .clk(clk),
        .neuron_reset(neuron_reset),
        .vs_in(vs_0),
        .hs_in(hs_0),
        .de_in(de_0),
        .res_ly_1(res_ly_1),
        .res_ly_2(res_ly_2),
        .vs_out(vs_1),
        .hs_out(hs_1),
        .de_out(de_1)
    );

    // Instantiate input generator with 16-bit LFSR
    gen_input pseudo_random (
        .clk(clk),
        .reset(frame_reset),
        .r_st(r_0),
        .g_st(g_0),
        .b_st(b_0),
        .r_sp(r_sp),
        .g_sp(g_sp),
        .b_sp(b_sp)
    );

    // Hidden layer neurons with signed parameters
    neuron #(.w_0(8),  .w_1(37),  .w_2(141), .bias(69),  .v_th(v_th)) hidden0 (.clk(clk), .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), .neuron_reset(res_ly_1), .spike_out(h_0));
    neuron #(.w_0(44), .w_1(25),  .w_2(-73), .bias(124), .v_th(v_th)) hidden1 (.clk(clk), .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), .neuron_reset(res_ly_1), .spike_out(h_1));
    neuron #(.w_0(20), .w_1(-39), .w_2(-23), .bias(8),   .v_th(v_th)) hidden2 (.clk(clk), .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), .neuron_reset(res_ly_1), .spike_out(h_2));
    neuron #(.w_0(137),.w_1(72),  .w_2(-113),.bias(20),  .v_th(v_th)) hidden3 (.clk(clk), .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), .neuron_reset(res_ly_1), .spike_out(h_3));
    neuron #(.w_0(7),  .w_1(45),  .w_2(-37), .bias(-25), .v_th(v_th)) hidden4 (.clk(clk), .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), .neuron_reset(res_ly_1), .spike_out(h_4));
    neuron #(.w_0(81), .w_1(33),  .w_2(55),  .bias(-57), .v_th(v_th)) hidden5 (.clk(clk), .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), .neuron_reset(res_ly_1), .spike_out(h_5));
    neuron #(.w_0(-89),.w_1(0),   .w_2(132), .bias(33),  .v_th(v_th)) hidden6 (.clk(clk), .sp_0(r_sp), .sp_1(g_sp), .sp_2(b_sp), .neuron_reset(res_ly_1), .spike_out(h_6));

    // Output layer neurons with balanced parameters
    neuron #(
        .w_0(196), .w_1(-295), .w_2(74), .w_3(-275),
        .w_4(110), .w_5(-178), .w_6(349),
        .bias(57), .v_th(v_th)
    ) output0 (
        .clk(clk),
        .sp_0(h_0), .sp_1(h_1), .sp_2(h_2),
        .sp_3(h_3), .sp_4(h_4), .sp_5(h_5), .sp_6(h_6),
        .neuron_reset(res_ly_2),
        .spike_out(out_0)
    );

    neuron #(
        .w_0(-255), .w_1(57), .w_2(-171), .w_3(497),
        .w_4(-108), .w_5(9), .w_6(-386),
        .bias(92), .v_th(v_th)
    ) output1 (
        .clk(clk),
        .sp_0(h_0), .sp_1(h_1), .sp_2(h_2),
        .sp_3(h_3), .sp_4(h_4), .sp_5(h_5), .sp_6(h_6),
        .neuron_reset(res_ly_2),
        .spike_out(out_1)
    );

    // Main processing pipeline
    always @(posedge clk) begin
        reset <= ~reset_n;
        {vs_0, hs_0, de_0} <= {vs_in, hs_in, de_in};
        {vs_q, de_q} <= {vs_0, de_0};
        {r_0, g_0, b_0} <= {r_in, g_in, b_in};

        // Frame reset detection
        frame_reset <= (vs_0 && !vs_q) ? 1'b1 : 1'b0;

        // Neuron reset logic
        if ((de_q && !de_1) || (de_0 && step >= sp_steps)) begin
            step <= 1;
            neuron_reset <= 1'b1;
        end else if (de_0) begin
            step <= step + 1;
            neuron_reset <= 1'b0;
        end else begin
            step <= 1;
            neuron_reset <= 1'b0;
        end

        // Spike counting with reset protection
        if (!res_ly_2) begin
            if (out_0) num_out0_sp <= num_out0_sp + 1;
            if (out_1) num_out1_sp <= num_out1_sp + 1;
        end

        // Output assignment at frame end
        if (res_ly_2) begin
            casex({num_out0_sp >= n_sp_to_activate, num_out1_sp >= n_sp_to_activate})
                2'b1x: {r_out, g_out, b_out} <= {8'd0, 8'd0, 8'd255};  // Blue
                2'bx1: {r_out, g_out, b_out} <= {8'd255, 8'd255, 8'd0}; // Yellow
                default: {r_out, g_out, b_out} <= {8'd0, 8'd0, 8'd0};  // Black
            endcase
            num_out0_sp <= 0;
            num_out1_sp <= 0;
        end

        // Video signal pipeline
        {vs_out, hs_out, de_out} <= {vs_1, hs_1, de_1};
    end

    // Debug output monitoring
    always @(posedge clk) begin
        if (de_out) begin
            $display("[DUT] Output RGB: %0d,%0d,%0d", r_out, g_out, b_out);
        end
    end

    assign clk_o = clk;
    assign led = {out_0, out_1, 1'b0};

endmodule



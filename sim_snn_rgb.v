`timescale 1ns / 1ps

module sim_snn_rgb;

  parameter CLK_PERIOD = 10;
  parameter H_RES = 640;
  parameter V_RES = 480;
  parameter H_BLANK = 100;
  parameter V_BLANK = 10;
  parameter FRAMES = 2;
  parameter PIPELINE_DELAY = 76;

  reg clk, reset_n;
  reg vs_in, hs_in, de_in;
  reg [7:0] r_in, g_in, b_in;
  wire [7:0] r_out, g_out, b_out;
  wire vs_out, hs_out, de_out;

  integer x, y, frame;
  integer input_file, output_file;
  integer pixels_processed = 0;
  integer output_delay = 0;
  integer width, height, maxval;
  reg [255:0] line_local;
  integer status;
  integer found_magic, found_dims, found_maxval;
  integer test_mode;

  snn_rgb dut (
    .clk(clk),
    .reset_n(reset_n),
    .vs_in(vs_in),
    .hs_in(hs_in),
    .de_in(de_in),
    .r_in(r_in),
    .g_in(g_in),
    .b_in(b_in),
    .vs_out(vs_out),
    .hs_out(hs_out),
    .de_out(de_out),
    .r_out(r_out),
    .g_out(g_out),
    .b_out(b_out)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // Reset
  initial begin
    reset_n = 0;
    #(CLK_PERIOD*5) reset_n = 1;
  end

  // VCD (ignored in ISE)
  initial begin
    $dumpfile("snn_wave.vcd");
    $dumpvars(0, sim_snn_rgb);
  end

  // Remove newlines and whitespace
  function [255:0] clean_line;
    input [255:0] str;
    integer i;
    begin
      for (i = 0; i < 256; i = i + 8) begin
        if (str[i+:8] == "\n" || str[i+:8] == "\r" || str[i+:8] == 8'd0 || str[i+:8] == " " || str[i+:8] == "\t") begin
          str[i+:8] = 8'd0;
        end
      end
      clean_line = str;
    end
  endfunction

  // PPM header parser (Verilog-2001 compatible)
  task parse_ppm_header;
  input integer file;
  output integer width, height, maxval;
  reg [8*100:1] line;
  reg [8*10:1] magic;
  integer code;
  begin
    found_magic = 0;
    found_dims = 0;
    found_maxval = 0;

    while (!(found_magic && found_dims && found_maxval)) begin
      code = $fgets(line, file);
      if (code <= 0) begin
        $display("[ERROR] Unexpected EOF while reading header.");
        $finish;
      end

      // Remove comment lines
      if (line[8*1 +: 8] == "#") begin
        // Skip
      end
      else if (!found_magic) begin
        if ($sscanf(line, "%s", magic) == 1 && magic == "P3") begin
          found_magic = 1;
          $display("[INFO] Found magic P3");
        end
      end
      else if (!found_dims) begin
        if ($sscanf(line, "%d %d", width, height) == 2) begin
          found_dims = 1;
          $display("[INFO] Dimensions: %0d x %0d", width, height);
        end
      end
      else if (!found_maxval) begin
        if ($sscanf(line, "%d", maxval) == 1) begin
          found_maxval = 1;
          $display("[INFO] Maxval: %0d", maxval);
        end
      end
    end
  end
endtask


  // Input drive task
  task drive_input;
    begin
      test_mode = 0;
      input_file = $fopen("A59_snap.ppm", "r");
      if (input_file == 0) begin
        $display("[WARNING] Cannot open input file. Using test pattern.");
        test_mode = 1;
      end else begin
        parse_ppm_header(input_file, width, height, maxval);
      end

      for (frame = 0; frame < FRAMES; frame = frame + 1) begin
        for (y = 0; y < V_RES + V_BLANK; y = y + 1) begin
          for (x = 0; x < H_RES + H_BLANK; x = x + 1) begin
            vs_in = (y == 0) ? 1 : 0;
            hs_in = (x < H_RES) ? 1 : 0;
            de_in = (x < H_RES && y < V_RES) ? 1 : 0;

            if (de_in) begin
              if (test_mode) begin
                r_in = (x + y) % 256;
                g_in = (x * 2) % 256;
                b_in = (y * 2) % 256;
              end else begin
                if ($fscanf(input_file, "%d %d %d", r_in, g_in, b_in) != 3) begin
                  $display("[WARNING] Invalid pixel data, using default black.");
                  r_in = 0; g_in = 0; b_in = 0;
                end
              end
            end else begin
              r_in = 0; g_in = 0; b_in = 0;
            end

            #(CLK_PERIOD);
          end
        end
      end

      if (!test_mode) $fclose(input_file);
      $display("[INFO] Finished feeding input.");
    end
  endtask

  task monitor_output;
    begin
      $display("[INFO] Starting output monitor...");
      output_file = $fopen("output.ppm", "w");
      $fdisplay(output_file, "P3");
      $fdisplay(output_file, "%0d %0d", H_RES, V_RES);
      $fdisplay(output_file, "255");

      while (1) begin
        @(posedge clk);
        if (de_out) begin
          if (output_delay < PIPELINE_DELAY) begin
            output_delay = output_delay + 1;
          end else begin
            $fdisplay(output_file, "%0d %0d %0d", r_out, g_out, b_out);
            pixels_processed = pixels_processed + 1;
            if (pixels_processed > width*height) begin
              $display("[INFO] Stopping after 1000 pixels.");
              $fclose(output_file);
              $finish;
            end
          end
        end
      end
    end
  endtask

  initial begin
    wait(reset_n == 1);
    #(CLK_PERIOD * 10);
    fork
      drive_input();
      monitor_output();
    join
  end

endmodule

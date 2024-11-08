/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_idann (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  //assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in,  1'b0};

// wire w0_i, w1_i, w2_i, w3_i;
// assign w0_i = enable_signal_from_sm ? value_from_backpass : value_from_pytorch_init
//hidden_neuron hn3 (.clk_i(clk), .rst_i(rst), .en_i(), .x_i(4'hA), .w0_i(), .w1_i(), .w2_i(), .w3_i(), .hidden_neuron_o());

wire [15:0] lfsr_top_o;

lfsr lfsr_test (.clk_i(clk), .rst_i(rst_n), .en_i(1'b1), .lfsr_o(lfsr_top_o));

assign uo_out = lfsr_top_o[7:0];


endmodule
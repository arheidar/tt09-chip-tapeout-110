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
//assign w0_i 
wire [9:0] hn0_o, hn1_o;
wire [41:0] loss_val_o;
wire [20:0] final_o;


hidden_neuron hn0 (.clk_i(clk), .rst_i(rst_n), .en_i(1), .x_i(4'hA), .w0_i(8'b1), .w1_i(2), .w2_i(3), .w3_i(4), .hidden_neuron_o(hn0_o));

hidden_neuron hn1 (.clk_i(clk), .rst_i(rst_n), .en_i(1), .x_i(4'hA), .w0_i(1), .w1_i(2), .w2_i(3), .w3_i(4), .hidden_neuron_o(hn1_o));

output_neuron on0 (.clk_i(clk), .rst_i(rst_n), .en_i(1), .init_i(4'hA), .x0_i(hn0_o), .x1_i(hn1_o), .w0_i(5), w1_i(8), .loss_o(loss_val), .final_o(final_o));

// wire [15:0] lfsr_top_o;

// lfsr lfsr_test (.clk_i(clk), .rst_i(rst_n), .en_i(1'b1), .lfsr_o(lfsr_top_o));

assign uo_out = final_o[7:0];


endmodule

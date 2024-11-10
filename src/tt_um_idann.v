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
wire [9:0] hn0_o, hn1_o, hn2_o, hn3_o, hn4_o, hn5_o, hn6_o, hn7_o;
//wire [37:0] loss_o;
wire [22:0] final_o;
wire f0p_o, f1p_o, bp_o, fpass_over_o, zero_loss_o, zero_final_o, zero_weight_update_o, zero_end_check_o;
wire b_end0_o, b_end1_o;
//b_end1_o, b_end2_o, b_end3_o, b_end4_o, b_end5_o, b_end6_o, b_end7_o;
wire [15:0] on_weights_o;
//assign w0_i = (f1p_o) ? 1 :;

//state_mach sm0 (.clk_i(clk), .rst_i(rst_n), .en_i(1), .init_i(ui_in[7]), .f_end_i(1'b0), .f0_pass_o(f0p_o), .f1_pass_o(f1p_o), .b_pass_o(bp_o));
state_mach state_mach_inst (.clk_i(clk), .rst_i(rst_n), .en_i(1), .init_i(ui_in[7]), .f_end_i(fpass_over_o), .b_end_i(b_end0_o & b_end1_o), .zero_end_check_i(zero_end_check_o), .zero_loss_o(zero_loss_o), .zero_final_o(zero_final_o), .zero_weight_update_o(zero_weight_update_o), .f0_pass_o(f0p_o), .f1_pass_o(f1p_o), .b_pass_o(bp_o));

hidden_neuron hn0 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o | f1p_o), .x_i(ui_in[3:0]), .w0_i(8'b01100010), .w1_i(8'b01111100), .w2_i(8'b01111101), .w3_i(8'b01101010), .hidden_neuron_o(hn0_o));

hidden_neuron hn1 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o | f1p_o), .x_i(ui_in[3:0]), .w0_i(8'b01111110), .w1_i(8'b01010110), .w2_i(8'b00110101), .w3_i(8'b00100011), .hidden_neuron_o(hn1_o));

// hidden_neuron hn2 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o | f1p_o), .x_i(ui_in[3:0]), .w0_i(1), .w1_i(2), .w2_i(3), .w3_i(4), .hidden_neuron_o(hn2_o));

// hidden_neuron hn3 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o | f1p_o), .x_i(ui_in[3:0]), .w0_i(1), .w1_i(2), .w2_i(3), .w3_i(4), .hidden_neuron_o(hn3_o));

// hidden_neuron hn4 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o | f1p_o), .x_i(ui_in[3:0]), .w0_i(1), .w1_i(2), .w2_i(3), .w3_i(4), .hidden_neuron_o(hn4_o));

// hidden_neuron hn5 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o | f1p_o), .x_i(ui_in[3:0]), .w0_i(1), .w1_i(2), .w2_i(3), .w3_i(4), .hidden_neuron_o(hn5_o));

// hidden_neuron hn6 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o | f1p_o), .x_i(ui_in[3:0]), .w0_i(1), .w1_i(2), .w2_i(3), .w3_i(4), .hidden_neuron_o(hn6_o));

// hidden_neuron hn7 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o | f1p_o), .x_i(ui_in[3:0]), .w0_i(1), .w1_i(2), .w2_i(3), .w3_i(4), .hidden_neuron_o(hn7_o));

//output_neuron on0 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .f0_pass_i(f0p_o), .init_i(ui_in[3:0]), .x0_i(hn0_o), .x1_i(hn1_o), .x2_i(hn2_o), .x3_i(hn3_o), .x4_i(hn4_o), .x5_i(hn5_o), .x6_i(hn6_o), .x7_i(hn7_o), .w0_i(1), .w1_i(2), .w2_i(3), .w3_i(4), .w4_i(5), .w5_i(6), .w6_i(7), .w7_i(8), .loss_o(loss_o), .final_o(final_o));
output_neuron on0(.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o | f1p_o), .zero_loss_i(zero_loss_o), .zero_final_i(zero_final_o), .init_i(ui_in[3:0]), .x0_i(hn0_o), .x1_i(hn1_o), .w0_i(w0_on_i), .w1_i(w1_on_i), .final_o(final_o), .fpass_over_o(fpass_over_o), .zero_end_check_o(zero_end_check_o), .weights_o(on_weights_o));

//backprop hidden-to-out weight0
wire [7:0] w0_on_i, w0_on_backprop_o;
assign w0_on_i = (f0p_o) ? 8'b01101110 : w0_on_backprop_o; 
output_backprop obp1 (.clk_i(clk), .en_i(bp_o), .rst_i(rst_n), .final_i(final_o), .x_i(ui_in[3:0]), .hidden_val_i(hn0_o), .w_i(on_weights_o[7:0]), .zero_weight_reset_i(zero_weight_update_o), .w_o(w0_on_backprop_o), .b_end_o(b_end0_o));

wire [7:0] w1_on_i, w1_on_backprop_o;
assign w1_on_i = (f0p_o) ? 8'b01001000 : w1_on_backprop_o; 
output_backprop obp2 (.clk_i(clk), .en_i(bp_o), .rst_i(rst_n), .final_i(final_o), .x_i(ui_in[3:0]), .hidden_val_i(hn1_o), .w_i(on_weights_o[15:8]), .zero_weight_reset_i(zero_weight_update_o), .w_o(w1_on_backprop_o), .b_end_o(b_end1_o));



 





// wire [15:0] lfsr_top_o;

// lfsr lfsr_test (.clk_i(clk), .rst_i(rst_n), .en_i(1'b1), .lfsr_o(lfsr_top_o));
wire trash_handling;
assign uo_out = {final_o[7:0]};


endmodule

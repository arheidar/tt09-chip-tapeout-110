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
  assign uio_out[4:2] = 0;
  assign uio_oe = 1;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, uio_in,  1'b0}; 


wire [9:0] hn0_o, hn1_o, hn2_o, hn3_o, hn4_o, hn5_o, hn6_o, hn7_o;
wire [45:0] loss_o;
wire [22:0] final_o;
wire f0p_o, f1p_o, bp_o;
wire end_check_o;
wire [2:0] curr_state_o;


state_mach sm0 (.clk_i(clk), .rst_i(rst_n), .en_i(1), .init_i(ui_in[7]), .end_check_i(end_check_o),.f0_end_i(1'b0), .f0_pass_o(f0p_o), .f1_pass_o(f1p_o), .b_pass_o(bp_o), .curr_state_o(curr_state_o));

hidden_neuron hn0 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(1), .w1_i(2), .w2_i(3), .w3_i(4), .hidden_neuron_o(hn0_o));

hidden_neuron hn1 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(2), .w1_i(3), .w2_i(4), .w3_i(1), .hidden_neuron_o(hn1_o));

hidden_neuron hn2 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(3), .w1_i(4), .w2_i(1), .w3_i(2), .hidden_neuron_o(hn2_o));

hidden_neuron hn3 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(4), .w1_i(3), .w2_i(1), .w3_i(2), .hidden_neuron_o(hn3_o));

hidden_neuron hn4 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(5), .w1_i(6), .w2_i(7), .w3_i(8), .hidden_neuron_o(hn4_o));

hidden_neuron hn5 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(6), .w1_i(7), .w2_i(8), .w3_i(5), .hidden_neuron_o(hn5_o));

hidden_neuron hn6 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(7), .w1_i(8), .w2_i(5), .w3_i(6), .hidden_neuron_o(hn6_o));

hidden_neuron hn7 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(8), .w1_i(5), .w2_i(6), .w3_i(7), .hidden_neuron_o(hn7_o));

output_neuron on0 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o),  .init_i(ui_in[3:0]), .x0_i(hn0_o), .x1_i(hn1_o), .x2_i(hn2_o), .x3_i(hn3_o), .x4_i(hn4_o), .x5_i(hn5_o), .x6_i(hn6_o), .x7_i(hn7_o), .w0_i(1), .w1_i(2), .w2_i(3), .w3_i(4), .w4_i(5), .w5_i(6), .w6_i(7), .w7_i(8), .end_check_o(end_check_o), .loss_o(loss_o), .final_o(final_o));

//INITIALIZED WEIGHTS DIDNT FIT 
// hidden_neuron hn0 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(8'b00100000), .w1_i(8'b00011000), .w2_i(8'b01001010), .w3_i(8'b01100000), .hidden_neuron_o(hn0_o));

// hidden_neuron hn1 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(8'b00001110), .w1_i(8'b00110010), .w2_i(8'b010110000), .w3_i(8'b00000101), .hidden_neuron_o(hn1_o));

// hidden_neuron hn2 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(8'b01111000), .w1_i(8'b01110101), .w2_i(8'b00011010), .w3_i(8'b01011001), .hidden_neuron_o(hn2_o));

// hidden_neuron hn3 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(8'b00011010), .w1_i(8'b00000011), .w2_i(8'b01101101), .w3_i(8'b00111110), .hidden_neuron_o(hn3_o));

// hidden_neuron hn4 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(8'b0010010), .w1_i(8'b01011110), .w2_i(8'b01001110), .w3_i(8'b00110000), .hidden_neuron_o(hn4_o));

// hidden_neuron hn5 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(8'b01010011), .w1_i(8'b00110001), .w2_i(8'b00010010), .w3_i(8'b00110110), .hidden_neuron_o(hn5_o));

// hidden_neuron hn6 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(01001110), .w1_i(8'b00101101), .w2_i(8'b01111000), .w3_i(8'b01010001), .hidden_neuron_o(hn6_o));

// hidden_neuron hn7 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o), .x_i(ui_in[3:0]), .w0_i(8'b01010101), .w1_i(8'b01001000), .w2_i(8'b01110110), .w3_i(8'b00000011), .hidden_neuron_o(hn7_o));

// output_neuron on0 (.clk_i(clk), .rst_i(rst_n), .en_i(f0p_o),  .init_i(ui_in[3:0]), .x0_i(hn0_o), .x1_i(hn1_o), .x2_i(hn2_o), .x3_i(hn3_o), .x4_i(hn4_o), .x5_i(hn5_o), .x6_i(hn6_o), .x7_i(hn7_o), .w0_i(8'b00011111), .w1_i(8'b01100000), .w2_i(8'b01111110), .w3_i(8'b00110100), .w4_i(8'b00010001), .w5_i(8'b01101010), .w6_i(8'b01110001), .w7_i(8'b0100100), .end_check_o(end_check_o), .loss_o(loss_o), .final_o(final_o));



//max value output can take on with current weights is 10 bits!
assign uo_out = final_o[7:0];
assign uio_out[1:0] = final_o[9:8];
assign uio_out[7:5] = curr_state_o;


endmodule

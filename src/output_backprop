module output_backprop
(
    //input target_i,
    //enable saying we are in backprop
    //en_i = b_pass_i from sm
    input clk_i,
    input en_i,
    input rst_i,
    input final_i,
    input [3:0] x_i,  
    input [22:0] final_i,
    input [9:0] hidden_val_i,
    input [7:0] w_i, 
    input zero_weight_reset_i,
    output [7:0] w_o,
    output b_end_o
);

wire [22:0] x_ext;
//reg [23:0] gradient, w_update_d; 
reg [33:0] gradient, 
reg [41:0] w_update_d; 
//extra id bit
reg [42:0] w_update_q;

assign x_ext = {19'b0000000000000000000, x_i};
//might just change this to be a backwards pass implemented in each neuron but idk yet
always@(*) begin 
    //assign gradient = 2(x_i _) * h
    gradient = (2 * (x_ext - final_i)) * (hidden_val_i);
    w_update_d = {38'b0, w_i} - (8'b00000010 * gradient); 
end

always @(posedge clk_i or negedge rst_i) begin
    if (!rst || zero_weight_reset_i) begin
        w_update_q <= 0; 
    end else if (en_i) begin
        w_update_q <= {1'b1, w_update_d};
    end
end

assign b_end_o = (w_update_q[43]) ? 1'b1 : 0;

assign w_o = w_update_q[29:22]; 



endmodule
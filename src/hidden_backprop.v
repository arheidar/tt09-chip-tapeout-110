module hidden_backprop
(
    //input target_i,
    //enable saying we are in backprop
    input en_i,
    input b_pass_i,
    input [22:0] final_i,
    input [3:0] x_i,  

    input [7:0] w0_i, 
    input [7:0] w1_i, 
    input [7:0] w2_i, 
    input [7:0] w3_i, 

    output [7:0] w0_o, 
    output [7:0] w1_o, 
    output [7:0] w2_o, 
    output [7:0] w3_o 
);

wire [22:0] x_ext;
reg [23:0] gradient0, gradient1, gradient2, gradient3, w0_update_d, w0_update_d, w0_update_d, w0_update_d, w0_update_d; 
//extra id bit
reg [24:0] w0_update_q,  w1_update_q,  w2_update_q,  w3_update_q;

assign x_ext = {19'b0000000000000000000, x_i};
//might just change this to be a backwards pass implemented in each neuron but idk yet
always@(*) begin 
    //assign gradient = 2(x_i _) * h
    gradient0 = 2 * (x_ext - final_i);
    w_update_d = {16'b0000000000000000, w_i} - gradient; 
end

always @(posedge clk_i or negedge rst_i) begin
    if (!rst || zero_weight_reset_i) begin
        w_update_q <= 0; 
    end else if (en_i) begin
        w0_update_q <= {1'b1, w0_update_d};
        w1_update_q <= {1'b1, w1_update_d};
        w2_update_q <= {1'b1, w2_update_d};
        w3_update_q <= {1'b1, w3_update_d};
    end
end

assign b_end_o = (w0_update_q[24]) ? 1'b1 : 0;

assign w0_o = w_update_q[14:7]; 
assign w1_o = w_update_q[14:7]; 
assign w2_o = w_update_q[14:7]; 
assign w3_o = w_update_q[14:7]; 




endmodule

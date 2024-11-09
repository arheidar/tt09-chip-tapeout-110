module output_backprop
(
    //input target_i,
    //enable saying we are in backprop
    //en_i = b_pass_i from sm
    input clk_i,
    input en_i,
    input rst_i,
    input [3:0] x_i,  
    input [18:0] final_i,
    input [9:0] hidden_val_i,
    input [7:0] w_i, 
    input zero_weight_reset_i,
    output [7:0] w_o,
    output b_end_o
    //output trash_handling
);

wire [18:0] x_ext;
reg [19:0] gradient0;
reg [29:0] gradient1;
reg [37:0] lr_mult;
reg [37:0] w_update_d; 
//extra id bit
reg [8:0] w_update_q;

assign x_ext = {15'b0000000000000000000, x_i};
//PRETTY SURE I NEED TO SWITCH IT FROM X - FINAL to FINAL - X
always@(*) begin 
    //assign gradient = 2(x_i _) * h
    gradient0 = ((x_ext - final_i) << 1 );
    gradient1 = gradient0 * hidden_val_i;
    lr_mult = (8'b00000010 * gradient1); 
    w_update_d = {30'b0, w_i} - (lr_mult); 
end

//one extra bit as an identifier
wire [8:0] w_temp;
assign w_temp = {1'b1, w_update_d[28:21]};

always @(posedge clk_i) begin
    if (!rst_i || zero_weight_reset_i) begin
        w_update_q <= 0; 
    end else if (en_i) begin
        w_update_q <= w_temp; 
    end
end

assign b_end_o = (w_update_q[8]) ? 1'b1 : 0;

//assign trash_handling = &{w_update_q[41:30], w_update_q[21:0]};


assign w_o = w_update_q[7:0]; 



endmodule
module hidden_backprop
(
    //input target_i,
    //enable saying we are in backprop
    input clk_i,
    input en_i,
    input rst_i,
    input [18:0] final_i,
    input [3:0] x_i,  
    input [9:0] hidden_val_i,
    input [7:0] w0_i, 
    input [7:0] w1_i, 
    input [7:0] w2_i, 
    input [7:0] w3_i, 
    input zero_weight_reset_i,

    output [7:0] w0_o, 
    output [7:0] w1_o, 
    output [7:0] w2_o, 
    output [7:0] w3_o, 
    output b_end_o
);

wire [18:0] x_ext;
reg [19:0] gradient;
reg [37:0] w0_updated_d, w1_updated_d, w2_updated_d, w3_updated_d;
//reg [23:0] gradient0, gradient1, gradient2, gradient3, w0_update_d, w0_update_d, w0_update_d, w0_update_d, w0_update_d; 
//extra id bit
//reg [24:0] w0_update_q,  w1_update_q,  w2_update_q,  w3_update_q;

assign x_ext = {15'b0000000000000000000, x_i};
always@(*) begin 
    //derv of loss
    gradient = ((x_ext - final_i) << 1);

    if ((x_i[0] == 1'b1) || (hidden_val_i !=0)) begin
        w0_updated_d = {30'b0, w0_i} - (gradient * hidden_val_i * 8'b00000010);
    end else begin
        w0_updated_d = 0;
    end

    if ((x_i[1] == 1'b1) || (hidden_val_i !=0)) begin
        w1_updated_d = {30'b0, w1_i} - (gradient * hidden_val_i * 8'b00000010);
    end else begin
        w1_updated_d = 0;
    end

    if ((x_i[2] == 1'b1) || (hidden_val_i !=0)) begin
        w2_updated_d = {30'b0, w2_i} - (gradient * hidden_val_i * 8'b00000010);
    end else begin
        w2_updated_d = 0;
    end
    

    if ((x_i[3] == 1'b1) || (hidden_val_i !=0)) begin
        w3_updated_d = {30'b0, w3_i} - (gradient * hidden_val_i * 8'b00000010);
    end else begin
        w3_updated_d = 0;
    end
end


reg [8:0] w0_updated_q, w1_updated_q, w2_updated_q, w3_updated_q;

always @(posedge clk_i) begin
    if (!rst_i || zero_weight_reset_i) begin
        w0_updated_q <= 0; 
        w1_updated_q <= 0; 
        w2_updated_q <= 0; 
        w3_updated_q <= 0; 

    end else if (en_i) begin
        w0_updated_q <= {1'b1, w0_updated_d[28:21]};
        w1_updated_q <= {1'b1, w1_updated_d[28:21]};
        w2_updated_q <= {1'b1, w2_updated_d[28:21]};
        w3_updated_q <= {1'b1, w3_updated_d[28:21]};
    end
end
assign b_end_o = (w0_updated_q[8]) ? 1'b1 : 0;

assign w0_o = w0_updated_q[7:0]; 
assign w1_o = w1_updated_q[7:0]; 
assign w2_o = w2_updated_q[7:0]; 
assign w3_o = w3_updated_q[7:0]; 




endmodule

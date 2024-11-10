    module output_neuron 
    (
        input clk_i,
        input rst_i,
        input en_i,
        input [3:0] init_i,
        input [9:0] x0_i,
        input [9:0] x1_i,
        input [9:0] x2_i,
        input [9:0] x3_i,
        input [9:0] x4_i,
        input [9:0] x5_i,
        input [9:0] x6_i,
        input [9:0] x7_i,
        //7:0 is fixed point: 1.7 form for interpretaion 
        input [7:0] w0_i,
        input [7:0] w1_i,
        input [7:0] w2_i,
        input [7:0] w3_i,
        input [7:0] w4_i,
        input [7:0] w5_i,
        input [7:0] w6_i,
        input [7:0] w7_i,
        //output fwrd_done_o,
        //output f0_end_o, 
        //output f1_end_o,
        output reg  [45:0] loss_o,
        output reg [22:0] final_o,
        output reg end_check_o
    );

wire [9:0] w0_ext, w1_ext, w2_ext, w3_ext, w4_ext, w5_ext, w6_ext, w7_ext;
reg [22:0] final_d, final_q; 

//unsure if yosys will zero extend when i do multiplication, so im doing this to be safe 
assign w0_ext = {2'b0, w0_i};
assign w1_ext = {2'b0, w1_i};
assign w2_ext = {2'b0, w2_i};
assign w3_ext = {2'b0, w3_i};
assign w4_ext = {2'b0, w4_i};
assign w5_ext = {2'b0, w5_i};
assign w6_ext = {2'b0, w6_i};
assign w7_ext = {2'b0, w7_i};

always @(*) begin
    final_d = (x0_i * w0_ext) + (x1_i * w1_ext) +  (x2_i * w2_ext) + (x3_i * w3_ext) +  (x4_i * w4_ext) + (x5_i * w5_ext) + (x6_i * w6_ext) + (x7_i * w7_ext); 
    
end

always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
        final_q <= 0; 
    end else if (en_i) begin
        final_q <= final_d;
    end
end

assign end_check_o = ((final_q == 0) && (init_i == 0));

assign final_o = final_q;

//LOSS FUNCTION 
wire [22:0] target_ext;
reg signed [22:0] inner_fn;
reg [45:0] loss_d;

assign target_ext = {19'b00000000000000000, init_i};

always @(*) begin
    inner_fn = (final_q - target_ext);
    loss_d = inner_fn * inner_fn;
end

always @(posedge clk_i) begin
    if (!rst_i) begin
        loss_o <= 0; 
    end else if (en_i && (final_q != 0)) begin
        loss_o <= loss_d;
    end
end


//wire [45:0] loss_check;
//loss_calc mse_fn (.clk_i(clk_i), .rst_i(rst_i), .en_i (en_i), .target_i(init_i), .predicted_i(final_q), .loss_o(loss_o));


endmodule
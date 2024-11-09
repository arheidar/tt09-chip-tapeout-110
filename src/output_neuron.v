    module output_neuron 
    (
        input clk_i,
        input rst_i,
        input en_i,
        input zero_loss_i,
        input zero_final_i,
        // input f0_pass_i,
        // input f1_pass_i,
        //9:0 is fixed point but im not sure what . shit yet ill figure out how to interpret it later
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
        output fpass_over_o,
        output zero_end_check_o,
        output reg [55:0] weights_o
    );

wire [9:0] w0_ext, w1_ext, w2_ext, w3_ext, w4_ext, w5_ext, w6_ext, w7_ext;
//idk if 21 bits is right, maybe ask jason
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
    
    // if ((loss_o > 0) && (f0_pass_i == 1)) begin
    //     f0_end_o = 1;
    // end else if ((loss_o == 0) && (f1_pass_i == 1))
    //     f1_end_o = 1;
    // else begin
    //     f0_end_o = 0;
    //     f1_end_o = 0;
    // end
end

always @(posedge clk_i or negedge rst_i) begin
    if (!rst_ || zero_final_i) begin
        final_q <= 0; 
    end else if (en_i) begin
        final_q <= final_d;
    end
end

assign final_o = final_q;

// we can just skip loss calculation
assign zero_end_check_o = ((final_o == 0) && (init_i == 0)) ? 1'b1 : 1'b0;

//LOSS CHECK
wire [22:0] target_ext;
reg [22:0] inner_fn;
reg [45:0] loss_d;

assign target_ext = {19'b00000000000000000, init_i};

always @(*) begin
    inner_fn = (final_q - target_ext);
    loss_d = inner_fn * inner_fn;
end

always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i || zero_loss_i) begin
        loss_o <= 0; 
    end else if (en_i && ((final_q != 0) && (init_i != 0))) begin
        loss_o <= loss_d;
    end
end 

assign fpass_over_o = ((loss_o > 0) && (en_i)) ? 1'b1 : 1'b0;

//weight outputs for bp calc
always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
        weights_o <= 0; 
    end else if (en_i) begin
        weights_o <= {w7_i, w6_i, w5_i, w4_i, w3_i, w2_i, w1_i, w0_i}; 
    end
end 

// //flip flop to tell when we are done with forward pass MAKE SURE YOU FIX LOSS CHECK LIKE FOR ENTERING END STATE loss > 0 is gonna be hard  maybe just truncate or smth
// always @(posedge clk_i or negedge rst_i) begin
//     if (!rst_i) begin
//         fpass_over_o <= 0; 
//     end else if (loss_o > 0) begin
//         fpass_over_o <= 1; 
//     end
// end


//wire [45:0] loss_check;
//loss_calc mse_fn (.clk_i(clk_i), .rst_i(rst_i), .en_i (en_i), .target_i(init_i), .predicted_i(final_q), .loss_o(loss_o));


endmodule
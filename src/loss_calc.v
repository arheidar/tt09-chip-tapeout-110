module loss_calc 
(
    input clk_i,
    input rst_i,
    input en_i,
    input [3:0] target_i,
    input [22:0] predicted_i,
    //not sure if this is right for bit size of loss_o
    output reg [45:0] loss_o
);  

//loss = (y-y')^2 ... calling the inside of the parantheses inner_fn
wire [22:0] target_ext;
reg signed [22:0] inner_fn;
reg [45:0] loss_d;

assign target_ext = {19'b00000000000000000, target_i};

always @(*) begin
    inner_fn = (predicted_i - target_ext);
    loss_d = inner_fn * inner_fn;
end

always @(posedge clk_i) begin
    if (!rst_i) begin
        loss_o <= 0; 
    end else if (en_i) begin
        loss_o <= loss_d;
    end
end



endmodule 
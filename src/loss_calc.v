module loss_calc 
(
    input [3:0] target_i,
    input [20:0] predicted_i,
    //not sure if this is right for bit size of loss_o
    output [41:0] loss_o;
)

//loss = (y-y')^2 ... calling the inside of the parantheses inner_fn
wire [20:0] inner_fn, target_ext;
wire [41:0] loss_d, loss_q;

assign target_ext = {17'b00000000000000000, target_i};

always @(*) begin
    inner_fn = (predicted_i - target_ext);
    loss_d = inner_fn * inner_fn;
end

always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
        loss_q <= 0; 
    end else if (en_i) begin
        loss_q <= loss_d;
    end
end

assign loss_o = loss_q;


endmodule 
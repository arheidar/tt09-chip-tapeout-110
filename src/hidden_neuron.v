module hidden_neuron 
//#(parameter size_p = 4)
(
    input clk_i,
    input rst_i,
    input en_i,
    input [3:0] x_i, 
    //8 bits represent as 1.7 in reality 
    input [7:0] w0_i, 
    input [7:0] w1_i, 
    input [7:0] w2_i, 
    input [7:0] w3_i,   
    //3.7
    output reg [9:0] hidden_neuron_o,
    output reg [31:0] weights_o
);



reg [7:0] wx3, wx2, wx1, wx0;
reg [9:0] neuron_calc;
reg [9:0] hidden_neuron_d, hidden_neuron_q;



always @(*) begin
    wx3 = 0;
    wx2 = 0;
    wx1 = 0;
    wx0 = 0;

    if (x_i[3] == 1'b1) begin
        wx3 = w3_i; 
    end else begin
        wx3 = 0;
    end

    if (x_i[2] == 1'b1) begin
        wx2 = w2_i; 
    end else begin
        wx2 = 0;
    end

    if (x_i[1] == 1'b1) begin
        wx1 = w1_i; 
    end else begin
        wx1 = 0;
    end

    if (x_i[0] == 1'b1) begin
        wx0 = w0_i; 
    end else begin
        wx0 = 0;
    end

    neuron_calc = wx3 + wx2 + wx1 + wx0;

    //ACTIVATION FUNCTION LOGIC (relu), considering my weights are 0 - 1 range, i wont have any negative numbers anyway tho lol
    if (neuron_calc <= 0) begin
        hidden_neuron_d = 0;
    end else begin
        hidden_neuron_d = neuron_calc;
    end

end

always @(posedge clk_i) begin 
    if (!rst_i) begin
        hidden_neuron_q <= 0;
    end else if (en_i) begin
        hidden_neuron_q <= hidden_neuron_d;
    end
end

assign hidden_neuron_o = hidden_neuron_q;

always @(posedge clk_i) begin
    if (!rst_i) begin
        weights_o <= 0; 
    end else if (en_i) begin
        weights_o <= {w3_i, w2_i, w1_i, w0_i}; 
    end
end 



endmodule
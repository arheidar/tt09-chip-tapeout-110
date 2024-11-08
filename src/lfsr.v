module lfsr 
(
    input clk_i,
    input rst_i,
    input en_i,
    //decided 16 bit lfsr for 65,535 cycles of "random" data
    //doing this since im assuming lfsr base back pass will need a large amount of epochs to converge
    output [15:0] lfsr_o
);

wire [15:0] rand_d, rand_q;

assign rand_d[0] = rand_q[1] ^ rand_q[2] ^ rand_q[4] ^ rand_q[15];
assign rand_d[15:1] = rand_q[14:0];

always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
        rand_q <= 16'b0000000000000001;
    end else if (en_i) begin
        rand_q <= rand_d;
    end        
end

assign lfsr_o = rand_q;

endmodule 
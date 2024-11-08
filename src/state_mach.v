module state_mach
(
    input clk_i,
    input rst_i,
    //enable will just be ena from top module
    input en_i,
    input init_i,
    input f1_end_i,
    

    //reg?
    output reg f0_pass_o,
    output reg f1_pass_mux,
    output reg b_pass_o
);

reg [2:0] state_d, state_q;
always @(posedge clk_i or negedge rst_i) begin
    if (!rst_ni) begin
        state_q <= 3'b000;
    end else begin
        state_q <= state_d;
    end
end

always @(*) begin
    state_d = state_q;

    case (state_q)
        //init
        3'b000 : begin
            f0_pass_o = 0;
            f1_pass_o
            b_pass_o = 0;

            if (init_i == 1'b1) begin
                state_d = 3'b001
            end

        end
        
        3'b001 : begin


        end

        default: 3'b000;
    endcase

end


    


endmodule
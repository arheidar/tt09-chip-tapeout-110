module state_mach
(
    input clk_i,
    input rst_i,
    //enable will just be 1
    input en_i,
    input init_i,
    input f0_end_i,
    input end_check_i,
    //reg?
    output reg f0_pass_o,
    output reg f1_pass_o,
    output reg b_pass_o,
    output reg [2:0] curr_state_o
);

reg [2:0] state_d, state_q;
always @(posedge clk_i) begin
    if (!rst_i) begin
        state_q <= 3'b000;
    end else if (en_i) begin
        state_q <= state_d;
    end
end

always @(*) begin
    state_d = state_q;

    case (state_q)
        //init
        3'b000 : begin
            f0_pass_o = 0;
            f1_pass_o = 0;
            b_pass_o = 0;

            if (init_i == 1'b1) begin
                state_d = 3'b001;
            end

        end
        
        //f0 pass
        3'b001 : begin
            f0_pass_o = 1;
            f1_pass_o = 0;
            b_pass_o = 0;

            if (end_check_i == 1'b1) begin
                state_d = 3'b010;
            end
        end

    //end
        3'b010 : begin
            f0_pass_o = 0;
            f1_pass_o = 0;
            b_pass_o = 0;
        end


        default: begin
            state_d = 3'b000;
            if (f0_end_i == 1'b1) begin
                state_d = 3'b010;
            end
        end
    endcase

end

assign curr_state_o = state_q;


    


endmodule
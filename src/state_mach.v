module state_mach
(
    input clk_i,
    input rst_i,
    //enable will just be ena from top module
    input en_i,
    input init_i,
    input f_end_i,
    input b_end_i,
    input zero_end_check_i,
    

    //reg?
    output reg zero_loss_o,
    output reg zero_final_o,
    output reg zero_weight_update_o,
    output reg f0_pass_o,
    output reg f1_pass_o,
    output reg b_pass_o
);

reg [2:0] state_d, state_q;
always @(posedge clk_i or negedge rst_i) begin
    if (!rst_i) begin
        state_q <= 3'b000;
    end else if (en_i) begin
        state_q <= state_d;
    end
end

always @(*) begin
    state_d = state_q;
    zero_loss_o = 0;
    zero_final_o = 0;
    zero_weight_update_o = 0;
    f0_pass_o = 0;
    f1_pass_o = 0;
    b_pass_o = 0;


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

            if (f_end_i == 1'b1) begin
                state_d = 3'b010;
            end
        end

        //b pass
        3'b010 : begin
            f0_pass_o = 0;
            f1_pass_o = 0;
            b_pass_o = 1;

            if (b_end_i == 1'b1) begin
                //need to zero loss and final_o 
                zero_loss_o = 1;
                zero_final_o = 1;
                state_d = 3'b011;
            end
        end

        //f1 pass
        3'b011 : begin
            f0_pass_o = 0;
            f1_pass_o = 1;
            b_pass_o = 0;

            if (f_end_i == 1'b1) begin
                zero_weight_update_o = 1;
                state_d = 3'b010;
            end else if (zero_end_check_i) begin
                state_d = 3'b100;
            end
        end
        
        //end 
         3'b100 : begin
            f0_pass_o = 0;
            f1_pass_o = 0;
            b_pass_o = 0;
        end

        default: begin
            state_d = 3'b000;
        end
    endcase

end


    


endmodule
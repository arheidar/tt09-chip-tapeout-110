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
reg zero_loss_temp, zero_final_temp, zero_weight_update_temp, f0_pass_temp, f1_pass_temp, b_pass_temp;

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
    zero_loss_temp = 0;
    zero_final_temp = 0;
    zero_weight_update_temp = 0;
    f0_pass_temp = 0;
    f1_pass_temp = 0;
    b_pass_temp = 0;


    case (state_q)
        //init
        3'b000 : begin
            f0_pass_temp = 0;
            f1_pass_temp = 0;
            b_pass_temp = 0;

            if (init_i == 1'b1) begin
                state_d = 3'b001;
            end

        end
        
        //f0 pass
        3'b001 : begin
            f0_pass_temp = 1;
            f1_pass_temp = 0;
            b_pass_temp = 0;

            if (f_end_i == 1'b1) begin
                state_d = 3'b010;
            end
        end

        //b pass
        3'b010 : begin
            f0_pass_temp = 0;
            f1_pass_temp = 0;
            b_pass_temp = 1;

            if (b_end_i == 1'b1) begin
                //need to zero loss and final_o 
                zero_loss_temp = 1;
                zero_final_temp = 1;
                state_d = 3'b011;
            end
        end

        //f1 pass
        3'b011 : begin
            f0_pass_temp = 0;
            f1_pass_temp = 1;
            b_pass_temp = 0;

            if (f_end_i == 1'b1) begin
                zero_weight_update_temp = 1;
                state_d = 3'b010;
            end else if (zero_end_check_i) begin
                state_d = 3'b100;
            end
        end
        
        //end 
         3'b100 : begin
            f0_pass_temp = 0;
            f1_pass_temp = 0;
            b_pass_temp = 0;
        end

        default: begin
            state_d = 3'b000;
        end
    endcase

end

assign zero_loss_o = zero_loss_temp;
assign zero_final_o = zero_final_temp;
assign zero_weight_update_o = zero_weight_update_temp;
assign f0_pass_o = f0_pass_temp;
assign f1_pass_o = f1_pass_temp;
assign b_pass_o = b_pass_temp;



    


endmodule
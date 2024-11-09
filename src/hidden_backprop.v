module hidden_backprop
(
    input target_i,
    //enable saying we are in backprop
    input en_i,
    input [3:0] x_i, 


    input [7:0] w0_i, 
    input [7:0] w1_i, 
    input [7:0] w2_i, 
    input [7:0] w3_i, 

    output [7:0] w0_i, 
    output [7:0] w1_i, 
    output [7:0] w2_i, 
    output [7:0] w3_i, 
);
//might just change this to be a backwards pass implemented in each neuron but idk yet


endmodule

/*14500_mc14599b.v*/
module mc14599(A, Q, data, reset, w_disable);
  input [2:0]A;
  output [7:0] Q;
  input data;
  input reset;
  input w_disable;
  
  reg[7:0] d;
  //TODO: add all the cases. Just a stub so far. Not in the mood.
  always@(*)
    begin
      r[A] <= data;
      
      Q <= r;
    end
  
  
endmodule

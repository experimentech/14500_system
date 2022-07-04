/*14500_mc14599b.v*/
module mc14599(A, Q, data, reset, w_disable);
  input [2:0]A;
  output [7:0] Q;
  input data;
  input reset;
  input w_disable;
  
  reg[7:0] d;
  reg[7:0] bitmask;
  //TODO: add all the cases. Just a stub so far. Not in the mood.
  always@(*)
    begin
      //r[A] <= data & (~reset); //if reset, force zero.
      if(!reset & !w_disable)
        begin
          d[A] <= data; //what the hell is r?
        end
      else if(!reset &w_disable)
        begin
        end
      else
        begin
          //this is totally the wrong approach.
        end
      
      /*
      reset?
      How do I do a variable single bit bitmask.
      bitmask = 8'b0 & ???
      
      */
      
      Q <= d;
    end
  
  
endmodule

//mc14512 8 channel data selector
//This is used as an input.
module mc14512(x, z, abc, inh, dis);
  input [7:0]x; //inputs to be selected for reading
  output z; //output data
  input [2:0]abc; //address of input(x) to be read
  input inh; //force all Xn to 0;
  input dis; //tristate xn. Not implemented
  
  //damn. Thougt that'd work. Might need to try combinatorial syntax.
  assign z = x[abc] & (~inh); 
 
  //assign z = dis? 'bz : (x[abc] & (~ inh)); //nope.
  //I'll believe it when I see it in action.
          
  
endmodule

module program_counter(pc_clk, reset, addr_out, addr_in, addr_w);
  /*
  addr in is used to latch a new address in the PC with addr_w
  */
  input pc_clk;
  input reset;
  output [15:0]addr_out;
  input [15:0]addr_in;
  input addr_w;
  reg [15:0] program_counter;
  always@(posedge pc_clk or posedge reset)
    begin
      if(reset)
        program_counter <= 0;
      
      if(addr_w)
        begin
          program_counter <= addr_in;
        end
      else
        begin
          addr_out <= program_counter;
          program_counter <= program_counter + 1;
        end       
    end
  
endmodule


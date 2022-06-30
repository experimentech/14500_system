
module lu_fudge(data_in, data_out, clk, instruction, reset, write_mode, result, jmp, rtn, flg0, flgf);
  input data_in;
  input clk;
  input [3:0] instruction;
  input reset;

  output reg data_out;
  output reg write_mode;
  output reg result;
  output reg jmp;
  output reg rtn;
  output reg flg0;
  output reg flgf;

  reg ien;
  reg oen;
  reg rr;
  reg skip;
  reg d;


`define OP_NOPO 4'b0000
`define OP_LD   4'b0001
`define OP_LDC  4'b0010
`define OP_AND  4'b0011
`define OP_ANDC 4'b0100
`define OP_OR   4'b0101
`define OP_ORC  4'b0110
`define OP_XNOR 4'b0111
`define OP_STO  4'b1000
`define OP_STOC 4'b1001
`define OP_IEN  4'b1010
`define OP_OEN  4'b1011
`define OP_JMP  4'b1100
`define OP_RTN  4'b1101
`define OP_SKZ  4'b1110
`define OP_NOPF 4'b1111
  


  always@(posedge clk)
  //always@*
  begin
      if(skip)
        skip <= 0;

      if(jmp)
        jmp <= 0;

      if(rtn)
        rtn <= 0;

      if(flg0)
        flg0 <=0;

      if(flgf)
        flgf <=0;

    d <= data_in;

    case(instruction)
      `OP_NOPO :
      begin
        flg0 <= 1; //todo 1 clk
      end
      `OP_LD   :
        rr <= d; //LD
      `OP_LDC  :
        rr <= ~d; //LDC
      `OP_AND  :
        rr <= rr & d; //AND
      `OP_ANDC :
        rr <= ~(rr & d); //ANDC
      `OP_OR   :
        rr <= rr | d; //OR
      `OP_ORC  :
        rr <= ~(rr | d); //ORC
      `OP_XNOR :
        rr <= ^~ d; //XNOR
      `OP_STO  :
      begin
        /*
        oen is never low when skip is high in simulation. Hm.
        */
        if(oen &(!skip))
        begin
          data_out <= rr;
          write_mode <= 1;
        end
        else
        begin
          write_mode <= 0;
        end
      end
      `OP_STOC :
      begin
        if(oen &(!skip))
        begin
          data_out <= ~rr;
          write_mode <= 1;
        end
        else
        begin
          write_mode <= 0;
        end

      end
      `OP_IEN  :
        ien <= d; //Look at negedge above for input logic for this
      `OP_OEN  :
        oen <= ~skip & d; //should force oen off with skip.
      `OP_JMP  :
        jmp <= 1; //reg for jump. Pin is triggered on negedge.
      `OP_RTN  :
        begin
            rtn <= 1; //todo. Triggers RTN pin and skips next instruction. How do I do that?
            skip <= 1;          
        end

      `OP_SKZ  : //skip next instruction if rr = 0;
        if(!rr)
        begin
          skip <=1 ;
          //skip the next instruction somehow.
          //kills oen for one cycle I think.
        end
      `OP_NOPF :
      begin
        flgf <= 1;
        //skip <= 1; //Wny did I do that???
      end

    endcase
    result <= ~rr;
  end



endmodule


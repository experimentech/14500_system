
`include "14500_mc14599b.v"

`include "14500_rom.v"
`include "14500_mc14512.v"
`include "14500_lu.v"
`include "14500_pc.v"

`include "hvsync_generator.v"


//uncomment then re-comment to get the json to load correctly
//`include "mc14500b_8.json"



module top(clk, reset, hsync, vsync, rgb);

  input clk, reset;
  output hsync, vsync;
  output [2:0] rgb;
  wire display_on;
  wire [8:0] hpos;
  wire [8:0] vpos;
  
  
  
  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(reset),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
  );

//mc14512 input multiplexer
  //module mc14512(x, z, abc, inh, dis);

  wire [7:0]imux_x;
  wire imux_z;
  wire [2:0] imux_abc; //3 bit address of which x input is read
  wire imux_inh; //inhibit. forces all to zero
  wire imux_dis; //n/c in module
  
  
  mc14512 input_mux(
    .x(imux_x),
    .z(imux_z),
    .abc(imux_abc),
    .inh(imux_inh),
    .dis(imux_dis)
  );
  
  
 
  wire [7:0]rom_data;
  wire [6:0]rom_addr;
  wire [3:0]instr_slice;
  wire iochip_slice;
  wire [2:0]ioport_slice;
  
  assign instr_slice = rom_data[7:4];
  assign iochip_slice = rom_data[3];
  assign ioport_slice = rom_data[2:0];
  //module my_rom(rom_data, rom_addr);
  my_rom ROM(
    .rom_data(rom_data),
    .rom_addr(rom_addr)
  );

  
  wire [3:0] lu_instruction;
  wire lu_data_in;
  
  wire lu_data_out;
  wire lu_write_mode;
  wire lu_result;
  wire lu_jmp;
  wire lu_rtn;
  wire lu_flg0;
  wire lu_flgf;
  //module lu_fudge(data_in, data_out, clk, instruction, reset, write_mode, result, jmp, rtn, flg0, flgf);
  lu_fudge lu(
    .data_in(lu_data_in),
    .data_out(lu_data_out),
    .clk(clk),
    .instruction(lu_instruction),
    .reset(reset),
    .write_mode(lu_write_mode),
    .result(lu_result),
    .jmp(lu_jmp),
    .rtn(lu_rtn),
    .flg0(lu_flg0),
    .flgf(lu_flgf)
  );
  
  //wire pc_clk;
  wire [15:0] pc_addr_o;
  wire [15:0] pc_addr_in;
  wire pc_addr_w;
  wire pc_reset_i;
  //program_counter(pc_clk, reset, addr_out, addr_in, addr_w);
  program_counter pc(
    .pc_clk(clk),
    .reset(pc_reset_i),
    .addr_out(pc_addr_o),
    .addr_in(pc_addr_in),
    .addr_w(pc_addr_w)
  );
  
/*
  wire r = display_on && hpos[4];
  wire g = display_on && vpos[4];
  wire b = display_on && hpos[0];
 */
  wire r = display_on && lu_result;
  wire g = display_on && lu_jmp;
  wire b = display_on && lu_rtn;  
  
  assign rgb = {b,g,r};
  

  
  reg[6:0] cntr;
  
  always@(posedge clk or posedge reset)
    begin
      
      if(reset)
        begin
          pc_reset_i <= 1;
        end
      else
        begin
          pc_reset_i <= 0;
        end
           
          
          
      /*
      if(reset)
        begin
          cntr <= 0;
        end
      else
      */
//      begin
      
      //lu_instruction <= ram_dout[7:4]; //from RAM
      //Spitting out data to 
      //lu_instruction <= rom[7:4],[cntr[6:0]]; //from hacky counter
      //lu_instruction <= (rom[cntr[6:0])[7:4];
      rom_addr <= pc_addr_o[6:0];//cntr[6:0]; //just driving rom address with a counter for now.
      lu_instruction <= instr_slice;
      lu_data_in <= cntr[3]; //TODO add all the IO support so something can actually work

      //lu_data_in <= cntr[0];
      cntr <= cntr + 1;
      
      pc_addr_in <=0; //not used yet
      pc_addr_w <=0;//same
      
      //what in the fresh hell is this???
/*      
      if(lu_write_mode)
        begin
          //how do I do do this better?
          ram_addr[9:0] <= pc_addr_out[9:0];
          ram_din[3] <= lu_data_out;
          ram_din[7:4] <= 4'b0000; //what was I doing here?
          ram_din[2:0] <= 3'b000; //???? From the mux?
          ram_we <= 1'b1;
        end
      else //read mode
        begin
          //read.
          ram_addr[9:0] <= pc_addr_out[9:0];
          lu_data_in <= ram_dout[3];
          lu_instruction <= ram_dout[7:4];          
        end
        */
//      end
      //putting imux at the end to allow project build for now.
      imux_x <=0;
      imux_abc <=0;
      imux_inh <= 0;
      imux_dis <= 0;
      
      //pc_clk_i <= clk;
    end
    


endmodule

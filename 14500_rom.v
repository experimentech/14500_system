/*
This module contains the ROM related stuff for this prticular implementation.
In this case it also has the assembly code for the ROM.

FIXME:
Write mode appears to be stuck in "write" on LU.
*/
//`include "mc14500b_8.json"

module my_rom(rom_data, rom_addr);
  input [6:0]rom_addr;
  //output [7:0]rom_data;

  
    reg [7:0] rom[0:127];
  output [7:0]rom_data;
  assign rom_data = rom[rom_addr];
  
   initial begin
`ifdef EXT_INLINE_ASM
    // yeehaw
     rom = '{
      __asm
      
.arch mc14500b_8
.org 0
.len 128
      
Start:
      nopf
      ld i1
      and s0
      sto o0
      ldc i2
      ld rr
      andc rr
      or i7
      sto s0
      
      
Loop:
      nopf

      __endasm
    };
`endif
  end  
  
endmodule


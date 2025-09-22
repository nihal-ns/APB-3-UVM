`include "uvm_macros.svh"
`include "interface.sv"
`include "apbtop.v"
`include "apb_assertion.sv"
module top;
  import uvm_pkg::*;
  import apb_pkg::*;

  bit PCLK;
  bit PRESETn;

  initial begin
    PCLK = 0;
    forever #5 PCLK = ~ PCLK;
  end

  apb_intf intf(PCLK, PRESETn);

  APB_Protocol DUT ( 
    .PCLK(PCLK), 
    .PRESETn(PRESETn),
    .transfer(intf.transfer),
    .apb_write_paddr(intf.apb_write_paddr),
    .apb_read_paddr(intf.apb_read_paddr),
    .apb_write_data(intf.apb_write_data),
    .apb_read_data_out(intf.apb_read_data_out),
    .PSLVERR(intf.PSLVERR),
    .READ_WRITE(intf.READ_WRITE)
  );

  bind intf apb_assertion ASSERT(.*);
                  
  initial begin
    PRESETn = 0;
    #5  PRESETn = 1;

  end
  initial begin
    uvm_config_db#(virtual apb_intf)::set(null, "*", "apb_intf", intf);
    run_test("wr_test");
  end

endmodule

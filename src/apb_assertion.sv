program apb_assertion(PCLK, PRESETn, transfer, READ_WRITE, apb_write_data, apb_write_paddr, apb_read_paddr, apb_read_data_out, PSLVERR);
  
  input PCLK;
  input PRESETn;
  input transfer;
  input READ_WRITE;
  input [8:0] apb_write_paddr;
  input [7:0] apb_write_data;
  input [8:0] apb_read_paddr;
  input [7:0] apb_read_data_out;
  input PSLVERR;
  
  property pr1;
    @(posedge PCLK)(!PRESETn)->( apb_read_data_out==8'b0 && PSLVERR == 0);
  endproperty

  assert property (pr1)
    $info("Output RESET condition passed ");
  else
    $error("Output RESET condition failed ");

  property pr4;
    @(posedge PCLK) disable iff(!PRESETn) (!READ_WRITE)|-> !($isunknown(apb_read_paddr));
  endproperty

  assert property (pr4)
    $info("Assertion passed for valid READ ADDR");
  else
    $error("Assertion Failed");

  property pr5;
    @(posedge PCLK) disable iff(!PRESETn) (READ_WRITE)|-> (!($isunknown(apb_write_paddr)  && !($isunknown(apb_write_data))));
  endproperty

  assert property (pr5)
    $info("Assertion passed for valid WRITE DATA & ADDR");
  else
    $error("Assertion Failed");


endprogram

interface apb_intf (input bit PCLK, PRESETn); //Global signals
  
  bit READ_WRITE;
  bit transfer;  
  logic [8:0] apb_write_paddr;
  logic [8:0] apb_read_paddr;
  logic [7:0] apb_write_data;
  
  bit [7:0] apb_read_data_out;
  bit PSLVERR;

  clocking drv_cb @(posedge PCLK);
    output READ_WRITE, apb_write_paddr, apb_read_paddr;
  endclocking

  clocking mon_cb @(posedge PCLK);
    input apb_read_data_out, PSLVERR, READ_WRITE, apb_write_paddr, apb_read_paddr, apb_write_data, transfer;
  endclocking

endinterface

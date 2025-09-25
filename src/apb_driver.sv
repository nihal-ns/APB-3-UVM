class apb_driver extends uvm_driver#(apb_seq_item);
  `uvm_component_utils(apb_driver)

  virtual apb_intf vif;

  function new(string name = "apb_driver", uvm_component parent);
    super.new(name,parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual apb_intf)::get(this," ","apb_intf",vif))
      `uvm_fatal("No_vif in driver","virtual interface get failed from config db");
  endfunction: build_phase

  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask: run_phase

  task drive();

  repeat(1)@(vif.drv_cb);

   if(req.READ_WRITE == 0 ) begin
    vif.transfer <= req.transfer;
    vif.READ_WRITE <= req.READ_WRITE;
    vif.apb_write_paddr <= req.apb_write_paddr;
    vif.apb_write_data <= req.apb_write_data;
     $display("");
    `uvm_info("DRV",$sformatf("DRIVER WRITE OPERATION : TRANSFER : %0b | WRITE ADDR : %0d | WRITE DATA : %0d",req.transfer, req.apb_write_paddr, req.apb_write_data),UVM_LOW);
     if(req.apb_write_paddr[8] == 1) begin
       `uvm_info("DRV",$sformatf("WRITING INTO SLAVE 1"), UVM_NONE)
     end
     else begin
       `uvm_info("DRV",$sformatf("WRITING INTO SLAVE 0"), UVM_NONE)
     end
   end
  else
  begin
    vif.transfer <= req.transfer;
    vif.READ_WRITE <= req.READ_WRITE;
    vif.apb_read_paddr <= req.apb_read_paddr;
     $display("");
    `uvm_info("DRV",$sformatf("DRIVER READ OPERATION : TRANSFER : %0b | READ ADDR : %0d",req.transfer, req.apb_read_paddr),UVM_LOW);
    if(req.apb_read_paddr[8] == 1 ) begin
      `uvm_info("DRV",$sformatf("READING FROM SLAVE 1"), UVM_NONE)
    end
    else begin
      `uvm_info("DRV",$sformatf("READING FROM SLAVE 0"), UVM_NONE)
    end

  end
  repeat(2)@(vif.drv_cb);
 endtask: drive
endclass: apb_driver

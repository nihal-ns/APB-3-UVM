/////////////////////////////////////////////
// active monitor //
////////////////////////////////////////////

class apb_monitor_active extends uvm_monitor;
  `uvm_component_utils(apb_monitor_active)

  virtual apb_intf vif;

  uvm_analysis_port #(apb_seq_item) mon_act_port;
  apb_seq_item inp_item;
  
  function new(string name = "apb_monitor_active", uvm_component parent);
    super.new(name,parent);
  endfunction: new 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_act_port = new("mon_act_port",this);
    if(!uvm_config_db#(virtual apb_intf)::get(this,"","apb_intf",vif))
      `uvm_fatal("No_vif","No virtual intf in monitor_active");
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    forever begin
      inp_item = apb_seq_item::type_id::create("inp_item");
      repeat(3)@(vif.mon_cb);
      inp_item.READ_WRITE = vif.READ_WRITE;
      inp_item.apb_write_paddr = vif.apb_write_paddr;
      inp_item.apb_write_data  = vif.apb_write_data;
      inp_item.apb_read_paddr  = vif.apb_read_paddr;
      mon_act_port.write(inp_item);
      $display("");
      `uvm_info("ACT_MON", $sformatf("READ_WRITE : %0b | WRITE ADDR : %0d | WRITE DATA : %0d",inp_item.READ_WRITE, inp_item.apb_write_paddr, inp_item.apb_write_data), UVM_NONE) 
    end
  endtask: run_phase 

endclass:apb_monitor_active

/////////////////////////////////////////////
// passive monitor //
////////////////////////////////////////////

class apb_monitor_passive extends uvm_monitor;
  `uvm_component_utils(apb_monitor_passive)

  virtual apb_intf vif;
  uvm_analysis_port #(apb_seq_item) mon_pass_port;
  apb_seq_item out_item;  

  function new(string name = "apb_monitor_passive", uvm_component parent);
    super.new(name,parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_pass_port = new("mon_pass_port",this);
    if(!uvm_config_db#(virtual apb_intf)::get(this,"","apb_intf",vif))
      `uvm_fatal("No_vif","No virtual intf in monitor_passive");
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    
    forever begin
      repeat(3)@(vif.mon_cb);  
      out_item = apb_seq_item::type_id::create("out_item");
      out_item.apb_read_data_out = vif.apb_read_data_out;
      out_item.PSLVERR = vif.PSLVERR;
      mon_pass_port.write(out_item);
      $display("");
      `uvm_info("PAS_MON", $sformatf("READ ADDR : %0d | READ DATA OUT : %0d | SLVERR : %0b",vif.apb_read_paddr,vif.apb_read_data_out, out_item.PSLVERR), UVM_NONE) 

    end  
  endtask: run_phase

endclass: apb_monitor_passive 

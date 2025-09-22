///////////////////
// active agent //
/////////////////
class apb_agent_active extends uvm_agent;
  `uvm_component_utils(apb_agent_active)

  apb_driver drv;
  apb_monitor_active mon_act;
  apb_sequencer seqr;

  function new(string name = "apb_agent_active", uvm_component parent);
    super.new(name,parent);
  endfunction: new 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(get_is_active == UVM_ACTIVE) begin
      drv = apb_driver::type_id::create("drv",this);
      seqr = apb_sequencer::type_id::create("seqr",this);
    end
    mon_act = apb_monitor_active::type_id::create("mon_act",this);

  endfunction: build_phase 

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction: connect_phase

endclass: apb_agent_active 

////////////////////
// passive agent //
//////////////////
class apb_agent_passive extends uvm_agent;
  `uvm_component_utils(apb_agent_passive)

  apb_driver drv;
  apb_monitor_passive mon_pass;
  apb_sequencer seqr;

  function new(string name = "apb_agent_passive", uvm_component parent);
    super.new(name,parent);
  endfunction: new 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(get_is_active == UVM_ACTIVE) begin
      drv = apb_driver::type_id::create("drv",this);
      seqr = apb_sequencer::type_id::create("seqr",this);
    end
    mon_pass = apb_monitor_passive::type_id::create("mon_pass",this);
  endfunction: build_phase

endclass: apb_agent_passive

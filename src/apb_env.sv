class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)

  apb_agent_active agt_act;
  apb_agent_passive agt_pass;
  apb_scoreboard scb;
  apb_coverage cov;


  function new(string name = "apb_env", uvm_component parent);
    super.new(name,parent);
  endfunction: new 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt_act = apb_agent_active::type_id::create("agt_act",this);
    agt_pass = apb_agent_passive::type_id::create("agt_pass",this);
    
    set_config_int("agt_pass","is_active",UVM_PASSIVE);
    set_config_int("agt_act","is_active",UVM_ACTIVE);
    
    scb = apb_scoreboard::type_id::create("scb",this);
    cov = apb_coverage::type_id::create("cov",this);
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    //connecting monitor and scb
    agt_act.mon_act.mon_act_port.connect(scb.item_act_port);
    agt_pass.mon_pass.mon_pass_port.connect(scb.item_pass_port);

    //connecting monitor and sbcr
    agt_act.mon_act.mon_act_port.connect(cov.mon_act_cg_port);
    agt_pass.mon_pass.mon_pass_port.connect(cov.mon_pass_cg_port);

  endfunction: connect_phase

endclass: apb_env

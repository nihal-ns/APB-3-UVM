class apb_test extends uvm_test;
  `uvm_component_utils(apb_test);

  apb_env env;
  apb_sequence seq;

  function new(string name = "apb_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env", this);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = apb_sequence::type_id::create("seq");
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask:run_phase

endclass: apb_test

class wr_test extends apb_test;

  `uvm_component_utils(wr_test)
  wrd_sequence wr_seq;

  function new(string name = "wr_test", uvm_component parent);
    super.new(name, parent);
  endfunction: new
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    wr_seq = wrd_sequence::type_id::create("wr_seq",this);
    wr_seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask: run_phase

endclass: wr_test
 

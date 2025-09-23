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
//////////////////////////////////////////////////////////////
class wrd_sequence_test extends apb_test;

  `uvm_component_utils(wrd_sequence_test)
  wrd_sequence seq;

  function new(string name = "wrd_sequence_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = wrd_sequence::type_id::create("seq",this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask: run_phase

endclass : wrd_sequence_test

//////////////////////////////////////////////////////////////
class write_read_test extends apb_test;

  `uvm_component_utils(write_read_test)
  write_read seq;

  function new(string name = "write_read_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = write_read::type_id::create("seq",this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask: run_phase


endclass : write_read_test

//////////////////////////////////////////////////////////////
class wr_rd_ov_test extends apb_test;
  `uvm_component_utils(wr_rd_ov_test)
  wr_rd_ov seq;

  function new(string name = "wr_rd_ov_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = wr_rd_ov::type_id::create("seq", this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask

endclass : wr_rd_ov_test 
//////////////////////////////////////////////////////////////
class random_write_test extends apb_test;
  `uvm_component_utils(random_write_test)
  random_write seq;

  function new(string name = "random_write_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = random_write::type_id::create("seq", this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask

endclass : random_write_test
/////////////////////////////////////////////////////////
class regression_test extends apb_test;
  `uvm_component_utils(regression_test)
  regression seq;

  function new(string name = "regression_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq = regression::type_id::create("seq", this);
    seq.start(env.agt_act.seqr);
    phase.drop_objection(this);
  endtask
endclass : regression_test

 

`uvm_analysis_imp_decl(_mon_act_cg)
class apb_coverage extends uvm_subscriber#(apb_seq_item);
  `uvm_component_utils(apb_coverage)
  
  uvm_analysis_imp_mon_act_cg#(apb_seq_item, apb_coverage) mon_act_cg_port;
  uvm_analysis_imp#(apb_seq_item, apb_coverage) mon_pass_cg_port;

  apb_seq_item mon_pass_seq, mon_act_seq;
  real mon_act_cov, mon_pass_cov;

  covergroup input_cvg;
    Transfer: coverpoint mon_act_seq.transfer{
      bins tr = {0, 1};
    }

    apb_write_paddress: coverpoint mon_act_seq.apb_write_paddr{
      bins addr_low   = {[0:127]};
      bins addr_mid   = {[128:255]};
      bins addr_high  = {[256:383]};
      bins addr_upper = {[384:511]};
    }

    apb_read_paddress: coverpoint mon_act_seq.apb_read_paddr {
      bins addr_low   = {[0:127]};
      bins addr_mid   = {[128:255]};
      bins addr_high  = {[256:383]};
      bins addr_upper = {[384:511]};
    }

    READ_WRITE: coverpoint mon_act_seq.READ_WRITE {
      bins read  = {0};
      bins write = {1};
    }

    apb_write_data: coverpoint mon_act_seq.apb_write_data {
      bins low  = {[0:85]};
      bins mid  = {[86:170]};
      bins high = {[171:255]};
    }

    READ_WRITE_X_Trans: cross READ_WRITE, Transfer; 
  endgroup
  
  covergroup output_cvg;
    apb_read_data_out: coverpoint mon_pass_seq.apb_read_data_out {
      bins low  = {[0:85]};
      bins mid  = {[86:170]};
      bins high = {[171:255]};
    }

    PSLVERR: coverpoint mon_pass_seq.PSLVERR {
      bins no_err = {0};
      bins err    = {1};
    }
  endgroup
  
  function new(string name = "apb_coverage", uvm_component parent);
    super.new(name, parent);
    input_cvg = new;
    output_cvg = new;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_act_cg_port = new("mon_act_cg_port", this);
    mon_pass_cg_port = new("mon_pass_cg_port", this);
  endfunction

  function void write(apb_seq_item t);
    mon_pass_seq = t;
    output_cvg.sample();
  endfunction

  function void write_mon_act_cg(apb_seq_item t);
    mon_act_seq = t;
    input_cvg.sample();
  endfunction

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    mon_act_cov = input_cvg.get_coverage();
    mon_pass_cov = output_cvg.get_coverage();
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name, $sformatf("Input Coverage ------> %0.2f%%,", mon_act_cov), UVM_MEDIUM);
    `uvm_info(get_type_name, $sformatf("Output Coverage ------> %0.2f%%", mon_pass_cov), UVM_MEDIUM);
  endfunction

endclass

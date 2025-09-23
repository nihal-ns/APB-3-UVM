`uvm_analysis_imp_decl(_mon_pass)
`uvm_analysis_imp_decl(_mon_act)

class apb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_scoreboard)

  uvm_analysis_imp_mon_act #(apb_seq_item, apb_scoreboard) item_act_port;
  uvm_analysis_imp_mon_pass #(apb_seq_item, apb_scoreboard) item_pass_port;

  apb_seq_item mon_act_packet_q[$];
  apb_seq_item mon_pass_packet_q[$];

  virtual apb_intf vif;
  bit [7:0] wmem [511:0];

  static int pass_count;
  static int fail_count;

  function new(string name = "apb_scoreboard", uvm_component parent);
    super.new(name,parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual apb_intf)::get(this," ","apb_intf",vif))
      `uvm_fatal("No_vif in scoreboard","virtual interface get failed from config db");

    item_act_port = new("item_act_port",this);
    item_pass_port = new("item_pass_port",this);
  endfunction: build_phase

  virtual function void write_mon_act(apb_seq_item pkt);
    `uvm_info(get_type_name(), "Received input packet ", UVM_DEBUG)
    mon_act_packet_q.push_back(pkt);
  endfunction: write_mon_act

  virtual function void write_mon_pass(apb_seq_item pkt);
    `uvm_info(get_type_name(), "Received output packet ", UVM_DEBUG)
    mon_pass_packet_q.push_back(pkt);
  endfunction: write_mon_pass

  virtual task run_phase(uvm_phase phase);
    apb_seq_item act_item;
    apb_seq_item pass_item;

    forever begin
      fork
        begin
          wait(mon_act_packet_q.size()>0);
          act_item  = mon_act_packet_q.pop_front();
          //$display("enter");
        end
        begin
          wait(mon_pass_packet_q.size()>0);
          pass_item = mon_pass_packet_q.pop_front();
          //$display("pass enter");
        end
      join

      if(act_item.READ_WRITE == 0) begin
        wmem[act_item.apb_write_paddr] = act_item.apb_write_data;
        `uvm_info("SCB", $sformatf("WRITE OPERATION | WRITE DATA : %0d | WRITE ADDR : %0d", act_item.apb_write_data, act_item.apb_write_paddr), UVM_NONE)
      end
      else begin
        $display("");
        $display("-------------------------------------------------------------------------------------------------------------------------------------------------");
        `uvm_info("SCB", $sformatf("WRITE ADDR : %0d | READ ADDR : %0d", act_item.apb_write_paddr, act_item.apb_read_paddr), UVM_NONE)
        if(pass_item.apb_read_data_out == wmem[act_item.apb_read_paddr])begin
          pass_count++;
          if(act_item.apb_read_paddr[8] == 0) begin

            `uvm_info("SCB", $sformatf("READING FROM SLAVE 0 PASSED"), UVM_NONE)
            `uvm_info("SCB", $sformatf("TEST PASSED | READ DATA : %0d | MEM : %0d", pass_item.apb_read_data_out,  wmem[act_item.apb_read_paddr]), UVM_NONE)
          end
          else begin
            `uvm_info("SCB", $sformatf("READING FROM SLAVE 1 PASSED"), UVM_NONE)
            `uvm_info("SCB", $sformatf("TEST PASSED | READ DATA : %0d | MEM : %0d", pass_item.apb_read_data_out,  wmem[act_item.apb_read_paddr]), UVM_NONE)
          end
        end
        else begin
          fail_count++;
          if(act_item.apb_read_paddr[8] == 0) begin

            `uvm_info("SCB", $sformatf("READING FROM SLAVE 0 FAILED"), UVM_NONE)
            `uvm_info("SCB", $sformatf("TEST FAILED | READ DATA : %0d | MEM : %0d", pass_item.apb_read_data_out,  wmem[act_item.apb_read_paddr]), UVM_NONE)
          end
          else begin
            `uvm_info("SCB", $sformatf("READING FROM SLAVE 1 FAILED"), UVM_NONE)
            `uvm_info("SCB", $sformatf("TEST FAILED | READ DATA : %0d | MEM : %0d", pass_item.apb_read_data_out,  wmem[act_item.apb_read_paddr]), UVM_NONE)
          end
        end
      end
      $display("---------------------------------------------------------------------------------------------------------------------------------------------------");
    end
  endtask: run_phase

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    $display("");
    `uvm_info("SCB", $sformatf("TOTAL PASS : %0d", pass_count), UVM_NONE)
    `uvm_info("SCB", $sformatf("TOTAL FAIL : %0d", fail_count), UVM_NONE)
    `uvm_info("SCB", $sformatf("TOTAL CASES : %0d", fail_count+pass_count), UVM_NONE)
    $display("");
  endfunction: extract_phase
endclass: apb_scoreboard

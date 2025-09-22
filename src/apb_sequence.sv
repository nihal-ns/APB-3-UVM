class apb_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_sequence)
 
  function new(string name = "apb_sequence");
    super.new(name);
  endfunction: new 

  task body();
    repeat(8) begin
      req = apb_seq_item::type_id::create("req");
      wait_for_grant();
      assert(req.randomize());
      send_request(req);
      wait_for_item_done();
    end
    //get_reponse(req);
  endtask: body

endclass: apb_sequence

// write followed by read
class wrd_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(wrd_sequence)
  bit [8:0] read_addr;

  function new(string name ="wrd_sequence");
    super.new(name);
  endfunction: new
  
  task body();
    repeat(2) begin
      `uvm_do_with(req,{req.READ_WRITE == 0; req.transfer == 1;})
      read_addr = req.apb_write_paddr;
      `uvm_do_with(req,{req.READ_WRITE == 1; req.apb_read_paddr == read_addr;req.transfer == 1;})
    end 
  endtask: body
endclass: wrd_sequence

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
    repeat(10) begin
      `uvm_do_with(req,{req.READ_WRITE == 0; req.transfer == 1;})
      read_addr = req.apb_write_paddr;
      `uvm_do_with(req,{req.READ_WRITE == 1; req.apb_read_paddr == read_addr; req.transfer == 1;})
    end
  endtask: body
endclass: wrd_sequence

// Continuous write and read
class write_read extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(write_read)
  bit [8:0] read_addr;
 logic [8:0] write_addr [20:0];
 int i;

  function new(string name ="write_read");
    super.new(name);
  endfunction: new

  task body();
 // Continuous write
  repeat(5) begin
      `uvm_do_with(req,{req.READ_WRITE == 0; req.transfer == 1;})
   write_addr[i] = req.apb_write_paddr;
   i++;
  end

 // Continuous read
  repeat(5) begin
   i--; // change part
   read_addr = write_addr[i];
   `uvm_do_with(req,{req.READ_WRITE == 1; req.apb_read_paddr == read_addr;req.transfer == 1;})
  end
  endtask: body
endclass: write_read

// write -> write -> read from same address
class write_override extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(write_override)
  bit [8:0] read_addr;

  function new(string name ="write_override");
    super.new(name);
  endfunction: new

  task body();
  // write to same address twice and then read from it
  `uvm_do_with(req,{req.READ_WRITE == 0; req.transfer == 1;})
    read_addr = req.apb_write_paddr;
  `uvm_do_with(req,{req.READ_WRITE == 0; req.apb_read_paddr == read_addr;req.transfer == 1;})

  // READ from the same address
  `uvm_do_with(req,{req.READ_WRITE == 1; req.apb_read_paddr == read_addr;req.transfer == 1;})
  endtask: body
endclass: write_override

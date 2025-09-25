class apb_sequence extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_sequence)

  function new(string name = "apb_sequence");
    super.new(name);
  endfunction: new

  task body();
    repeat(10) begin
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

class wr_rd_ov extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(wr_rd_ov)

  bit [8:0]read_addr;
  function new(string name = "wr_rd_ov");
    super.new(name);
  endfunction

  virtual task body();
    repeat(10) begin
      `uvm_do_with(req,{req.READ_WRITE==0; req.transfer==1; req.apb_write_paddr == 40;})
      read_addr = req.apb_write_paddr;
    end
    repeat(10)begin
      `uvm_do_with(req,{req.READ_WRITE==1; req.transfer==1; req.apb_read_paddr == read_addr;})
    end
  endtask

endclass : wr_rd_ov

class random_write extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(random_write)

  function new(string name ="random_write");
    super.new(name);
  endfunction: new

  task body();
    repeat(10) begin
      //Selecting the random slave, random address, random wdata
      `uvm_do_with(req,{req.READ_WRITE == 0;})
      //Selecting a slave and randomising the addr and write data
      // slave 1 is selected
      `uvm_do_with(req,{req.READ_WRITE == 0; req.apb_write_paddr[8] == 1;})
      `uvm_do_with(req,{req.READ_WRITE == 0; req.apb_write_paddr[8] == 1;})
    end
  endtask: body
endclass: random_write

class error_write extends apb_sequence;
  `uvm_object_utils(error_write)

  function new(string name ="error_write");
    super.new(name);
  endfunction: new

  task body();
    repeat(10) begin
      req = apb_seq_item::type_id::create("req");
      start_item(req);
      req.randomize()with{req.READ_WRITE == 0; req.transfer == 1;};
      req.apb_write_paddr = 9'bxxxxxxxxx;
      req.apb_write_data = 8'bxxxxxxxx;
      finish_item(req);
      
      req = apb_seq_item::type_id::create("req");
      start_item(req);
      req.randomize()with{req.READ_WRITE == 1; req.transfer == 1;};
      req.apb_read_paddr = 9'bxxxxxxxxx;
      finish_item(req);
      
      req = apb_seq_item::type_id::create("req");
      start_item(req);
      req.randomize()with{req.READ_WRITE == 0; req.transfer == 1;};
      req.apb_write_paddr = 9'bxxxxxxxxx;
      finish_item(req);
    end
  endtask: body
endclass: error_write


class regression extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(regression)
  wrd_sequence wrd_sequence_h;
  write_read write_read_h;
  wr_rd_ov wr_rd_ov_h;
  random_write random_write_h;
  error_write er_w;
  function new(string name ="regression");
    super.new(name);
  endfunction: new

  task body();
    repeat(50) begin
      `uvm_do(er_w)
      `uvm_do(wrd_sequence_h)
      `uvm_do(write_read_h)
      `uvm_do(wr_rd_ov_h)
      `uvm_do(random_write_h)
    end
  endtask : body

endclass : regression

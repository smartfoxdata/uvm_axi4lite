////////////////////////////////////////////////////////////////////////////////
//
// MIT License
//
// Copyright (c) 2017 Smartfox Data Solutions Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////


virtual class uvm_axi4lite_base_seq extends uvm_sequence #(uvm_axi4lite_txn);

   function new (string name="uvm_axi4lite_base_seq");
      super.new(name);
   endfunction // new

endclass // uvm_axi4lite_base_seq

class uvm_axi4lite_no_activity_seq extends uvm_axi4lite_base_seq;
   `uvm_object_utils(uvm_axi4lite_no_activity_seq)
   
   function new(string name="uvm_axi4lite_no_activity_seq");
      super.new(name);
   endfunction // new

   virtual task body();
      `uvm_info("SEQ", "executing", UVM_LOW)
   endtask // body
			    
endclass // uvm_axi4lite_no_activity_seq

class uvm_axi4lite_random_seq extends uvm_axi4lite_base_seq;
   `uvm_object_utils(uvm_axi4lite_random_seq)
   
   function new(string name="uvm_axi4lite_random_seq");
      super.new(name);
   endfunction // new

   virtual task body();
      uvm_axi4lite_txn item;
      int num_txn;
      bit typ_txn;
      
     `uvm_info("SEQ", "executing...", UVM_LOW)
      num_txn = $urandom_range(5,20);
      repeat(num_txn) begin	
       `uvm_create(item)
        item.cycles = $urandom_range(1,5);
        item.addr   = $urandom();
        item.data   = $urandom();
	typ_txn     = $random();
	item.trans  = typ_txn ? WRITE : READ;
       `uvm_send(item);
      end      
   endtask // body

endclass // uvm_axi4lite_random_seq

class uvm_axi4lite_directed_seq extends uvm_axi4lite_base_seq;
   `uvm_object_utils(uvm_axi4lite_directed_seq)
   
   function new(string name="uvm_axi4lite_directed_seq");
      super.new(name);
   endfunction // new

   virtual task body();
      uvm_axi4lite_txn item;
      bit [3:0] addr;
     `uvm_info("SEQ", "executing...WR->WR->RD->RD", UVM_LOW)
      for(addr = 0; addr < 8; addr ++) begin
        `uvm_create(item)
	 item.addr   = {14'h0,addr[1:0]};
	 item.trans  = addr[2] ? READ : WRITE;
         item.cycles = $urandom_range(2,10);
         item.data   = $urandom();
        `uvm_send(item);
      end
     `uvm_info("SEQ", "executing...WR->RD->WR->RD", UVM_LOW)
      for(addr = 0; addr < 8; addr ++) begin
        `uvm_create(item)
	 item.addr   = {14'h0,addr[2:1]};
	 item.trans  = addr[0] ? READ : WRITE;
         item.cycles = $urandom_range(2,10);
         item.data   = $urandom();
        `uvm_send(item);
      end
   endtask // body

endclass // uvm_axi4lite_directed_seq

class uvm_axi4lite_usevar_seq extends uvm_axi4lite_base_seq;
   `uvm_object_utils(uvm_axi4lite_usevar_seq)
   `uvm_declare_p_sequencer(uvm_axi4lite_sqr)
   
   function new(string name="uvm_axi4lite_usevar_seq");
      super.new(name);
   endfunction // new

   virtual task body();
      uvm_axi4lite_txn item;
      int id;

      `uvm_info("SEQ", "executing...", UVM_LOW)
      id = p_sequencer.id;
      `uvm_info("SEQ", $sformatf("using id=%0hh from sequencer", id), UVM_LOW)
      `uvm_create(item)
      item.cycles = $urandom_range(1,5);
      item.data = id;
      `uvm_send(item);
   endtask // body

endclass // uvm_axi4lite_usevar_seq

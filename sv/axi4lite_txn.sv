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
typedef enum { READ, WRITE } uvm_axi4lite_txn_e;

class uvm_axi4lite_txn extends uvm_sequence_item;
   rand bit [15:0]   addr;
   rand bit [31:0]   data;
   rand uvm_axi4lite_txn_e   trans;
   rand int unsigned cycles;

   constraint c_cycles { 
      cycles <= 20; 
   }

   `uvm_object_utils_begin(uvm_axi4lite_txn)
      `uvm_field_int  (addr,              UVM_DEFAULT)
      `uvm_field_int  (data,              UVM_DEFAULT)
      `uvm_field_enum (uvm_axi4lite_txn_e, trans, UVM_DEFAULT)	
      `uvm_field_int  (cycles,            UVM_DEFAULT)
   `uvm_object_utils_end

   function new (string name = "uvm_axi4lite_txn");
      super.new(name);
   endfunction // new

   function string convert2string();
      return $sformatf("addr='h%h, data='h%0h, cycles='d%0d",
		        addr, data, cycles);
   endfunction // convert2string
   
endclass // uvm_axi4lite_txn

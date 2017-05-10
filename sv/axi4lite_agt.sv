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


class uvm_axi4lite_agt extends uvm_agent;

   uvm_axi4lite_sqr sqr;
   uvm_axi4lite_drv drv;
   uvm_axi4lite_mon mon;

   `uvm_component_utils(uvm_axi4lite_agt)

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      mon = uvm_axi4lite_mon::type_id::create("mon", this);
      if (get_is_active() == UVM_ACTIVE) begin
	 sqr = uvm_axi4lite_sqr::type_id::create("sqr", this);
	 drv = uvm_axi4lite_drv::type_id::create("drv", this);
      end
   endfunction // build_phase

   function void connect_phase(uvm_phase phase);
      if (get_is_active() == UVM_ACTIVE) begin
	 drv.seq_item_port.connect(sqr.seq_item_export);
      end
   endfunction // connect_phase

endclass // uvm_axi4lite_agt


   
   

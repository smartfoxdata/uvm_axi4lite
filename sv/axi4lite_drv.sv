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

class uvm_axi4lite_drv extends uvm_driver #(uvm_axi4lite_txn);
   protected virtual uvm_axi4lite_if vif;
   protected int id;

   `uvm_component_utils_begin(uvm_axi4lite_drv)
      `uvm_field_int(id, UVM_DEFAULT)
   `uvm_component_utils_end

   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction // new

   function void build_phase (uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual uvm_axi4lite_if)::get(this, "", "vif", vif))
	`uvm_fatal("NOVIF", {"virtual interface must be set for: ",
			     get_full_name(), ".vif"});
   endfunction // build_phase

   virtual task run_phase (uvm_phase phase);
      fork
	 get_and_drive();
	 reset_signals();
      join
   endtask // run_phase

   virtual protected task get_and_drive();
      forever begin
	 @(posedge vif.clk);
	 if (vif.rst == 1'b0) begin
	   @(posedge vif.rst);
 	   @(posedge vif.clk);
	 end
	 seq_item_port.get_next_item(req);
	 `uvm_info("DRV", req.convert2string(), UVM_LOW)
	 repeat(req.cycles) begin
	    @(posedge vif.clk);
	 end
         drive_transfer(req);
	 seq_item_port.item_done();
      end
   endtask // get_and_drive

   virtual protected task reset_signals();
      forever begin
	 @(negedge vif.rst);
         vif.GPIN    <= 32'h0;
         vif.AWADDR  <= 32'h0;
         vif.AWPROT  <=  3'h0;
         vif.AWVALID <=  1'b0;
         vif.WDATA   <= 32'h0;
         vif.WSTRB   <=  4'h0;
         vif.WVALID  <=  1'b0;
         vif.BREADY  <=  1'b1;
         vif.ARADDR  <= 32'h0;
         vif.ARPROT  <=  3'h0;
         vif.ARVALID <=  1'b0;
         vif.RREADY  <=  1'b1;
      end
   endtask // reset_signals

   // drive_transfer
   virtual protected task drive_transfer (uvm_axi4lite_txn txn);
      drive_address_phase(txn);
      drive_data_phase(txn);
   endtask : drive_transfer

   // drive_address_phase
   virtual protected task drive_address_phase (uvm_axi4lite_txn txn);
     `uvm_info("uvm_axi4lite_master_driver", "drive_address_phase",UVM_HIGH)
      case (txn.trans)
         READ : drive_read_address_channel(txn);
         WRITE: drive_write_address_channel(txn);
      endcase
   endtask : drive_address_phase

   // drive_data_phase
   virtual protected task drive_data_phase (uvm_axi4lite_txn txn);
      bit[31:0] rw_data;
      bit err;

      rw_data = txn.data;
      case (txn.trans)
         READ : drive_read_data_channel(rw_data, err);
         WRITE: drive_write_data_channel(rw_data, err);
      endcase     
   endtask : drive_data_phase

   virtual protected task drive_write_address_channel (uvm_axi4lite_txn txn);
      int to_ctr;

      vif.AWADDR  <= {16'h0, txn.addr};
      vif.AWPROT  <= 3'h0;
      vif.AWVALID <= 1'b1;
      for(to_ctr = 0; to_ctr <= 31; to_ctr ++) begin
         @(posedge vif.clk);
         if (vif.AWREADY) break;
      end
      if (to_ctr == 31) begin
        `uvm_error("uvm_axi4lite_master_driver","AWVALID timeout");
      end       
      @(posedge vif.clk);
      vif.AWADDR  <= 32'h0;
      vif.AWPROT  <= 3'h0;
      vif.AWVALID <= 1'b0;     
   endtask : drive_write_address_channel

   virtual protected task drive_read_address_channel (uvm_axi4lite_txn txn);
      int to_ctr;

      vif.ARADDR  <= {16'h0, txn.addr};
      vif.ARPROT  <= 3'h0;
      vif.ARVALID <= 1'b1;
      for(to_ctr = 0; to_ctr <= 31; to_ctr ++) begin
         @(posedge vif.clk);
         if (vif.ARREADY) break;
      end
      if (to_ctr == 31) begin
        `uvm_error("uvm_axi4lite_master_driver","ARVALID timeout");
      end       
      @(posedge vif.clk);
      vif.ARADDR  <= 32'h0;
      vif.ARPROT  <= 3'h0;
      vif.ARVALID <= 1'b0;      
   endtask : drive_read_address_channel

   // drive write data channel
   virtual protected task drive_write_data_channel (bit[31:0] data, 
                                                    output bit error);
      int to_ctr;
     
      vif.WDATA  <= data;
      vif.WSTRB  <= 4'hf;
      vif.WVALID <= 1'b1;
      @(posedge vif.clk);
      for(to_ctr = 0; to_ctr <= 31; to_ctr ++) begin
         @(posedge vif.clk);
         if (vif.WREADY) break;
      end
      if (to_ctr == 31) begin
        `uvm_error("uvm_axi4lite_master_driver","AWVALID timeout");
      end
      @(posedge vif.clk);
      vif.WDATA  <= 32'h0;
      vif.WSTRB  <= 4'h0;
      vif.WVALID <= 1'b0;

      //wait for write response
      for(to_ctr = 0; to_ctr <= 31; to_ctr ++) begin
         @(posedge vif.clk);
         if (vif.BVALID) break;
      end
      if (to_ctr == 31) begin
        `uvm_error("uvm_axi4lite_master_driver","BVALID timeout");
      end
      else begin
         if (vif.BVALID == 1'b1 && vif.BRESP != 2'h0)
	   `uvm_error("uvm_axi4lite_master_driver","Received ERROR Write Response");
         vif.BREADY <= vif.BVALID;
         @(posedge vif.clk);
      end
   endtask : drive_write_data_channel

   // drive read data channel
   virtual protected task drive_read_data_channel (output bit [31:0] data, 
                                                   output bit error);
      int to_ctr;

      for(to_ctr = 0; to_ctr <= 31; to_ctr ++) begin
         @(posedge vif.clk);
         if (vif.RVALID) break;
      end
     
      data = vif.RDATA;
     
      if (to_ctr == 31) begin
        `uvm_error("uvm_axi4lite_master_driver","RVALID timeout");
      end
      else begin
         if (vif.RVALID == 1'b1 && vif.RRESP != 2'h0)
 	   `uvm_error("uvm_axi4lite_master_driver","Received ERROR Read Response");
         vif.RREADY <= vif.RVALID;
         @(posedge vif.clk);
      end
   endtask : drive_read_data_channel

endclass // uvm_axi4lite_drv

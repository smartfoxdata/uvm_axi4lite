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

interface uvm_axi4lite_if;
   logic            clk;
   logic            rst;

   logic [31:0]     AWADDR;
   logic [ 2:0]     AWPROT;
   logic 	    AWVALID;
   logic 	    AWREADY;
   logic [31:0]     WDATA;
   logic [ 3:0]     WSTRB;
   logic 	    WVALID;
   logic 	    WREADY;
   logic [1:0] 	    BRESP;
   logic 	    BVALID;
   logic 	    BREADY;
   logic [31:0]     ARADDR;
   logic [ 2:0]     ARPROT;
   logic 	    ARVALID;
   logic 	    ARREADY;
   logic [31:0]     RDATA;
   logic [ 1:0]     RRESP;
   logic 	    RVALID;
   logic 	    RREADY;
   logic [31:0]     GPOUT;
   logic 	    INT;
   logic [31:0]     GPIN;

endinterface // uvm_axi4lite_if

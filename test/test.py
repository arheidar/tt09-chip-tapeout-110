# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

#   // initial begin 
#   //   forever begin
#   //   clk = 0;
#   //   #20 clk = ~clk;
#   //   end
#   // end

# //  initial begin
# //     clk = 0;
# //     ui_in = {4'b0000, 4'b1000}; 
# //     uio_in = '0; 
# //     rst_n = 0;
# //     #(1000) 
# //     rst_n = 1;
# //     #(1000)
# //     ui_in = {4'b1000, 4'b1000}; 


# //     #(1000000000);
# //     $finish;
# //   end 

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 10
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")

    # Set the input values you want to test
    dut.ui_in.value = 136

    await ClockCycles(dut.clk, 100)
    # # Wait for one clock cycle to see the output values
    # await ClockCycles(dut.clk, 1)

    # # The following assersion is just an example of how to check the output values.
    # # Change it to match the actual expected output of your module:
    # assert dut.uo_out.value == 50

    # # Keep testing the module by changing the input values, waiting for
    # # one or more clock cycles, and asserting the expected output values.

`timescale 1ns/1ps

module testbench;

  // Inputs
  logic [15:0] operand_a;
  logic [15:0] operand_b;
  logic [7:0] operation;

  // Outputs
  logic [15:0] result;
  logic carry_out;

  // Instantiate the ALU
  alu_16bit_extended dut (
    .operand_a(operand_a),
    .operand_b(operand_b),
    .operation(operation),
    .result(result),
    .carry_out(carry_out)
  );

  // VCD dump for waveform
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
  end

  // Task to run a test
  task run_test(input [15:0] a, input [15:0] b, input [7:0] op, input string desc);
    begin
      operand_a = a;
      operand_b = b;
      operation = op;
      #10;
      $display("Test: %-20s | A = %0d | B = %0d | OP = %h | Result = %0d | Carry = %b",
               desc, a, b, op, result, carry_out);
    end
  endtask

  // Test sequence
  initial begin
    // Arithmetic
    run_test(100, 200, 8'h00, "Addition");
    run_test(300, 150, 8'h01, "Subtraction");
    run_test(12, 12, 8'h02, "Multiplication");
    run_test(100, 5, 8'h03, "Division");
    run_test(100, 6, 8'h04, "Modulus");

    // Logic
    run_test(16'hA5A5, 16'h5A5A, 8'h08, "AND");
    run_test(16'hA5A5, 16'h5A5A, 8'h09, "OR");
    run_test(16'hA5A5, 16'h5A5A, 8'h0A, "XOR");
    run_test(16'hAAAA, 16'h5555, 8'h0B, "NOR");
    run_test(16'hAAAA, 16'h5555, 8'h0C, "NAND");
    run_test(16'hAAAA, 16'h5555, 8'h0D, "XNOR");

    // Comparison
    run_test(20, 10, 8'h10, "Greater Than");
    run_test(50, 50, 8'h11, "Equal");
    run_test(10, 20, 8'h12, "Less Than");

    // Advanced Math
    run_test(36, 60, 8'h26, "GCD");
    run_test(6, 8, 8'h27, "LCM");
    run_test(16'hAAAA, 16'h5555, 8'h28, "Hamming Distance");

    // Shifts
    run_test(16'h00F0, 4, 8'h30, "Left Shift");
    run_test(16'hF000, 4, 8'h31, "Right Shift");
    run_test(-16'sd8, 2, 8'h32, "Arithmetic Right Shift");

    // Bit manipulation
    run_test(16'hABCD, 0, 8'h38, "Upper Byte Mask");
    run_test(16'h1234, 0, 8'h39, "Lower Byte Set");
    run_test(16'h1234, 0, 8'h3A, "XOR with AAAA");

    // Redundant logic (again)
    run_test(16'h1111, 16'h2222, 8'h3C, "AND (dup)");
    run_test(16'h1111, 16'h2222, 8'h3D, "OR (dup)");

    // Increment/Decrement
    run_test(100, 0, 8'h40, "Increment");
    run_test(100, 0, 8'h41, "Decrement");

    // Absolute
    run_test(-16'sd1234, 0, 8'h50, "Absolute");

    // Power
    run_test(2, 4, 8'h51, "Power");

    // Trig functions
    run_test(45, 0, 8'h52, "Sine(45°)");
    run_test(60, 0, 8'h53, "Cosine(60°)");
    run_test(30, 0, 8'h54, "Tangent(30°)");

    // Edge case: division by zero
    run_test(100, 0, 8'h03, "Divide by Zero");
    run_test(100, 0, 8'h04, "Mod by Zero");

    #20;
    $display("All tests completed.");
    $finish;
  end

endmodule

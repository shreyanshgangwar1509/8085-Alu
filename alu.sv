module tb_alu_8bit;
    reg [7:0] operand_a; // Input operand A
    reg [7:0] operand_b; // Input operand B
    reg [3:0] operation; // Operation selection
    wire [7:0] result;   // Output result
    wire carry_out;      // Output carry_out
     // Instantiating the ALU module
    alu_8bit uut(result, carry_out, operand_a, operand_b, operation); 
   
    initial begin
        operand_a = 8'b00110011; // Initialize operand A
        operand_b = 8'b11001100; // Initialize operand B
        operation = 4'b0000;     // Initialize operation (addition)
        #1000 $finish;           // Finish simulation after 1000 time units
        $monitor("operand_a=%b operand_b=%b operation=%b result=%b carry_out=%b", operand_a, operand_b, operation, result, carry_out);
     end

    always begin
        operand_a = $random; // Generate random value for operand A
        operand_b = $random; // Generate random value for operand B
        operation = $random; // Generate random value for operation
        #50;                // Wait for 50 time units
    end
endmodule 
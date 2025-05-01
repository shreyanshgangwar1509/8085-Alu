module alu_8bit(
    input [7:0] operand_a,
    input [7:0] operand_b,
    input [3:0] operation,
    output [7:0] result,
    output carry_out
);
    reg [7:0] ALU_Result;
    wire [8:0] extended_result;
    assign result = ALU_Result;    
    assign extended_result = {1'b0, operand_a} + {1'b0, operand_b};
    assign carry_out = extended_result[8];  

    always @(*)
    begin
        case (operation)
         // Arithmetic operations
         4'b0000: ALU_Result = operand_a + operand_b;    // Addition
         4'b0001: ALU_Result = operand_a - operand_b;    // Subtraction
         4'b0010: ALU_Result = operand_a * operand_b;    // Multiplication
         4'b0011: ALU_Result = operand_a / operand_b;    // Division
         // Bitwise operations
         4'b0100: ALU_Result = operand_a << 1;  // Logical shift left
         4'b0101: ALU_Result = operand_a >> 1;  // Logical shift right
         4'b0110: ALU_Result = {operand_a[6:0], operand_a[7]}; // Rotate left
         4'b0111: ALU_Result = {operand_a[0], operand_a[7:1]};// Rotate right
         // Logical operations
         4'b1000: ALU_Result = operand_a & operand_b; // Logical AND
         4'b1001: ALU_Result = operand_a | operand_b; // Logical OR
         4'b1010: ALU_Result = operand_a ^ operand_b; // Logical XOR
         4'b1011: ALU_Result = ~(operand_a | operand_b);// Logical NOR
         4'b1100: ALU_Result = ~(operand_a & operand_b);// Logical NAND
         4'b1101: ALU_Result = ~(operand_a ^ operand_b); // Logical XNOR
         // Comparison operations
         4'b1110: ALU_Result = (operand_a > operand_b) ? 8'd1 : 8'd0;// Greater comparison
         4'b1111: ALU_Result = (operand_a == operand_b) ? 8'd1 : 8'd0; // Equal comparison
         default: ALU_Result = 8'bxxxx_xxxx; // don't  care(default case)
        endcase
    end
endmodule


// module alu_16bit_extended (
//     input [15:0] operand_a,  // Operand A (16-bit)
//     input [15:0] operand_b,  // Operand B (16-bit)
//     input [7:0] operation,   // 8-bit operation code (allowing more operations)
//     output reg [15:0] result, // Result of the operation
//     output carry_out
// );

//     // Carry out logic (for addition/subtraction)
//     wire [16:0] extended_result_add = {1'b0, operand_a} + {1'b0, operand_b};
//     assign carry_out = extended_result_add[16];

//     always @(*) begin
//         case (operation)
//             // Arithmetic operations
//             8'b00000000: result = operand_a + operand_b;      // Addition
//             8'b00000001: result = operand_a - operand_b;      // Subtraction
//             8'b00000010: result = operand_a * operand_b;      // Multiplication
//             8'b00000011: result = operand_a / operand_b;      // Division (integer)
//             8'b00000100: result = operand_a % operand_b;      // Modulo (remainder)

//             // Bitwise operations
//             8'b00001000: result = operand_a & operand_b;      // AND
//             8'b00001001: result = operand_a | operand_b;      // OR
//             8'b00001010: result = operand_a ^ operand_b;      // XOR
//             8'b00001011: result = ~(operand_a | operand_b);   // NOR
//             8'b00001100: result = ~(operand_a & operand_b);   // NAND
//             8'b00001101: result = ~(operand_a ^ operand_b);   // XNOR

//             // Comparison operations
//             8'b00010000: result = (operand_a > operand_b) ? 16'd1 : 16'd0;  // Greater than
//             8'b00010001: result = (operand_a == operand_b) ? 16'd1 : 16'd0; // Equal to
//             8'b00010010: result = (operand_a < operand_b) ? 16'd1 : 16'd0;  // Less than

//             // New Operations (GCD, LCM, Hamming Distance)
//             8'b00100110: result = gcd(operand_a, operand_b);     // GCD
//             8'b00100111: result = lcm(operand_a, operand_b);     // LCM
//             8'b00101000: result = hamming_distance(operand_a, operand_b);  // Hamming Distance

//             // Bitwise Shift and Rotate operations
//             8'b00110000: result = operand_a << operand_b;  // Logical Shift Left
//             8'b00110001: result = operand_a >> operand_b;  // Logical Shift Right
//             8'b00110010: result = $signed(operand_a) >>> operand_b;  // Arithmetic Shift Right (Sign extension)
//             8'b00110011: result = {operand_a[15-b:0], operand_a[15:16-b]}; // Rotate Left (parameter b determines the number of bits)
//             8'b00110100: result = {operand_a[15-b:0], operand_a[15:16-b]}; // Rotate Right (parameter b determines the number of bits)

//             // Logical Operations with Constants
//             8'b00111000: result = operand_a & 16'hFF00; // AND with constant 0xFF00
//             8'b00111001: result = operand_a | 16'h00FF; // OR with constant 0x00FF
//             8'b00111010: result = operand_a ^ 16'hAAAA; // XOR with constant 0xAAAA

//             // Bit Masking
//             8'b00111100: result = operand_a & operand_b;  // Apply Mask (AND with operand_b)
//             8'b00111101: result = operand_a | operand_b;  // Apply Mask (OR with operand_b)

//             // Increment and Decrement
//             8'b01000000: result = operand_a + 16'd1;  // Increment operand_a
//             8'b01000001: result = operand_a - 16'd1;  // Decrement operand_a

//             // Absolute value
//             8'b01010000: result = (operand_a[15]) ? -operand_a : operand_a;  // Absolute value of operand_a

//             // Power Function (a^b)
//             8'b01010001: result = power(operand_a, operand_b);  // a^b

//             // Trigonometric approximations (Sine, Cosine, Tangent)
//             8'b01010010: result = sine(operand_a);  // Approximate sine for operand_a
//             8'b01010011: result = cosine(operand_a);  // Approximate cosine for operand_a
//             8'b01010100: result = tangent(operand_a);  // Approximate tangent for operand_a

//             default: result = 16'bXXXX_XXXX_XXXX_XXXX;  // Undefined operation
//         endcase
//     end

//     // Helper functions

//     // Euclidean algorithm for GCD
//     function [15:0] gcd(input [15:0] a, input [15:0] b);
//         integer temp;
//         begin
//             while (b != 0) begin
//                 temp = b;
//                 b = a % b;
//                 a = temp;
//             end
//             gcd = a;
//         end
//     endfunction

//     // LCM based on GCD
//     function [15:0] lcm(input [15:0] a, input [15:0] b);
//         begin
//             lcm = (a * b) / gcd(a, b);  // LCM based on GCD
//         end
//     endfunction

//     // Hamming distance function
//     function [15:0] hamming_distance(input [15:0] a, input [15:0] b);
//         integer count;
//         begin
//             count = 0;
//             for (integer i = 0; i < 16; i = i + 1) begin
//                 if (a[i] != b[i]) count = count + 1;
//             end
//             hamming_distance = count;
//         end
//     endfunction

//     // Power Function (a^b)
//     function [15:0] power(input [15:0] a, input [15:0] b);
//         integer i;
//         reg [15:0] result;
//         begin
//             result = 1;
//             for (i = 0; i < b; i = i + 1) begin
//                 result = result * a;
//             end
//             power = result;
//         end
//     endfunction

//     // Full LUT for Sine, Cosine, and Tangent
//     reg [15:0] sine_table [0:255];   // 256 entries for sine values
//     reg [15:0] cosine_table [0:255]; // 256 entries for cosine values
//     reg [15:0] tangent_table [0:255]; // 256 entries for tangent values

//     // Initialize LUT tables
//     initial begin
//         integer i;
//         real angle_rad;
//         for (i = 0; i < 256; i = i + 1) begin
//             angle_rad = (i * 3.141592653589793 / 128.0); // Convert index to radians
//             sine_table[i] = $rtoi($sin(angle_rad) * 32767);    // Scale sine values
//             cosine_table[i] = $rtoi($cos(angle_rad) * 32767);  // Scale cosine values
//             tangent_table[i] = (i % 90 == 0 && i % 180 != 0) ? 16'h7FFF : // Handling large values at 90 and 270 degrees
//                                $rtoi($tan(angle_rad) * 32767);           // Scale tangent values
//         end
//     end

//     // Trigonometric LUT Access Functions
//     function [15:0] sine(input [15:0] angle);
//         reg [7:0] index;
//         begin
//             index = angle[7:0];  // Use lower 8 bits for angle lookup
//             sine = sine_table[index];
//         end
//     endfunction

//     function [15:0] cosine(input [15:0] angle);
//         reg [7:0] index;
//         begin
//             index = angle[7:0];  // Use lower 8 bits for angle lookup
//             cosine = cosine_table[index];
//         end
//     endfunction

//     function [15:0] tangent(input [15:0] angle);
//         reg [7:0] index;
//         begin
//             index = angle[7:0];  // Use lower 8 bits for angle lookup
//             tangent = tangent_table[index];
//         end
//     endfunction

// endmodule

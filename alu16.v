module alu_16bit_extended (
    input [15:0] operand_a,  // Operand A (16-bit)
    input [15:0] operand_b,  // Operand B (16-bit)
    input [7:0] operation,   // 8-bit operation code
    output reg [15:0] result, // Result of the operation
    output carry_out
);

    // Carry out logic (for addition)
    wire [16:0] extended_result_add = {1'b0, operand_a} + {1'b0, operand_b};
    assign carry_out = extended_result_add[16];

    // Helper functions
    function [15:0] gcd(input [15:0] a, input [15:0] b);
        reg [15:0] temp;
        begin
            while (b != 0) begin
                temp = b;
                b = a % b;
                a = temp;
            end
            gcd = a;
        end
    endfunction

    function [15:0] lcm(input [15:0] a, input [15:0] b);
        begin
            lcm = (a * b) / gcd(a, b);
        end
    endfunction

    function [15:0] hamming_distance(input [15:0] a, input [15:0] b);
        integer i;
        begin
            hamming_distance = 0;
            for (i = 0; i < 16; i = i + 1)
                hamming_distance = hamming_distance + (a[i] ^ b[i]);
        end
    endfunction

    function [15:0] power(input [15:0] a, input [15:0] b);
        integer i;
        reg [15:0] res;
        begin
            res = 1;
            for (i = 0; i < b; i = i + 1)
                res = res * a;
            power = res;
        end
    endfunction

    // LUTs for trig functions
    reg [15:0] sine_table [0:255];
    reg [15:0] cosine_table [0:255];
    reg [15:0] tangent_table [0:255];

    initial begin
        integer i;
        real angle_rad;
        for (i = 0; i < 256; i = i + 1) begin
            angle_rad = i * 3.141592653589793 / 128.0;
            sine_table[i] = $rtoi($sin(angle_rad) * 32767);
            cosine_table[i] = $rtoi($cos(angle_rad) * 32767);
            tangent_table[i] = (i % 90 == 0 && i % 180 != 0) ? 16'h7FFF :
                               $rtoi($tan(angle_rad) * 32767);
        end
    end

    function [15:0] sine(input [15:0] angle);
        begin
            sine = sine_table[angle[7:0]];
        end
    endfunction

    function [15:0] cosine(input [15:0] angle);
        begin
            cosine = cosine_table[angle[7:0]];
        end
    endfunction

    function [15:0] tangent(input [15:0] angle);
        begin
            tangent = tangent_table[angle[7:0]];
        end
    endfunction

    always @(*) begin
        case (operation)
            8'h00: result = operand_a + operand_b;
            8'h01: result = operand_a - operand_b;
            8'h02: result = operand_a * operand_b;
            8'h03: result = operand_b != 0 ? operand_a / operand_b : 16'hFFFF;
            8'h04: result = operand_b != 0 ? operand_a % operand_b : 16'hFFFF;
            8'h08: result = operand_a & operand_b;
            8'h09: result = operand_a | operand_b;
            8'h0A: result = operand_a ^ operand_b;
            8'h0B: result = ~(operand_a | operand_b);
            8'h0C: result = ~(operand_a & operand_b);
            8'h0D: result = ~(operand_a ^ operand_b);
            8'h10: result = (operand_a > operand_b) ? 16'd1 : 16'd0;
            8'h11: result = (operand_a == operand_b) ? 16'd1 : 16'd0;
            8'h12: result = (operand_a < operand_b) ? 16'd1 : 16'd0;
            8'h26: result = gcd(operand_a, operand_b);
            8'h27: result = lcm(operand_a, operand_b);
            8'h28: result = hamming_distance(operand_a, operand_b);
            8'h30: result = operand_a << operand_b;
            8'h31: result = operand_a >> operand_b;
            8'h32: result = $signed(operand_a) >>> operand_b;
            8'h38: result = operand_a & 16'hFF00;
            8'h39: result = operand_a | 16'h00FF;
            8'h3A: result = operand_a ^ 16'hAAAA;
            8'h3C: result = operand_a & operand_b;
            8'h3D: result = operand_a | operand_b;
            8'h40: result = operand_a + 1;
            8'h41: result = operand_a - 1;
            8'h50: result = operand_a[15] ? -operand_a : operand_a;
            8'h51: result = power(operand_a, operand_b);
            8'h52: result = sine(operand_a);
            8'h53: result = cosine(operand_a);
            8'h54: result = tangent(operand_a);
            default: result = 16'hXXXX;
        endcase
    end

endmodule
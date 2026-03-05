// 4-bit ALU
// Operations: ADD, SUB, AND, OR, XOR, NOT, SHL, SHR

module alu (
    input  [3:0] A,        // Operand A
    input  [3:0] B,        // Operand B
    input  [2:0] opcode,   // Operation select
    output reg [3:0] result, // Output result
    output reg carry,      // Carry flag
    output reg zero,       // Zero flag
    output reg overflow    // Overflow flag
);

    reg [4:0] temp; // 5-bit temp to catch carry

    always @(*) begin
        // Default flag values
        carry    = 0;
        overflow = 0;

        case (opcode)
            3'b000: begin // ADD
                temp   = A + B;
                result = temp[3:0];
                carry  = temp[4];
                overflow = (~A[3] & ~B[3] & result[3]) |
                           ( A[3] &  B[3] & ~result[3]);
            end

            3'b001: begin // SUB
                temp   = A - B;
                result = temp[3:0];
                carry  = temp[4];
                overflow = (~A[3] &  B[3] & result[3]) |
                           ( A[3] & ~B[3] & ~result[3]);
            end

            3'b010: result = A & B;  // AND
            3'b011: result = A | B;  // OR
            3'b100: result = A ^ B;  // XOR
            3'b101: result = ~A;     // NOT A
            3'b110: result = A << 1; // Shift Left
            3'b111: result = A >> 1; // Shift Right

            default: result = 4'b0000;
        endcase

       
        zero = (result == 4'b0000);
    end

endmodule

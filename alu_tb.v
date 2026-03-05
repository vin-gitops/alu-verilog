// Testbench

`timescale 1ns/1ps

module tb_alu;

    
    reg  [3:0] A, B;
    reg  [2:0] opcode;
    wire [3:0] result;
    wire carry, zero, overflow;

    // Instantiate the ALU
    alu uut (
        .A(A), .B(B),
        .opcode(opcode),
        .result(result),
        .carry(carry),
        .zero(zero),
        .overflow(overflow)
    );

    // Task to display results cleanly
    task apply_test;
        input [3:0] a, b;
        input [2:0] op;
        input [47:0] op_name; // 6 chars
        begin
            A = a; B = b; opcode = op;
            #10;
            $display("Op: %s | A=%b B=%b | Result=%b | C=%b Z=%b OV=%b",
                      op_name, A, B, result, carry, zero, overflow);
        end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_alu);

        $display("===== ALU TESTBENCH =====");

        // ADD tests
        apply_test(4'b0011, 4'b0001, 3'b000, "ADD   "); // 3+1=4
        apply_test(4'b1111, 4'b0001, 3'b000, "ADD   "); // overflow test

        // SUB tests
        apply_test(4'b0101, 4'b0011, 3'b001, "SUB   "); // 5-3=2
        apply_test(4'b0000, 4'b0001, 3'b001, "SUB   "); // underflow test

        // Logic ops
        apply_test(4'b1010, 4'b1100, 3'b010, "AND   ");
        apply_test(4'b1010, 4'b1100, 3'b011, "OR    ");
        apply_test(4'b1010, 4'b1100, 3'b100, "XOR   ");
        apply_test(4'b1010, 4'b0000, 3'b101, "NOT   ");

        // Shift ops
        apply_test(4'b0001, 4'b0000, 3'b110, "SHL   "); // 1 → 2
        apply_test(4'b1000, 4'b0000, 3'b111, "SHR   "); // 8 → 4

        // Zero flag test
        apply_test(4'b0000, 4'b0000, 3'b000, "ADD   "); // 0+0=0, zero=1

        $display("===== TEST COMPLETE =====");
        $finish;
    end

endmodule

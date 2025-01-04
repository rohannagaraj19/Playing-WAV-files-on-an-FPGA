
module quickWav(
    input wire [14:0] index,
    output reg [7:0] out
);
    reg [7:0] wave_table [0:22049];

    initial begin
        $readmemh("wave_table.hex", wave_table); // Load from external file
    end

    always @(*) begin
        out = wave_table[index % 22050];
    end
endmodule

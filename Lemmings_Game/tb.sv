module tb;

l_if l_if();

lemmings1_design dut (
    .clk(l_if.clk),
    .areset(l_if.areset),
    .bump_left(l_if.bump_left),
    .bump_right(l_if.bump_right),
    .walk_left(l_if.walk_left),
    .walk_right(l_if.walk_right)
);

initial begin
    // Initialize signals
    l_if.clk = 0;
    l_if.areset = 1;
    l_if.bump_left = 0;
    l_if.bump_right = 0;

    // Release reset after some time
    #20;
    l_if.areset = 0;

    // Simulate some bump events
    #30;
    l_if.bump_left = 1; // Lemmings should start walking right
    #20;
    l_if.bump_left = 0;

    #30;
    l_if.bump_right = 1; // Lemmings should start walking left
    #20;
    l_if.bump_right = 0;

    // Finish simulation after some time
    #100;
    $finish;
end

initial begin
    forever #5 l_if.clk = ~l_if.clk; // Generate clock with period of 10 time units
end

initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
end

initial begin
    uvm_config_db #(virtual l_if) :: set(null, "uvm_test_top.environment.agt*","vif",vif);
    run_test("test");
end

endmodule
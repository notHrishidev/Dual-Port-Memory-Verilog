module DualPortMem_tb();
    //parameters:
    parameter addrW = 8;
    parameter dataW = 16;

    //signals:
    reg clk;
    
    //Port A stuff
	reg [dataW-1:0] dInA;
	wire [dataW-1:0] dOutA;
	reg [addrW-1:0] addrA;
	reg wEnA;
	reg EnA;
    
    //Port B stuff
	reg [dataW-1:0] dInB;
	wire [dataW-1:0] dOutB;
	reg [addrW-1:0] addrB;
	reg wEnB;
	reg EnB;
	
	//collision detection
	wire collision;

    //DUT Instantiation:
    DualPortMem DUT(
        .clk(clk),

        .dInA(dInA),
        .dOutA(dOutA),
        .addrA(addrA),
        .wEnA(wEnA),
        .EnA(EnA),

        .dInB(dInB),
        .dOutB(dOutB),
        .addrB(addrB),
        .wEnB(wEnB),
        .EnB(EnB),

        .collision(collision)
    );
    initial begin //Initialise all the variables
        clk=0;
        wEnA=0;
        wEnB=0;
        EnA=0;
        EnB=0;
    end

    initial begin
        forever #5 clk = ~clk; //Generates clock pulses forever
    end

    //Task definitions for different operations:
    task write2A; //Write DATA to specified ADDRESS through PORT A
    input [addrW-1:0] addr;
    input [dataW-1:0] data;
    begin
        EnA=1;
        wEnA=1;
        addrA = addr;
        dInA = data;
        @(posedge clk);
        #2;
        wEnA=0;
        EnA=0;
    end
    endtask

    task write2B; //Write DATA to specified ADDRESS through PORT B
    input [addrW-1:0] addr;
    input [dataW-1:0] data;
    begin
        EnB=1;
        wEnB=1;
        addrB = addr;
        dInB = data;
        @(posedge clk);
        #2;
        wEnB=0;
        EnB=0;
    end
    endtask

    task readA; //Read DATA from specified ADDRESS through PORT A
    input [addrW-1:0] addr;
    output [dataW-1:0] rData;
    begin
        EnA=1;
        addrA = addr;
        @(posedge clk);
        #2;
        rData = dOutA;
        EnA=0;
    end
    endtask

    task readB; //Read DATA from specified ADDRESS through PORT B
    input [addrW-1:0] addr;
    output [dataW-1:0] rData;
    begin
        EnB=1;
        addrB = addr;
        @(posedge clk);
        #2;
        rData = dOutB;
        EnB=0;
    end
    endtask
    reg [dataW-1:0] d1;
    reg [dataW-1:0] d2;
    initial begin
        #3
        write2A(8'h1,16'h2);
        #10;
        write2B(8'h3,16'h4);
        #10;
        readA(8'h1,d1);
        #10;
        $display("data read from port A: %h", d1);
        readB(8'h3,d2);
        #10;
        $display("data read from port B: %h", d2);
        #100;
        fork
        write2A(8'h5,16'h7);
        write2B(8'h5,16'h8); //Causing collision to check if the logic is working properly. It should prioritise A.
        join
        readA(8'h5,d1);
        #10;
        $display("data read from port A: %h", d1);
    end

endmodule
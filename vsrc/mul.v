module mul(CLK, rst, e, cnt, SYN, TGR);
   input CLK, rst;
    input wire [7:0] e;
    output TGR, SYN;
	output reg [4:0] cnt;
   wire [63:0] z, n, x, zz1;//, zz2, zz3, zz4, zz5, zz6, zz7, zz8, zz9, zz10;
   wire [63:0] do1;//, do2, do3, do4, do5, do6, do7, do8, do9, do10;
	wire e_round;

   assign SYN = |({do1}); //, do2, do3, do4, do5, do6, do7, do8, do9, do10});
   assign TGR = e_round;
	assign n=64'hbe3a20ff7a7d7fca;
	assign x=64'hf01f2e724ac0ab35;

   sam_o U1 (.clk(CLK), .z( (cnt[2:0]==3'b000)? 64'h0000000000000001:zz1), .n(n), .x(x), .e(e_round), .zz(zz1))/*synthesis syn_dspstyle = "logic" */;
   //sam_o U2 (.clk(clk), .z( (cnt[2:0]==3'b000)? 64'h0000000000000001:zz2), .n(n), .x(x), .e(e_round), .zz(zz2))/*synthesis syn_dspstyle = "logic"*/;
   //sam_o U3 (.clk(clk), .z( (cnt[2:0]==3'b000)? 64'h0000000000000001:zz3), .n(n), .x(x), .e(e_round), .zz(zz3))/*synthesis syn_dspstyle = "logic"*/;
   //sam_o U4 (.clk(clk), .z( (cnt[2:0]==3'b000)? 64'h0000000000000001:zz4), .n(n), .x(x), .e(e_round), .zz(zz4))/*synthesis syn_dspstyle = "logic"*/;
   //sam_o U5 (.clk(clk), .z( (cnt[2:0]==3'b000)? 64'h0000000000000001:zz5), .n(n), .x(x), .e(e_round), .zz(zz5))/*synthesis syn_dspstyle = "logic"*/;
   //sam_o U6 (.clk(clk), .z( (cnt[2:0]==3'b000)? 64'h0000000000000001:zz6), .n(n), .x(x), .e(e_round), .zz(zz6))/*synthesis syn_dspstyle = "logic"*/;
   //sam_o U7 (.clk(clk), .z( (cnt[2:0]==3'b000)? 64'h0000000000000001:zz7), .n(n), .x(x), .e(e_round), .zz(zz7))/*synthesis syn_dspstyle = "logic"*/;
   //sam_o U8 (.clk(clk), .z( (cnt[2:0]==3'b000)? 64'h0000000000000001:zz8), .n(n), .x(x), .e(e_round), .zz(zz8))/*synthesis syn_dspstyle = "logic"*/;
   //sam_o U9 (.clk(clk), .z( (cnt[2:0]==3'b000)? 64'h0000000000000001:zz9), .n(n), .x(x), .e(e_round), .zz(zz9))/*synthesis syn_dspstyle = "logic"*/;
   //sam_o U10 (.clk(clk), .z( (cnt[2:0]==3'b000)? 64'h0000000000000001:zz10), .n(n), .x(x), .e(e_round), .zz(zz10))/*synthesis syn_dspstyle = "logic"*/;

	assign e_round=e[7-cnt[2:0]];

	
	always @(negedge CLK) begin
		if(rst==1'b1) cnt=5'b00000;
		else cnt=cnt+5'b00001;
	end
	
	ram1 Ur (//[1:10](
	.addr(cnt[3:0]),
	.clk(CLK),
	.data_in(zz1), //{zz1, zz2, zz3, zz4, zz5, zz6, zz7, zz8, zz9, zz10}),
	.data_out(do1), //{do1, do2, do3, do4, do5, do6, do7, do8, do9, do10}),
	.wr_en(1'b1));


endmodule

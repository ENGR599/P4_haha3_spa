`timescale 1ns / 1ps
`define KEY_PASS_MACRO 8'hAC

module top (
            CLK_50,
            CLK_OUT,
            SW,
            BTN,
            LED,
            TGR,
            SYN,
            RsRx,
            RsTx
);

// Match names from constraints
input wire CLK_50;
output logic CLK_OUT;

input wire [9:0] SW;
input wire [3:0] BTN;
output wire [7:0] LED;

output wire TGR;
output wire SYN;

input logic RsRx;
output logic RsTx;

// internals
typedef enum {
              ST_IDLE,
              ST_RUN,
              ST_BUFF,
              ST_OUT
} state_type_e;

state_type_e state;
state_type_e next_state;

wire rst;

logic [7:0] s_axis_tdata, s_axis_next_tdata;
logic       s_axis_tvalid;
wire        s_axis_tready;

wire [7:0] m_axis_tdata;
wire        m_axis_tvalid;
logic       m_axis_tready;

logic [7:0] attempt, nAttempt, E;
logic [4:0] count;

divi dv1 (
   .clk(CLK_50),
   .clkout(CLK_OUT) // 50 MHz / 40 = 1.5 MHz
);

mul mul0 (
   .CLK(CLK_OUT),
   .rst(rst),
   .e(E),
   .cnt(count),
   .SYN(SYN),
   .TGR(TGR)
);

uart uart1 (
                .clk(CLK_OUT),
                .rst(rst),
                // AXI input
                .s_axis_tdata(s_axis_tdata),
                .s_axis_tvalid(s_axis_tvalid),
                .s_axis_tready(s_axis_tready),
                // AXI output
                .m_axis_tdata(m_axis_tdata),
                .m_axis_tvalid(m_axis_tvalid),
                .m_axis_tready(m_axis_tready),
                // uart
                .rxd(RsRx),
                .txd(RsTx),
                // status
                .tx_busy(),
                .rx_busy(),
                .rx_overrun_error(),
                .rx_frame_error(),
                // configuration
                .prescale(16'd16) // = (50000000/ 40) / (9600 * 8)
);

assign LED = SW;
assign rst = SW[9];
assign E = SW | attempt;
//assign CLK_OUT = CLK_50;

always_ff @(posedge CLK_OUT) begin //might be dangerous
    if (rst) begin
        state<= ST_IDLE;
        attempt <= 'h0;
        s_axis_tdata <= 'h0;
    end else begin
        state<= next_state;
        attempt <= nAttempt;
        s_axis_tdata <= s_axis_next_tdata;
    end
end

always_comb begin
    next_state = state;

    nAttempt = attempt;

    s_axis_next_tdata = s_axis_tdata;
    s_axis_tvalid = 'h0;

    m_axis_tready = 'h0;

    case (state)

        ST_IDLE:  begin
            m_axis_tready = 'h1;
            if (m_axis_tvalid) begin
                nAttempt = m_axis_tdata;
                next_state= ST_RUN;
             end
        end

        ST_RUN: begin
            if (count == 0) begin
                next_state= ST_BUFF;
            end
        end

        ST_BUFF: begin
            //s_axis_next_tdata = ~(attempt ^ SW[7:0]);
            s_axis_next_tdata = attempt;
            //nAttempt = 'h0; // uncommenting this line makes synthesis hang.
            next_state= ST_OUT;
        end

        ST_OUT:  begin
            s_axis_tvalid = 'h1;
            if (s_axis_tready)
              next_state= ST_IDLE;
        end

    endcase
end

endmodule

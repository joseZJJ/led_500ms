`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/17 15:28:40
// Design Name: 
// Module Name: led_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 500ms间隔闪烁的LED控制器，内部自产生复位
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module led_top(
    input wire clk,        // 时钟输入 50MHz
    output reg led         // LED输出
);

    // 内部复位信号生成
    reg [3:0] rst_counter = 4'd0; // 4位复位计数器，初始值为0
    reg rst_n = 1'b0;             // 内部复位信号，初始为复位状态
    
    // 计数器，用于计时500ms
    reg [24:0] counter = 25'd0;   // 25位计数器，可以计数到33,554,431
    
    // 时钟频率为50MHz（20ns周期），500ms需要25,000,000个时钟周期
    parameter COUNT_MAX = 25_000_000 - 1;  // 计数到24,999,999
    
    // 内部复位生成逻辑：上电后前16个时钟周期保持复位状态
    always @(posedge clk) begin
        if (rst_counter < 4'd15) begin
            rst_counter <= rst_counter + 1'b1;
            rst_n <= 1'b0;  // 复位有效
        end
        else begin
            rst_n <= 1'b1;  // 复位释放
            // rst_counter保持在15，不再递增
        end
    end
    
    // LED闪烁控制逻辑
    always @(posedge clk) begin
        if (!rst_n) begin
            counter <= 25'd0;
            led <= 1'b0;
        end
        else begin
            if (counter >= COUNT_MAX) begin
                counter <= 25'd0;
                led <= ~led;    // LED状态翻转
            end
            else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule

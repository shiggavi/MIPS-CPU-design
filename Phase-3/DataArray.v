//Data Array of 128 cache blocks with 8 words each
//BlockEnable and WordEnable are one-hot
//WriteEnable is one on writes and zero on reads

module DataArray(
input clk, 
input rst, 
input [15:0] DataIn, 
input Write, 
input [63:0] BlockEnable0, 
input [63:0] BlockEnable1, 
input offset, 
input [7:0] WordEnable, 
output [15:0] DataOut);
	
Block blk0[63:0]( .clk(clk), .rst(rst), .Din(DataIn), .WriteEnable(Write), .Enable(BlockEnable0), .WordEnable(WordEnable), .Dout(DataOut));
Block blk1[63:0]( .clk(clk), .rst(rst), .Din(DataIn), .WriteEnable(Write), .Enable(BlockEnable1), .WordEnable(WordEnable), .Dout(DataOut));

endmodule

//64 byte (8 word) cache block
module Block( 
input clk,  
input rst, 
input [15:0] Din, 
input WriteEnable, 
input Enable, 
input [7:0] WordEnable, 
output [15:0] Dout);
	
wire [7:0] WordEnable_real;
assign WordEnable_real = {8{Enable}} & WordEnable; //Enable specific word for the enabled cache block. 
	
DWord dw[7:0]( .clk(clk), .rst(rst), .Din(Din), .WriteEnable(WriteEnable), .Enable(WordEnable_real), .Dout(Dout));

endmodule


//Each word has 16 bits
module DWord( 
input clk,  
input rst, 
input [15:0] Din, 
input WriteEnable, 
input Enable, 
output [15:0] Dout);
	
DCell dc[15:0]( .clk(clk), .rst(rst), .Din(Din[15:0]), .WriteEnable(WriteEnable), .Enable(Enable), .Dout(Dout[15:0]));

endmodule


module DCell( 
input clk,  
input rst, 
input Din, 
input WriteEnable, 
input Enable, 
output Dout);
	
wire q;
assign Dout = (Enable & ~WriteEnable) ? q:'bz;
	
dff dffd(.q(q), .d(Din), .wen(Enable & WriteEnable), .clk(clk), .rst(rst));

endmodule

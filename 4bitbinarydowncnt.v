module tff (output reg q, input t,clk,rst);
always @ (posedge clk or posedge rst)
begin
 if(rst)
	q<=1'b0;
 else if(t)
	 q<=~q;
end
endmodule
module binary_4bit_downcnt(output [3:0]q,input clk,rst);
tff tff0 (q[0],1'b1,clk,rst);
tff tff1 (q[1],1'b1,q[0],rst);
tff tff2 (q[2],1'b1,q[1],rst);
tff tff3 (q[3],1'b1,q[2],rst);
endmodule

module router_top_tb();

reg clock,resetn,read_enb_0,read_enb_1,read_enb_2;
reg [7:0]data_in;
reg pkt_valid;
wire [7:0]data_out_0,data_out_1,data_out_2;
wire valid_out_0,valid_out_1,valid_out_2,error,busy;

router_top2 dut(clock,resetn,read_enb_0,read_enb_1,read_enb_2,data_in,pkt_valid,data_out_0,data_out_1,data_out_2,valid_out_0,valid_out_1,valid_out_2,error,busy);

always
begin
	
	clock = 1'b0;
	#5
	clock = ~clock;
	#5;
end

task rst;
	begin
		@(negedge clock)
		resetn =  1'b0;
		@(negedge clock)
		resetn = 1'b1;
	end
endtask
/*
task pkt_gen_length(input [5:0] length,input [1:0] addr);begin
	reg [7:0] payload_data,header,parity;
	integer i;
	header = {length,addr};
	parity = 96;
	@(negedge clock) data_in = header;
	for(i=0; i<legth)
	
end
endtask
*/
task pkt_gen_14;
		reg [7:0]payload_data,parity,header;
		reg [5:0]payload_len;
		reg [1:0]addr;
		begin
			@(negedge clock)
			wait(~busy)
			@(negedge clock)
			payload_len = 6'd16;
			addr = 2'b01;
			header = {payload_len,addr};
			parity = 0;
			data_in = header;
			pkt_valid = 1;
			parity = parity ^ header;
			@(negedge clock)
			//wait(~busy)
			for(i=0;i<payload_len;i=i+1)
			begin
				@(negedge clock)
				wait(~busy)
				payload_data = {$random}%256;
				data_in = payload_data;
				read_enb_1 = 1'b1;
				parity = parity^payload_data;
				
			//data_in = data_in;
				end
				@(negedge clock)
				wait(~busy)
				pkt_valid = 0;
				data_in = parity;
			end
	
endtask
integer i;

initial
begin
	rst;
	repeat(3)
	@(negedge clock);
	pkt_gen_14;
  @(negedge clock)
//	read_enb_0=1;
  //  read_enb_1=1;
//	read_enb_2=1;

 // wait(~valid_out_0)
	wait(~valid_out_1)
//	wait(~valid_out_2)
	@(negedge clock);
  //  read_enb_0=0;
	read_enb_1=0;
//	read_enb_2=0
end

endmodule








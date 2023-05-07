/*
multiplexer multiplexer_inst
(
	.clk		(),
	.reset_n	(),
		
	//one channel
	.avsi_one_channel	(),
	.avsi_one_data		(),
	.avsi_one_valid	(),
	.avsi_one_sop		(),
	.avsi_one_eop		(),
	.avsi_one_empty	(),
	.avsi_one_ready	(),
		
	//two channel
	.avsi_two_channel	(),
	.avsi_two_data		(),
	.avsi_two_valid	(),
	.avsi_two_sop		(),
	.avsi_two_eop		(),
	.avsi_two_empty	(),
	.avsi_two_ready	(),
		
		
	//output 
	.avso_channel	(),
	.avso_data		(),
	.avso_valid		(),
	.avso_sop		(),
	.avso_eop		(),
	.avso_empty		(),
	.avso_ready		()
		

);

defparam multiplexer_inst.data_width = 32;
defparam multiplexer_inst.empty_width = 2;
defparam multiplexer_inst.channel_width = 1;

*/
module multiplexer
#
(
	parameter data_width = 128,
	parameter empty_width = 2,
	parameter channel_width = 1,
	parameter bit enable_output_register = 1
)
(
	input clk,
	input reset_n,
	
	//one channel
	input 	logic [channel_width-1:0] 	avsi_one_channel,
	input 	logic [data_width-1:0] 		avsi_one_data,
	input 	logic 						avsi_one_valid,
	input 	logic 						avsi_one_sop,
	input 	logic 						avsi_one_eop,
	input 	logic [empty_width-1:0]		avsi_one_empty,
	output 	logic 						avsi_one_ready,
	
	//two channel
	input 	logic [channel_width-1:0] 	avsi_two_channel,
	input 	logic [data_width-1:0] 		avsi_two_data,
	input 	logic 						avsi_two_valid,
	input 	logic 						avsi_two_sop,
	input 	logic 						avsi_two_eop,
	input 	logic [empty_width-1:0]		avsi_two_empty,
	output 	logic 						avsi_two_ready,
	
	
	//output 
	output 	logic [channel_width-1:0] 	avso_channel,
	output 	logic [data_width-1:0] 		avso_data,
	output 	logic 						avso_valid,
	output 	logic 						avso_sop,
	output 	logic 						avso_eop,
	output 	logic [empty_width-1:0]		avso_empty,
	input 	logic 						avso_ready
	

);



typedef struct packed 
{
	logic [channel_width-1:0]	channel;
	logic [data_width-1:0] 		data;
	logic 						valid;
	logic 						sop;
	logic 						eop;
	logic[empty_width-1:0]		empty;
} stream;



stream [1:0] stream_one, stream_two;

enum logic [1:0] {idle, send_one, send_two} state, state_next;

/***************************************************************************************************************************/
/***************************************************************************************************************************/
/******************************************								   *************************************************/
/******************************************								   *************************************************/
/******************************************				Channel one		   *************************************************/
/******************************************								   *************************************************/
/******************************************								   *************************************************/
/***************************************************************************************************************************/
/***************************************************************************************************************************/

always_comb begin
	stream_one[0].channel 	= avsi_one_channel;
	stream_one[0].data 		= avsi_one_data;
	stream_one[0].valid 	= avsi_one_valid;
	stream_one[0].sop 		= avsi_one_sop;
	stream_one[0].eop 		= avsi_one_eop;
	stream_one[0].empty 	= avsi_one_empty;
end


always_ff @ (posedge clk or negedge reset_n)
	if(!reset_n) stream_one[1].valid <= 1'b0;
	else 	if(avsi_one_ready) stream_one[1].valid <= stream_one[0].valid;

always_ff @ (posedge clk)
	if(avsi_one_ready) begin
		stream_one[1].channel 	<= stream_one[0].channel;
		stream_one[1].data 		<= stream_one[0].data;
		stream_one[1].sop 		<= stream_one[0].sop;
		stream_one[1].eop 		<= stream_one[0].eop;
		stream_one[1].empty 	<= stream_one[0].empty;
	end

/***************************************************************************************************************************/
/***************************************************************************************************************************/
/******************************************								   *************************************************/
/******************************************								   *************************************************/
/******************************************				Channel two		   *************************************************/
/******************************************								   *************************************************/
/******************************************								   *************************************************/
/***************************************************************************************************************************/
/***************************************************************************************************************************/


always_comb begin
	stream_two[0].channel 	= avsi_two_channel;
	stream_two[0].data 		= avsi_two_data;
	stream_two[0].valid 	= avsi_two_valid;
	stream_two[0].sop 		= avsi_two_sop;
	stream_two[0].eop 		= avsi_two_eop;
	stream_two[0].empty 	= avsi_two_empty;
end


always_ff @ (posedge clk or negedge reset_n)
	if(!reset_n) stream_two[1].valid <= 1'b0;
	else if(avsi_two_ready) stream_two[1].valid <= stream_two[0].valid;

always_ff @ (posedge clk)
	if(avsi_two_ready) begin
		stream_two[1].channel 	<= stream_two[0].channel;
		stream_two[1].data 		<= stream_two[0].data;
		stream_two[1].sop 		<= stream_two[0].sop;
		stream_two[1].eop 		<= stream_two[0].eop;
		stream_two[1].empty 	<= stream_two[0].empty;
	end



/***************************************************************************************************************************/
/***************************************************************************************************************************/
/******************************************								   *************************************************/
/******************************************								   *************************************************/
/******************************************				FSM				   *************************************************/
/******************************************								   *************************************************/
/******************************************								   *************************************************/
/***************************************************************************************************************************/
/***************************************************************************************************************************/

always_ff @ (posedge clk or negedge reset_n)
	if(!reset_n) state <= idle;
	else state <= state_next;
		
		
always_comb
	case(state)
		idle:		if(stream_one[1].valid && stream_one[1].sop) state_next = send_one;
					else if(stream_two[1].valid && stream_two[1].sop) state_next = send_two;
					else state_next = idle;
		
		send_one:	if(stream_one[1].valid && stream_one[1].eop && avsi_one_ready)
						if(stream_two[1].valid && stream_two[1].sop) state_next = send_two;
						else if(stream_one[0].valid && stream_one[0].sop) state_next = send_one;
						else state_next = idle;
					else state_next = send_one;
		
		send_two:	if(stream_two[1].valid && stream_two[1].eop && avsi_two_ready)
						if(stream_one[1].valid && stream_one[1].sop) state_next = send_one;
						else if(stream_two[0].valid && stream_two[0].sop) state_next = send_two;
						else state_next = idle;
					else state_next = send_two;
		
		default:	state_next = idle;
	endcase 




	
always_comb
	case(state)
		idle: begin 
			avsi_one_ready = ~(stream_one[1].valid & stream_one[1].sop);
			avsi_two_ready = ~(stream_two[1].valid & stream_two[1].sop);
		end
				
		send_one: begin 
			avsi_one_ready = avso_ready;
			avsi_two_ready = ~(stream_two[1].valid & stream_two[1].sop);
		end 
	
	
		send_two: begin 
			avsi_one_ready = ~(stream_one[1].valid & stream_one[1].sop);
			avsi_two_ready = avso_ready;		
		end 
		
		default: begin 
			avsi_one_ready = 1'b0;
			avsi_two_ready = 1'b0;
		end 
	endcase 
	
	
	
	
	
/***************************************************************************************************************************/
/***************************************************************************************************************************/
/******************************************								   *************************************************/
/******************************************								   *************************************************/
/******************************************				Output			   *************************************************/
/******************************************								   *************************************************/
/******************************************								   *************************************************/
/***************************************************************************************************************************/
/***************************************************************************************************************************/

generate
	if(enable_output_register) begin:gen_output_register
		always_ff @ (posedge clk or negedge reset_n)
		if(!reset_n) avso_valid <= 1'b0;
		else 	if(avso_ready) begin 
					avso_valid <= 1'b0;

					case(state)
						send_one:	avso_valid 	<= stream_one[1].valid;
						send_two:	avso_valid 	<= stream_two[1].valid;	
						default:	avso_valid 	<= 1'b0;
					endcase 
				end 
	
	
		always_ff @ (posedge clk)
			if(avso_ready) begin
				avso_channel 	<= {channel_width{1'b0}};
				avso_data 		<= {data_width{1'b0}};
				avso_sop 		<= 1'b0;
				avso_eop 		<= 1'b0;
				avso_empty 		<= {empty_width{1'b0}};

				case(state)
					send_one:	begin
						avso_channel 	<= stream_one[1].channel;
						avso_data 		<= stream_one[1].data;
						avso_sop 		<= stream_one[1].sop;
						avso_eop 		<= stream_one[1].eop;
						avso_empty 		<= stream_one[1].empty;
					end
									
					send_two:	begin 
						avso_channel 	<= stream_two[1].channel;
						avso_data 		<= stream_two[1].data;
						avso_sop 		<= stream_two[1].sop;
						avso_eop 		<= stream_two[1].eop;
						avso_empty 		<= stream_two[1].empty;
					end
									
					default:	begin 
						avso_channel 	<= {channel_width{1'b0}};
						avso_data 		<= {data_width{1'b0}};
						avso_sop 		<= 1'b0;
						avso_eop 		<= 1'b0;
						avso_empty 		<= {empty_width{1'b0}};
					end 
				endcase 
			end 
	end//if(enable_output_register)
	else begin
		always_comb begin
			avso_channel 	= {channel_width{1'b0}};
			avso_data 		= {data_width{1'b0}};
			avso_valid 		= 1'b0;
			avso_sop 		= 1'b0;
			avso_eop 		= 1'b0;
			avso_empty 		= {empty_width{1'b0}};

			case(state)
				send_one:	begin
					avso_channel 	= stream_one[1].channel;
					avso_data 		= stream_one[1].data;
					avso_valid 		= stream_one[1].valid;
					avso_sop 		= stream_one[1].sop;
					avso_eop 		= stream_one[1].eop;
					avso_empty 		= stream_one[1].empty;
				end
								
				send_two:	begin 
					avso_channel 	= stream_two[1].channel;
					avso_data 		= stream_two[1].data;
					avso_valid 		= stream_two[1].valid;
					avso_sop 		= stream_two[1].sop;
					avso_eop 		= stream_two[1].eop;
					avso_empty 		= stream_two[1].empty;
				end
								
				default:	begin 
					avso_channel 	= {channel_width{1'b0}};
					avso_data 		= {data_width{1'b0}};
					avso_valid 		= 1'b0;
					avso_sop 		= 1'b0;
					avso_eop 		= 1'b0;
					avso_empty 		= {empty_width{1'b0}};
				end 
			endcase 
		end
	end//else
endgenerate




endmodule 
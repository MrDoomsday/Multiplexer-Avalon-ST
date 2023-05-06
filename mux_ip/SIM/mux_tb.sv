module mux_tb();

localparam channel_width = 10;
localparam data_width = 128;
localparam empty_width = $clog2(data_width/8);

/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/
/******************************************************                      *****************************************************************/
/******************************************************                      *****************************************************************/
/******************************************************      INTERFACE       *****************************************************************/
/******************************************************                      *****************************************************************/
/******************************************************                      *****************************************************************/
/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/
	reg clk;
	reg reset_n;
	
	//one channel
	reg [channel_width-1:0] 	avsi_one_channel;
	reg [data_width-1:0] 		avsi_one_data;
	reg 						avsi_one_valid;
	reg 						avsi_one_sop;
	reg 						avsi_one_eop;
	reg [empty_width-1:0]		avsi_one_empty;
	wire 						avsi_one_ready;
	
	//two channel
	reg [channel_width-1:0] 	avsi_two_channel;
	reg [data_width-1:0] 		avsi_two_data;
	reg 						avsi_two_valid;
	reg 						avsi_two_sop;
	reg 						avsi_two_eop;
	reg [empty_width-1:0]		avsi_two_empty;
	wire 						avsi_two_ready;
	
	
	//output 
	wire [channel_width-1:0] 	avso_channel;
	wire [data_width-1:0] 		avso_data;
	wire 						avso_valid;
	wire 						avso_sop;
	wire 						avso_eop;
	wire [empty_width-1:0]		avso_empty;
	reg 						avso_ready;

/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/
/******************************************************                      *****************************************************************/
/******************************************************                      *****************************************************************/
/******************************************************      INSTANCE        *****************************************************************/
/******************************************************                      *****************************************************************/
/******************************************************                      *****************************************************************/
/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/
    multiplexer DUT
    (
        .clk		(clk),
        .reset_n	(reset_n),
            
        //one channel
        .avsi_one_channel	(avsi_one_channel),
        .avsi_one_data		(avsi_one_data),
        .avsi_one_valid	    (avsi_one_valid),
        .avsi_one_sop		(avsi_one_sop),
        .avsi_one_eop		(avsi_one_eop),
        .avsi_one_empty	    (avsi_one_empty),
        .avsi_one_ready	    (avsi_one_ready),
            
        //two channel
        .avsi_two_channel	(avsi_two_channel),
        .avsi_two_data		(avsi_two_data),
        .avsi_two_valid	    (avsi_two_valid),
        .avsi_two_sop		(avsi_two_sop),
        .avsi_two_eop		(avsi_two_eop),
        .avsi_two_empty	    (avsi_two_empty),
        .avsi_two_ready	    (avsi_two_ready),
            
            
        //output 
        .avso_channel	(avso_channel),
        .avso_data		(avso_data),
        .avso_valid		(avso_valid),
        .avso_sop		(avso_sop),
        .avso_eop		(avso_eop),
        .avso_empty		(avso_empty),
        .avso_ready		(avso_ready)
    );

    defparam DUT.data_width = data_width;
    defparam DUT.empty_width = empty_width;
    defparam DUT.channel_width = channel_width;



/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/
/******************************************************                      *****************************************************************/
/******************************************************                      *****************************************************************/
/******************************************************         TEST         *****************************************************************/
/******************************************************                      *****************************************************************/
/******************************************************                      *****************************************************************/
/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/

always begin
    clk = 1'b0;
    #10;
    clk = 1'b1;
    #10;
end




endmodule
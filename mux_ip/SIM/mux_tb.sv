interface avalon_st #(parameter int channel_width, parameter int data_width, parameter int empty_width);
	logic [channel_width-1:0] 	channel;
	logic [data_width-1:0] 		data;
	logic 						valid;
	logic 						sop;
	logic 						eop;
	logic [empty_width-1:0]		empty;
	logic 						ready;

    modport source (
        output channel,
        output data,
        output valid,
        output sop,
        output eop,
        output empty,
        input ready
    );

    modport sink (
        input channel,
        input data,
        input valid,
        input sop,
        input eop,
        input empty,
        output ready
    );
endinterface


module mux_tb();

localparam channel_width = 8;
localparam data_width = 32;
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


    avalon_st #(
        .channel_width(channel_width),
        .data_width(data_width),
        .empty_width(empty_width)
    ) Ch1_i(), Ch2_i(), Ch_o();//channel 1 input, channel 2 input, channel output

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
        .avsi_one_channel	(Ch1_i.sink.channel),
        .avsi_one_data		(Ch1_i.sink.data),
        .avsi_one_valid	    (Ch1_i.sink.valid),
        .avsi_one_sop		(Ch1_i.sink.sop),
        .avsi_one_eop		(Ch1_i.sink.eop),
        .avsi_one_empty	    (Ch1_i.sink.empty),
        .avsi_one_ready	    (Ch1_i.sink.ready),
            
        //two channel
        .avsi_two_channel	(Ch2_i.sink.channel),
        .avsi_two_data		(Ch2_i.sink.data),
        .avsi_two_valid	    (Ch2_i.sink.valid),
        .avsi_two_sop		(Ch2_i.sink.sop),
        .avsi_two_eop		(Ch2_i.sink.eop),
        .avsi_two_empty	    (Ch2_i.sink.empty),
        .avsi_two_ready	    (Ch2_i.sink.ready),
            
            
        //output 
        .avso_channel	(Ch_o.source.channel),
        .avso_data		(Ch_o.source.data),
        .avso_valid		(Ch_o.source.valid),
        .avso_sop		(Ch_o.source.sop),
        .avso_eop		(Ch_o.source.eop),
        .avso_empty		(Ch_o.source.empty),
        .avso_ready		(Ch_o.source.ready)
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

int length_transaction_1, length_transaction_2;
int counter_packet;

initial begin
    reset_n = 1'b0;
    repeat(10) @ (posedge clk);
    reset_n = 1'b1;
    repeat(10) @ (posedge clk);

    wait(counter_packet == 1000);
    
    $display("Test PASSED");
    $stop();
end

//generate traffic channel one
initial begin
    Ch1_i.sink.channel = {channel_width{1'b0}};
    Ch1_i.sink.data = {data_width{1'b0}};
    Ch1_i.sink.valid = 1'b0;
    Ch1_i.sink.sop = 1'b0;
    Ch1_i.sink.eop = 1'b0;
    Ch1_i.sink.empty = {empty_width{1'b0}};
    wait(reset_n == 1'b1);
    @(posedge clk);

    forever begin
        length_transaction_1 = $urandom_range(1,1000);
        for (int i = 0; i < length_transaction_1; i++) begin
            Ch1_i.sink.data = $urandom();
            Ch1_i.sink.valid = $urandom_range(0,1);

            if(i == 0) begin 
                Ch1_i.sink.channel = $urandom_range(0,2**(channel_width-1)-1);
                Ch1_i.sink.sop = 1'b1;
                Ch1_i.sink.valid = 1'b1;
            end 
            else begin
                Ch1_i.sink.sop = 1'b0;
            end

            if(i == length_transaction_1 - 1) begin 
                Ch1_i.sink.eop = 1'b1;
                Ch1_i.sink.empty = {empty_width{1'b0}};
                Ch1_i.sink.valid = 1'b1;
            end
            #2;
            @(posedge clk);
            while(Ch1_i.sink.ready == 1'b0) @(posedge clk);
        end
        $display("Channel 1 packet generate, len = %0d", length_transaction_1);
        Ch1_i.sink.channel = {channel_width{1'b0}};
        Ch1_i.sink.data = {data_width{1'b0}};
        Ch1_i.sink.valid = 1'b0;
        Ch1_i.sink.sop = 1'b0;
        Ch1_i.sink.eop = 1'b0;
        Ch1_i.sink.empty = {empty_width{1'b0}};
    end
end


//generate traffic channel two
initial begin
    Ch2_i.sink.channel = {channel_width{1'b0}};
    Ch2_i.sink.data = {data_width{1'b0}};
    Ch2_i.sink.valid = 1'b0;
    Ch2_i.sink.sop = 1'b0;
    Ch2_i.sink.eop = 1'b0;
    Ch2_i.sink.empty = {empty_width{1'b0}};
    wait(reset_n == 1'b1);
    @(posedge clk);

    forever begin
        length_transaction_2 = $urandom_range(1,10);
        for (int j = 0; j < length_transaction_2; j++) begin
            Ch2_i.sink.data = $urandom();
            Ch2_i.sink.valid = $urandom_range(0,1);

            if(j == 0) begin 
                Ch2_i.sink.channel = $urandom_range(2**(channel_width-1), 2**channel_width-1);
                Ch2_i.sink.sop = 1'b1;
                Ch2_i.sink.valid = 1'b1;
            end 
            else begin
                Ch2_i.sink.sop = 1'b0;
            end

            if(j == length_transaction_2 - 1) begin 
                Ch2_i.sink.eop = 1'b1;
                Ch2_i.sink.empty = {empty_width{1'b0}};
                Ch2_i.sink.valid = 1'b1;
            end
            #2;
            @(posedge clk);
            while(Ch2_i.sink.ready == 1'b0) @(posedge clk);
        end
        $display("Channel 2 packet generate, len = %0d", length_transaction_2);
        Ch2_i.sink.channel = {channel_width{1'b0}};
        Ch2_i.sink.data = {data_width{1'b0}};
        Ch2_i.sink.valid = 1'b0;
        Ch2_i.sink.sop = 1'b0;
        Ch2_i.sink.eop = 1'b0;
        Ch2_i.sink.empty = {empty_width{1'b0}};
    end
end




//check traffic
    initial begin//generate random ready signal
        Ch_o.source.ready = 1'b0;
        wait(reset_n == 1'b1);

        forever begin
            for(int i = 0; i < $urandom_range(1,10); i++) begin
                Ch_o.source.ready = 1'b0;
                @(posedge clk);
            end
            Ch_o.source.ready = 1'b1;
            @(posedge clk);
        end
    end


    typedef struct packed {
        logic [data_width-1:0] 		data;
        logic 						sop;
        logic 						eop;
        logic [empty_width-1:0]		empty;
    } avalon_item;

    avalon_item transaction_queue [2**channel_width][$];
    avalon_item current_transaction [1:2];
    avalon_item output_transaction;


    //add element in queue
    always_ff @ (posedge clk) begin
        //write for always different channel (see generate traffic up)
        if(Ch1_i.sink.valid && Ch1_i.sink.ready) begin
            current_transaction[1].data = Ch1_i.sink.data;
            current_transaction[1].sop = Ch1_i.sink.sop;
            current_transaction[1].eop = Ch1_i.sink.eop;
            current_transaction[1].empty = Ch1_i.sink.empty;
            transaction_queue[Ch1_i.sink.channel].push_back(current_transaction[1]);
        end

        if(Ch2_i.sink.valid && Ch2_i.sink.ready) begin
            current_transaction[2].data = Ch2_i.sink.data;
            current_transaction[2].sop = Ch2_i.sink.sop;
            current_transaction[2].eop = Ch2_i.sink.eop;
            current_transaction[2].empty = Ch2_i.sink.empty;
            transaction_queue[Ch2_i.sink.channel].push_back(current_transaction[2]);
        end
    end

    //check output 
    always_ff @ (negedge clk) begin
        if(Ch_o.source.valid && Ch_o.source.ready) begin
            output_transaction = transaction_queue[Ch_o.source.channel].pop_front();
            if(Ch_o.source.data != output_transaction.data) begin
                $display("DATA FAILED. Channel = %0d; Receive from MUX = %0x; Data wait %0x", Ch_o.source.channel, Ch_o.source.data, output_transaction.data);
                $stop();
            end

            if(Ch_o.source.sop != output_transaction.sop) begin
                $display("SOP FAILED. Channel = %0d; Receive from MUX = %0x; Sop wait %0x", Ch_o.source.channel, Ch_o.source.sop, output_transaction.sop);
                $stop();
            end

            if(Ch_o.source.eop != output_transaction.eop) begin
                $display("EOP FAILED. Channel = %0d; Receive from MUX = %0x; Eop wait %0x", Ch_o.source.channel, Ch_o.source.eop, output_transaction.eop);
                $stop();
            end

            if(Ch_o.source.eop && (Ch_o.source.empty != output_transaction.empty)) begin
                $display("Empty FAILED. Channel = %0d; Receive from MUX = %0x; Empty wait %0x", Ch_o.source.channel, Ch_o.source.empty, output_transaction.empty);
                $stop();
            end

            if(Ch_o.source.eop) begin
                $display("Packet for channel %0d receive", Ch_o.source.channel);
            end
        end
    end

    always_ff @ (posedge clk or negedge reset_n)
        if(!reset_n) counter_packet <= 'h0;
        else if(Ch_o.source.eop && Ch_o.source.valid && Ch_o.source.ready) counter_packet++;

endmodule
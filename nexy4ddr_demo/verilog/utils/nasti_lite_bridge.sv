// See LICENSE for license details.

// bridge for NASTI/NASTI-Lite conversion

module nasti_lite_bridge
  #(
    MAX_TRANSACTION = 1,      // maximal number of parallel write transactions
    ID_WIDTH = 1,               // id width
    ADDR_WIDTH = 12,             // address width
    NASTI_DATA_WIDTH = 64,      // width of data on the nasti side
    LITE_DATA_WIDTH = 32,       // width of data on the nasti-lite side
    USER_WIDTH = 1              // width of user field, must > 0, let synthesizer trim it if not in use
    )
   (
    input clk, rstn,

    input  [ID_WIDTH-1:0]           nasti_master_ar_id,
    input  [ADDR_WIDTH-1:0]         nasti_master_ar_addr,
    input  [7:0]                    nasti_master_ar_len,
    input  [2:0]                    nasti_master_ar_size,
    input  [1:0]                    nasti_master_ar_burst,
    input                           nasti_master_ar_lock,
    input  [3:0]                    nasti_master_ar_cache,
    input  [2:0]                    nasti_master_ar_prot,
    input  [3:0]                    nasti_master_ar_qos,
    input  [3:0]                    nasti_master_ar_region,
    input  [USER_WIDTH-1:0]         nasti_master_ar_user,
    input                           nasti_master_ar_valid,
    output                          nasti_master_ar_ready,
    output [ID_WIDTH-1:0]           nasti_master_r_id,
    output [NASTI_DATA_WIDTH-1:0]   nasti_master_r_data,
    output [1:0]                    nasti_master_r_resp,
    output                          nasti_master_r_last,
    output [USER_WIDTH-1:0]         nasti_master_r_user,
    output                          nasti_master_r_valid,
    input                           nasti_master_r_ready,
    input  [ID_WIDTH-1:0]           nasti_master_aw_id,
    input  [ADDR_WIDTH-1:0]         nasti_master_aw_addr,
    input  [7:0]                    nasti_master_aw_len,
    input  [2:0]                    nasti_master_aw_size,
    input  [1:0]                    nasti_master_aw_burst,
    input                           nasti_master_aw_lock,
    input  [3:0]                    nasti_master_aw_cache,
    input  [2:0]                    nasti_master_aw_prot,
    input  [3:0]                    nasti_master_aw_qos,
    input  [3:0]                    nasti_master_aw_region,
    input  [USER_WIDTH-1:0]         nasti_master_aw_user,
    input                           nasti_master_aw_valid,
    output                          nasti_master_aw_ready,
    input  [NASTI_DATA_WIDTH-1:0]   nasti_master_w_data,
    input  [NASTI_DATA_WIDTH/8-1:0] nasti_master_w_strb,
    input                           nasti_master_w_last,
    input  [USER_WIDTH-1:0]         nasti_master_w_user,
    input                           nasti_master_w_valid,
    output                          nasti_master_w_ready,
    output [ID_WIDTH-1:0]           nasti_master_b_id,
    output [1:0]                    nasti_master_b_resp,
    output [USER_WIDTH-1:0]         nasti_master_b_user,
    output                          nasti_master_b_valid,
    input                           nasti_master_b_ready,

    output [ID_WIDTH-1:0]           lite_slave_ar_id,
    output [ADDR_WIDTH-1:0]         lite_slave_ar_addr,
    output [2:0]                    lite_slave_ar_prot,
    output [3:0]                    lite_slave_ar_qos,
    output [3:0]                    lite_slave_ar_region,
    output [USER_WIDTH-1:0]         lite_slave_ar_user,
    output                          lite_slave_ar_valid,
    input                           lite_slave_ar_ready,
    input  [ID_WIDTH-1:0]           lite_slave_r_id,
    input  [LITE_DATA_WIDTH-1:0]    lite_slave_r_data,
    input  [1:0]                    lite_slave_r_resp,
    input  [USER_WIDTH-1:0]         lite_slave_r_user,
    input                           lite_slave_r_valid,
    output                          lite_slave_r_ready,
    output [ID_WIDTH-1:0]           lite_slave_aw_id,
    output [ADDR_WIDTH-1:0]         lite_slave_aw_addr,
    output [2:0]                    lite_slave_aw_prot,
    output [3:0]                    lite_slave_aw_qos,
    output [3:0]                    lite_slave_aw_region,
    output [USER_WIDTH-1:0]         lite_slave_aw_user,
    output                          lite_slave_aw_valid,
    input                           lite_slave_aw_ready,
    output [LITE_DATA_WIDTH-1:0]    lite_slave_w_data,
    output [LITE_DATA_WIDTH/8-1:0]  lite_slave_w_strb,
    output [USER_WIDTH-1:0]         lite_slave_w_user,
    output                          lite_slave_w_valid,
    input                           lite_slave_w_ready,
    input  [ID_WIDTH-1:0]           lite_slave_b_id,
    input  [1:0]                    lite_slave_b_resp,
    input  [USER_WIDTH-1:0]         lite_slave_b_user,
    input                           lite_slave_b_valid,
    output                          lite_slave_b_ready

    );

   nasti_lite_writer
     #(
       .MAX_TRANSACTION  ( MAX_TRANSACTION    ),
       .ID_WIDTH         ( ID_WIDTH           ),
       .ADDR_WIDTH       ( ADDR_WIDTH         ),
       .NASTI_DATA_WIDTH ( NASTI_DATA_WIDTH   ),
       .LITE_DATA_WIDTH  ( LITE_DATA_WIDTH    ),
       .USER_WIDTH       ( USER_WIDTH         )
       )
   writer
     (
      .*,
      .nasti_aw_id     ( nasti_master_aw_id     ),
      .nasti_aw_addr   ( nasti_master_aw_addr   ),
      .nasti_aw_len    ( nasti_master_aw_len    ),
      .nasti_aw_size   ( nasti_master_aw_size   ),
      .nasti_aw_burst  ( nasti_master_aw_burst  ),
      .nasti_aw_lock   ( nasti_master_aw_lock   ),
      .nasti_aw_cache  ( nasti_master_aw_cache  ),
      .nasti_aw_prot   ( nasti_master_aw_prot   ),
      .nasti_aw_qos    ( nasti_master_aw_qos    ),
      .nasti_aw_region ( nasti_master_aw_region ),
      .nasti_aw_user   ( nasti_master_aw_user   ),
      .nasti_aw_valid  ( nasti_master_aw_valid  ),
      .nasti_aw_ready  ( nasti_master_aw_ready  ),
      .nasti_w_data    ( nasti_master_w_data    ),
      .nasti_w_strb    ( nasti_master_w_strb    ),
      .nasti_w_last    ( nasti_master_w_last    ),
      .nasti_w_user    ( nasti_master_w_user    ),
      .nasti_w_valid   ( nasti_master_w_valid   ),
      .nasti_w_ready   ( nasti_master_w_ready   ),
      .nasti_b_id      ( nasti_master_b_id      ),
      .nasti_b_resp    ( nasti_master_b_resp    ),
      .nasti_b_user    ( nasti_master_b_user    ),
      .nasti_b_valid   ( nasti_master_b_valid   ),
      .nasti_b_ready   ( nasti_master_b_ready   ),
      .lite_aw_id      ( lite_slave_aw_id      ),
      .lite_aw_addr    ( lite_slave_aw_addr    ),
      .lite_aw_prot    ( lite_slave_aw_prot    ),
      .lite_aw_qos     ( lite_slave_aw_qos     ),
      .lite_aw_region  ( lite_slave_aw_region  ),
      .lite_aw_user    ( lite_slave_aw_user    ),
      .lite_aw_valid   ( lite_slave_aw_valid   ),
      .lite_aw_ready   ( lite_slave_aw_ready   ),
      .lite_w_data     ( lite_slave_w_data     ),
      .lite_w_strb     ( lite_slave_w_strb     ),
      .lite_w_user     ( lite_slave_w_user     ),
      .lite_w_valid    ( lite_slave_w_valid    ),
      .lite_w_ready    ( lite_slave_w_ready    ),
      .lite_b_id       ( lite_slave_b_id       ),
      .lite_b_resp     ( lite_slave_b_resp     ),
      .lite_b_user     ( lite_slave_b_user     ),
      .lite_b_valid    ( lite_slave_b_valid    ),
      .lite_b_ready    ( lite_slave_b_ready    )
      );

   nasti_lite_reader
     #(
       .MAX_TRANSACTION  ( MAX_TRANSACTION   ),
       .ID_WIDTH         ( ID_WIDTH           ),
       .ADDR_WIDTH       ( ADDR_WIDTH         ),
       .NASTI_DATA_WIDTH ( NASTI_DATA_WIDTH   ),
       .LITE_DATA_WIDTH  ( LITE_DATA_WIDTH    ),
       .USER_WIDTH       ( USER_WIDTH         )
       )
   reader
     (
      .*,
      .nasti_ar_id     ( nasti_master_ar_id     ),
      .nasti_ar_addr   ( nasti_master_ar_addr   ),
      .nasti_ar_len    ( nasti_master_ar_len    ),
      .nasti_ar_size   ( nasti_master_ar_size   ),
      .nasti_ar_burst  ( nasti_master_ar_burst  ),
      .nasti_ar_lock   ( nasti_master_ar_lock   ),
      .nasti_ar_cache  ( nasti_master_ar_cache  ),
      .nasti_ar_prot   ( nasti_master_ar_prot   ),
      .nasti_ar_qos    ( nasti_master_ar_qos    ),
      .nasti_ar_region ( nasti_master_ar_region ),
      .nasti_ar_user   ( nasti_master_ar_user   ),
      .nasti_ar_valid  ( nasti_master_ar_valid  ),
      .nasti_ar_ready  ( nasti_master_ar_ready  ),
      .nasti_r_id      ( nasti_master_r_id      ),
      .nasti_r_data    ( nasti_master_r_data    ),
      .nasti_r_resp    ( nasti_master_r_resp    ),
      .nasti_r_last    ( nasti_master_r_last    ),
      .nasti_r_user    ( nasti_master_r_user    ),
      .nasti_r_valid   ( nasti_master_r_valid   ),
      .nasti_r_ready   ( nasti_master_r_ready   ),
      .lite_ar_id      ( lite_slave_ar_id       ),
      .lite_ar_addr    ( lite_slave_ar_addr     ),
      .lite_ar_prot    ( lite_slave_ar_prot     ),
      .lite_ar_qos     ( lite_slave_ar_qos      ),
      .lite_ar_region  ( lite_slave_ar_region   ),
      .lite_ar_user    ( lite_slave_ar_user     ),
      .lite_ar_valid   ( lite_slave_ar_valid    ),
      .lite_ar_ready   ( lite_slave_ar_ready    ),
      .lite_r_id       ( lite_slave_r_id        ),
      .lite_r_data     ( lite_slave_r_data      ),
      .lite_r_resp     ( lite_slave_r_resp      ),
      .lite_r_user     ( lite_slave_r_user      ),
      .lite_r_valid    ( lite_slave_r_valid     ),
      .lite_r_ready    ( lite_slave_r_ready     )
      );

endmodule // nasti_lite_bridge

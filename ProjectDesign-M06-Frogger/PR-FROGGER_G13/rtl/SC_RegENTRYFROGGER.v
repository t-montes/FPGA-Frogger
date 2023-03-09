//=======================================================
//  MODULE Definition
//=======================================================
module SC_RegENTRYFROGGER #(parameter RegENTRYFROGGER_DATAWIDTH=8,
									 parameter DATA_CLEARENTRYFROGGER   =8'b00000000,
									 parameter DATA_FIXED_REGENTRY_NONE =8'b11011011,
									 parameter DATA_FIXED_REGENTRY_LEFT =8'b11111011,
									 parameter DATA_FIXED_REGENTRY_RIGHT=8'b11011111)(
	//////////// OUTPUTS //////////
	SC_RegENTRYFROGGER_data_OutBUS,
	
	//////////// INPUTS //////////
	SC_RegENTRYFROGGER_CLOCK_50,
	SC_RegENTRYFROGGER_RESET_InHigh,
	SC_RegENTRYFROGGER_loadEntry_In
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output [RegENTRYFROGGER_DATAWIDTH-1:0] SC_RegENTRYFROGGER_data_OutBUS;
input		SC_RegENTRYFROGGER_CLOCK_50;
input		SC_RegENTRYFROGGER_RESET_InHigh;
input		[1:0] SC_RegENTRYFROGGER_loadEntry_In;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [RegENTRYFROGGER_DATAWIDTH-1:0] RegENTRYFROGGER_Register;
reg [RegENTRYFROGGER_DATAWIDTH-1:0] RegENTRYFROGGER_Signal;
//=======================================================
//  Structural coding
//=======================================================

always @(*)
begin
	if (SC_RegENTRYFROGGER_loadEntry_In == 2'b00) 
		RegENTRYFROGGER_Signal = DATA_FIXED_REGENTRY_NONE;
	else if (SC_RegENTRYFROGGER_loadEntry_In == 2'b01)
		RegENTRYFROGGER_Signal = DATA_FIXED_REGENTRY_RIGHT;
	else if (SC_RegENTRYFROGGER_loadEntry_In == 2'b10)
		RegENTRYFROGGER_Signal = DATA_FIXED_REGENTRY_LEFT;
	else if (SC_RegENTRYFROGGER_loadEntry_In == 2'b11)
		RegENTRYFROGGER_Signal = DATA_CLEARENTRYFROGGER;
	else
		RegENTRYFROGGER_Signal = RegENTRYFROGGER_Register;
end

always @(posedge SC_RegENTRYFROGGER_CLOCK_50, posedge SC_RegENTRYFROGGER_RESET_InHigh)
begin
	if (SC_RegENTRYFROGGER_RESET_InHigh == 1'b1)
		RegENTRYFROGGER_Register <= 0;
	else
		RegENTRYFROGGER_Register <= RegENTRYFROGGER_Signal;
end
//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign SC_RegENTRYFROGGER_data_OutBUS = RegENTRYFROGGER_Register;

endmodule


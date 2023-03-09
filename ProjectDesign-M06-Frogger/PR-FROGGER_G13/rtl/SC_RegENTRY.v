//=======================================================
//  MODULE Definition
//=======================================================
module SC_RegENTRY (
	//////////// OUTPUTS //////////
	SC_RegENTRY_numEntry_Out,
	SC_RegENTRY_chgEntry_OutLow,
	//////////// INPUTS //////////
	SC_RegENTRY_CLOCK_50,
	SC_RegENTRY_RESET_InHigh,
	SC_RegENTRY_enterLeft_InLow,
	SC_RegENTRY_enterRight_InLow
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output 	[1:0] SC_RegENTRY_numEntry_Out;
output reg	SC_RegENTRY_chgEntry_OutLow;
input		SC_RegENTRY_CLOCK_50;
input		SC_RegENTRY_RESET_InHigh;
input		SC_RegENTRY_enterLeft_InLow;
input		SC_RegENTRY_enterRight_InLow;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [1:0] RegENTRY_Register;
reg [1:0] RegENTRY_Signal;

//=======================================================
//  Structural coding
//=======================================================

always @(*)
begin
	
	RegENTRY_Signal = {RegENTRY_Register[1] | ~SC_RegENTRY_enterLeft_InLow,   //se activa el 1 de la izq
							 RegENTRY_Register[0] | ~SC_RegENTRY_enterRight_InLow}; //se activa el 1 de la der
	SC_RegENTRY_chgEntry_OutLow = SC_RegENTRY_enterLeft_InLow & SC_RegENTRY_enterRight_InLow;//es 0 si alguno es 0 (cambió alguna entrada)
end

always @(posedge SC_RegENTRY_CLOCK_50, posedge SC_RegENTRY_RESET_InHigh)
begin
	if (SC_RegENTRY_RESET_InHigh == 1'b1)
		RegENTRY_Register <= 0; //El número de entradas inicial es 0 (las 2 abiertas)
	else
		RegENTRY_Register <= RegENTRY_Signal;
end
//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign SC_RegENTRY_numEntry_Out = RegENTRY_Register;

endmodule

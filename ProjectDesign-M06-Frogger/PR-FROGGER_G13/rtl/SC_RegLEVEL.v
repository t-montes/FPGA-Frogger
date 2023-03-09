//=======================================================
//  MODULE Definition
//=======================================================
module SC_RegLEVEL (
	//////////// OUTPUTS //////////
	SC_RegLEVEL_numLevel_Out,
	//////////// INPUTS //////////
	SC_RegLEVEL_CLOCK_50,
	SC_RegLEVEL_RESET_InHigh,
	SC_RegLEVEL_chgEntry_InLow,
	SC_RegLEVEL_numEntry_In
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output 	[2:0] SC_RegLEVEL_numLevel_Out;
input		SC_RegLEVEL_CLOCK_50;
input		SC_RegLEVEL_RESET_InHigh;
input		SC_RegLEVEL_chgEntry_InLow;
input		[1:0] SC_RegLEVEL_numEntry_In;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [2:0] RegLEVEL_Register;
reg [2:0] RegLEVEL_Signal;

reg RegJUSTWON_Register; //Registro de si acaba de pasar de nivel (evita que sume más de un nivel)
reg RegJUSTWON_Signal;
//=======================================================
//  Structural coding
//=======================================================

always @(*)
begin
	if ((SC_RegLEVEL_chgEntry_InLow == 1'b0) & (SC_RegLEVEL_numEntry_In == 2'b11)) begin
		if (RegJUSTWON_Register == 1'b0)
			RegLEVEL_Signal = RegLEVEL_Register + 2'b01; //Siguiente Nivel	
		else
			RegLEVEL_Signal = RegLEVEL_Register;	
		
		RegJUSTWON_Signal = 1'b1;
	end else begin
		RegLEVEL_Signal = RegLEVEL_Register;
		RegJUSTWON_Signal = 1'b0;
	end
end

always @(posedge SC_RegLEVEL_CLOCK_50, posedge SC_RegLEVEL_RESET_InHigh)
begin
	if (SC_RegLEVEL_RESET_InHigh == 1'b1) begin
		RegLEVEL_Register <= 1; //El primer nivel es el nivel 1
		RegJUSTWON_Register <= 1'b0;
	end else begin
		RegLEVEL_Register <= RegLEVEL_Signal;
		RegJUSTWON_Register <= RegJUSTWON_Signal;
	end
end
//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign SC_RegLEVEL_numLevel_Out = RegLEVEL_Register;

endmodule

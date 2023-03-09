//=======================================================
//  MODULE Definition
//=======================================================
module SC_RegLIVES (
	//////////// OUTPUTS //////////
	SC_RegLIVES_numLives_Out,
	//////////// INPUTS //////////
	SC_RegLIVES_CLOCK_50,
	SC_RegLIVES_RESET_InHigh,
	SC_RegLIVES_lose_InLow
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output 	[1:0] SC_RegLIVES_numLives_Out;
input		SC_RegLIVES_CLOCK_50;
input		SC_RegLIVES_RESET_InHigh;
input		SC_RegLIVES_lose_InLow;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [1:0] RegLIVES_Register;
reg [1:0] RegLIVES_Signal;

reg RegJUSTLOST_Register; //Registro de si acaba de perder (evita que se pierdan varias vidas en 1)
reg RegJUSTLOST_Signal;
//=======================================================
//  Structural coding
//=======================================================

always @(*)
begin
	if (SC_RegLIVES_lose_InLow == 1'b0) begin
		if (RegJUSTLOST_Register == 1'b0)
			RegLIVES_Signal = RegLIVES_Register - 2'b01; //Pierde una vida		
		else
			RegLIVES_Signal = RegLIVES_Register;	
		
		RegJUSTLOST_Signal = 1'b1;
	end else begin
		RegLIVES_Signal = RegLIVES_Register;
		RegJUSTLOST_Signal = 1'b0;
	end
end

always @(posedge SC_RegLIVES_CLOCK_50, posedge SC_RegLIVES_RESET_InHigh)
begin
	if (SC_RegLIVES_RESET_InHigh == 1'b1) begin
		RegLIVES_Register <= 2'b11; //El valor inicial de las vidas es 3
		RegJUSTLOST_Register <= 1'b0;
	end else begin
		RegLIVES_Register <= RegLIVES_Signal;
		RegJUSTLOST_Register <= RegJUSTLOST_Signal;
	end
end
//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign SC_RegLIVES_numLives_Out = RegLIVES_Register;

endmodule

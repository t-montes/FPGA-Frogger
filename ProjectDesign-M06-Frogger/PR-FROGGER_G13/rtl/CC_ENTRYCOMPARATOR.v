//=======================================================
//  MODULE Definition
//=======================================================
module CC_ENTRYCOMPARATOR #(parameter ENTRYCOMPARATOR_DATAWIDTH=8)(
	//////////// OUTPUTS //////////
	CC_ENTRYCOMPARATOR_lose_OutLow,
	CC_ENTRYCOMPARATOR_enterLeft_OutLow,
	CC_ENTRYCOMPARATOR_enterRight_OutLow,
	//////////// INPUTS //////////
	CC_ENTRYCOMPARATOR_entryBUS,
	CC_ENTRYCOMPARATOR_froggerBUS
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output reg 	CC_ENTRYCOMPARATOR_lose_OutLow;
output reg	CC_ENTRYCOMPARATOR_enterLeft_OutLow;
output reg	CC_ENTRYCOMPARATOR_enterRight_OutLow;
input 		[ENTRYCOMPARATOR_DATAWIDTH-1:0] CC_ENTRYCOMPARATOR_entryBUS;
input 		[ENTRYCOMPARATOR_DATAWIDTH-1:0] CC_ENTRYCOMPARATOR_froggerBUS;
//=======================================================
//  REG/WIRE declarations
//=======================================================
//=======================================================
//  Structural coding
//=======================================================
always @(*)
begin
	if (CC_ENTRYCOMPARATOR_entryBUS == 8'b00000000) 
	begin //La entrada no está activa
		CC_ENTRYCOMPARATOR_lose_OutLow = 1'b1;
		CC_ENTRYCOMPARATOR_enterLeft_OutLow = 1'b1;
		CC_ENTRYCOMPARATOR_enterRight_OutLow = 1'b1;
	end 
	else 
	begin
		CC_ENTRYCOMPARATOR_enterLeft_OutLow = ~CC_ENTRYCOMPARATOR_froggerBUS[5];
		CC_ENTRYCOMPARATOR_enterRight_OutLow = ~CC_ENTRYCOMPARATOR_froggerBUS[2];
		CC_ENTRYCOMPARATOR_lose_OutLow = ((CC_ENTRYCOMPARATOR_entryBUS & CC_ENTRYCOMPARATOR_froggerBUS) == 8'b00000000); 	//0 si hay algún 1 en el AND
	end
end

endmodule

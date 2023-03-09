//=======================================================
//  MODULE Definition
//=======================================================
module CC_COLLISIONCOMPARATOR #(parameter COLLISIONCOMPARATOR_DATAWIDTH=8)(
//////////// OUTPUTS //////////
	CC_COLLISIONCOMPARATOR_lose_OutLow,
//////////// INPUTS //////////
	CC_COLLISIONCOMPARATOR_backgBUS,
	CC_COLLISIONCOMPARATOR_froggerBUS
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output reg 	CC_COLLISIONCOMPARATOR_lose_OutLow;
input 		[COLLISIONCOMPARATOR_DATAWIDTH-1:0] CC_COLLISIONCOMPARATOR_backgBUS;
input 		[COLLISIONCOMPARATOR_DATAWIDTH-1:0] CC_COLLISIONCOMPARATOR_froggerBUS;
//=======================================================
//  REG/WIRE declarations
//=======================================================
//=======================================================
//  Structural coding
//=======================================================
always @(CC_COLLISIONCOMPARATOR_froggerBUS, CC_COLLISIONCOMPARATOR_backgBUS)
begin
	if ((CC_COLLISIONCOMPARATOR_froggerBUS & CC_COLLISIONCOMPARATOR_backgBUS) == 8'b00000000) //No hubo colisión
		CC_COLLISIONCOMPARATOR_lose_OutLow = 1'b1;
	else
		CC_COLLISIONCOMPARATOR_lose_OutLow = 1'b0;
end

endmodule

/*######################################################################
//#	G0B1T: HDL EXAMPLES. 2018.
//######################################################################
//# Copyright (C) 2018. F.E.Segura-Quijano (FES) fsegura@uniandes.edu.co
//# 
//# This program is free software: you can redistribute it and/or modify
//# it under the terms of the GNU General Public License as published by
//# the Free Software Foundation, version 3 of the License.
//#
//# This program is distributed in the hope that it will be useful,
//# but WITHOUT ANY WARRANTY; without even the implied warranty of
//# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//# GNU General Public License for more details.
//#
//# You should have received a copy of the GNU General Public License
//# along with this program.  If not, see <http://www.gnu.org/licenses/>
//####################################################################*/
//=======================================================
//  MODULE Definition
//=======================================================
module SC_RegBACKG #(parameter RegBACKG_DATAWIDTH=8, 
   parameter DATA_CLEARBACKG             =8'b00000000,
	parameter DATA_FIXED_REGBACKG_NIVEL1  =8'b00000000, 
	parameter DATA_FIXED_REGBACKG_NIVEL2  =8'b00000000,
	parameter DATA_FIXED_REGBACKG_NIVEL3  =8'b00000000, 
	parameter DATA_FIXED_REGBACKG_NIVEL4  =8'b00000000,
	parameter DATA_FIXED_REGBACKG_FIGLVL2 =8'b00000000, 
	parameter DATA_FIXED_REGBACKG_FIGLVL3 =8'b00000000,
	parameter DATA_FIXED_REGBACKG_FIGLVL4 =8'b00000000, 
	parameter DATA_FIXED_REGBACKG_WIN     =8'b00000000,
	parameter DATA_FIXED_REGBACKG_FIGLIFE2=8'b00000000,
	parameter DATA_FIXED_REGBACKG_FIGLIFE1=8'b00000000,
	parameter DATA_FIXED_REGBACKG_LOSE    =8'b00000000)(
	//////////// OUTPUTS //////////
	SC_RegBACKG_data_OutBUS,
	//////////// INPUTS //////////
	SC_RegBACKG_CLOCK_50,
	SC_RegBACKG_RESET_InHigh,
	SC_RegBACKG_clear_InLow, 
	SC_RegBACKG_loadLevel_In,
	SC_RegBACKG_loadFigure_In,
	SC_RegBACKG_shift_In
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output		[RegBACKG_DATAWIDTH-1:0]	SC_RegBACKG_data_OutBUS;
input		SC_RegBACKG_CLOCK_50;
input		SC_RegBACKG_RESET_InHigh;
input		SC_RegBACKG_clear_InLow;
input		[2:0] SC_RegBACKG_loadLevel_In;
input		[2:0] SC_RegBACKG_loadFigure_In;	
input		[1:0] SC_RegBACKG_shift_In;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [RegBACKG_DATAWIDTH-1:0] RegBACKG_Register;
reg [RegBACKG_DATAWIDTH-1:0] RegBACKG_Signal;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always @(*)
begin
	if (SC_RegBACKG_clear_InLow == 1'b0) 					//clear
		RegBACKG_Signal = DATA_CLEARBACKG;
	else if (SC_RegBACKG_loadLevel_In == 3'b001)			//niveles - carros (antes de empezar a moverse)
		RegBACKG_Signal = DATA_FIXED_REGBACKG_NIVEL1;
	else if (SC_RegBACKG_loadLevel_In == 3'b010)
		RegBACKG_Signal = DATA_FIXED_REGBACKG_NIVEL2;
	else if (SC_RegBACKG_loadLevel_In == 3'b011)
		RegBACKG_Signal = DATA_FIXED_REGBACKG_NIVEL3;
	else if (SC_RegBACKG_loadLevel_In == 3'b100)
		RegBACKG_Signal = DATA_FIXED_REGBACKG_NIVEL4;
	else if (SC_RegBACKG_loadFigure_In == 3'b001)		//figuras
		RegBACKG_Signal = DATA_FIXED_REGBACKG_FIGLVL2;
	else if (SC_RegBACKG_loadFigure_In == 3'b010)
		RegBACKG_Signal = DATA_FIXED_REGBACKG_FIGLVL3;
	else if (SC_RegBACKG_loadFigure_In == 3'b011)
		RegBACKG_Signal = DATA_FIXED_REGBACKG_FIGLVL4;
	else if (SC_RegBACKG_loadFigure_In == 3'b100)
		RegBACKG_Signal = DATA_FIXED_REGBACKG_WIN;
	else if (SC_RegBACKG_loadFigure_In == 3'b101)
		RegBACKG_Signal = DATA_FIXED_REGBACKG_FIGLIFE2;
	else if (SC_RegBACKG_loadFigure_In == 3'b110)
		RegBACKG_Signal = DATA_FIXED_REGBACKG_FIGLIFE1;
	else if (SC_RegBACKG_loadFigure_In == 3'b111)
		RegBACKG_Signal = DATA_FIXED_REGBACKG_LOSE;
	else if (SC_RegBACKG_shift_In == 2'b01)				//carros (mover izquierda)
		RegBACKG_Signal = {RegBACKG_Register[RegBACKG_DATAWIDTH-2:0],RegBACKG_Register[RegBACKG_DATAWIDTH-1]};
	else if (SC_RegBACKG_shift_In== 2'b10)					//carros (mover derecha)
		RegBACKG_Signal = {RegBACKG_Register[0],RegBACKG_Register[RegBACKG_DATAWIDTH-1:1]};
	else																//si ninguna se cumple, se mantiene el anterior registro
		RegBACKG_Signal = RegBACKG_Register;
end	
//STATE REGISTER: SEQUENTIAL
always @(posedge SC_RegBACKG_CLOCK_50, posedge SC_RegBACKG_RESET_InHigh)
begin
	if (SC_RegBACKG_RESET_InHigh == 1'b1)
		RegBACKG_Register <= 0;
	else
		RegBACKG_Register <= RegBACKG_Signal;
end
//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign SC_RegBACKG_data_OutBUS = RegBACKG_Register;

endmodule

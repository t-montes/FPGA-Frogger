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
module SC_RegFROGGER #(parameter RegFROGGER_DATAWIDTH=8, 
							  parameter DATA_CLEARFROGGER=        8'b00000000,
							  parameter DATA_FIXED_INITREGFROGGER=8'b00000000)(
	//////////// OUTPUTS //////////
	SC_RegFROGGER_data_OutBUS,
	
	//////////// INPUTS //////////
	SC_RegFROGGER_CLOCK_50,
	SC_RegFROGGER_RESET_InHigh,
	SC_RegFROGGER_clear_InLow, 
	SC_RegFROGGER_init_InLow, 
	SC_RegFROGGER_load0_InLow, 
	SC_RegFROGGER_load1_InLow, 
	SC_RegFROGGER_shiftselection_In,
	SC_RegFROGGER_data0_InBUS,
	SC_RegFROGGER_data1_InBUS
);
//=======================================================
//  PARAMETER declarations
//=======================================================

//=======================================================
//  PORT declarations
//=======================================================
output		[RegFROGGER_DATAWIDTH-1:0]	SC_RegFROGGER_data_OutBUS;
input		SC_RegFROGGER_CLOCK_50;
input		SC_RegFROGGER_RESET_InHigh;
input		SC_RegFROGGER_clear_InLow;
input		SC_RegFROGGER_init_InLow;
input		SC_RegFROGGER_load0_InLow;	
input		SC_RegFROGGER_load1_InLow;	
input		[1:0] SC_RegFROGGER_shiftselection_In;
input		[RegFROGGER_DATAWIDTH-1:0]	SC_RegFROGGER_data0_InBUS;
input		[RegFROGGER_DATAWIDTH-1:0]	SC_RegFROGGER_data1_InBUS;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [RegFROGGER_DATAWIDTH-1:0] RegFROGGER_Register;
reg [RegFROGGER_DATAWIDTH-1:0] RegFROGGER_Signal;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
always @(*)
begin
	if (SC_RegFROGGER_clear_InLow == 1'b0)
		RegFROGGER_Signal = DATA_CLEARFROGGER;
	else if (SC_RegFROGGER_init_InLow == 1'b0)
		RegFROGGER_Signal = DATA_FIXED_INITREGFROGGER;
	else if (SC_RegFROGGER_load0_InLow == 1'b0)
		RegFROGGER_Signal = SC_RegFROGGER_data0_InBUS;
	else if (SC_RegFROGGER_load1_InLow == 1'b0)
		RegFROGGER_Signal = SC_RegFROGGER_data1_InBUS;
	else if (SC_RegFROGGER_shiftselection_In == 2'b01)
		RegFROGGER_Signal = {RegFROGGER_Register[RegFROGGER_DATAWIDTH-2:0],RegFROGGER_Register[RegFROGGER_DATAWIDTH-1]};
	else if (SC_RegFROGGER_shiftselection_In == 2'b10)
		RegFROGGER_Signal = {RegFROGGER_Register[0],RegFROGGER_Register[RegFROGGER_DATAWIDTH-1:1]};
	else
		RegFROGGER_Signal = RegFROGGER_Register;
	end	
//STATE REGISTER: SEQUENTIAL
always @(posedge SC_RegFROGGER_CLOCK_50, posedge SC_RegFROGGER_RESET_InHigh)
begin
	if (SC_RegFROGGER_RESET_InHigh == 1'b1)
		RegFROGGER_Register <= 0;
	else
		RegFROGGER_Register <= RegFROGGER_Signal;
end
//=======================================================
//  Outputs
//=======================================================
//OUTPUT LOGIC: COMBINATIONAL
assign SC_RegFROGGER_data_OutBUS = RegFROGGER_Register;

endmodule

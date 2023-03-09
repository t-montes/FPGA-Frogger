///*######################################################################
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
module SC_STATEMACHINEFROGGER (
	//////////// OUTPUTS //////////
	SC_STATEMACHINEFROGGER_clear_OutLow,
	SC_STATEMACHINEFROGGER_init_OutLow,
	SC_STATEMACHINEFROGGER_load0_OutLow,
	SC_STATEMACHINEFROGGER_load1_OutLow,
	SC_STATEMACHINEFROGGER_shiftselection_Out,
	//////////// INPUTS //////////
	SC_STATEMACHINEFROGGER_CLOCK_50,
	SC_STATEMACHINEFROGGER_RESET_InHigh,
	SC_STATEMACHINEFROGGER_setFrogger_In,
	SC_STATEMACHINEFROGGER_upButton_InLow,
	SC_STATEMACHINEFROGGER_downButton_InLow,
	SC_STATEMACHINEFROGGER_leftButton_InLow,
	SC_STATEMACHINEFROGGER_rightButton_InLow,
	SC_STATEMACHINEFROGGER_bottomsidecomparator_InLow
);	
//=======================================================
//  PARAMETER declarations
//=======================================================
// states declaration
localparam STATE_CHECK0									= 0;
localparam STATE_CHECK1									= 1;
localparam STATE_INIT									= 2;
localparam STATE_CLEAR									= 3;
localparam STATE_UP										= 4;
localparam STATE_DOWN									= 5; 
localparam STATE_LEFT									= 6; 
localparam STATE_RIGHT									= 7;
//=======================================================
//  PORT declarations
//=======================================================
output reg		SC_STATEMACHINEFROGGER_clear_OutLow;
output reg		SC_STATEMACHINEFROGGER_init_OutLow;
output reg		SC_STATEMACHINEFROGGER_load0_OutLow;
output reg		SC_STATEMACHINEFROGGER_load1_OutLow;
output reg		[1:0] SC_STATEMACHINEFROGGER_shiftselection_Out;
input			SC_STATEMACHINEFROGGER_CLOCK_50;
input 		SC_STATEMACHINEFROGGER_RESET_InHigh;
input			[1:0] SC_STATEMACHINEFROGGER_setFrogger_In;
input			SC_STATEMACHINEFROGGER_upButton_InLow;
input			SC_STATEMACHINEFROGGER_downButton_InLow;
input			SC_STATEMACHINEFROGGER_leftButton_InLow;
input			SC_STATEMACHINEFROGGER_rightButton_InLow;
input			SC_STATEMACHINEFROGGER_bottomsidecomparator_InLow;
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [3:0] STATE_Register;
reg [3:0] STATE_Signal;
//=======================================================
//  Structural coding
//=======================================================
//INPUT LOGIC: COMBINATIONAL
// NEXT STATE LOGIC : COMBINATIONAL
always @(*)
begin
	case (STATE_Register)
		STATE_CHECK0: 	if (SC_STATEMACHINEFROGGER_setFrogger_In == 2'b01) STATE_Signal = STATE_CHECK0;
							else if (SC_STATEMACHINEFROGGER_setFrogger_In == 2'b10) STATE_Signal = STATE_INIT;
							else if (SC_STATEMACHINEFROGGER_setFrogger_In == 2'b11) STATE_Signal = STATE_CLEAR;
							else if (SC_STATEMACHINEFROGGER_upButton_InLow == 1'b0) STATE_Signal = STATE_UP;
							else if (SC_STATEMACHINEFROGGER_downButton_InLow == 1'b0 & (SC_STATEMACHINEFROGGER_bottomsidecomparator_InLow == 1'b1)) STATE_Signal = STATE_DOWN;
							else if (SC_STATEMACHINEFROGGER_leftButton_InLow == 1'b0) STATE_Signal = STATE_LEFT;
							else if (SC_STATEMACHINEFROGGER_rightButton_InLow == 1'b0) STATE_Signal = STATE_RIGHT;
							else STATE_Signal = STATE_CHECK0;
		STATE_INIT: 	STATE_Signal = STATE_CHECK1;
		STATE_CLEAR: 	STATE_Signal = STATE_CHECK1;
		STATE_UP: 		STATE_Signal = STATE_CHECK1;
		STATE_DOWN: 	STATE_Signal = STATE_CHECK1;
		STATE_LEFT: 	STATE_Signal = STATE_CHECK1;
		STATE_RIGHT: 	STATE_Signal = STATE_CHECK1;
		STATE_CHECK1: 	if (SC_STATEMACHINEFROGGER_setFrogger_In == 2'b01) STATE_Signal = STATE_CHECK0;
							else if (SC_STATEMACHINEFROGGER_setFrogger_In == 2'b10) STATE_Signal = STATE_INIT;
							else if (SC_STATEMACHINEFROGGER_setFrogger_In == 2'b11) STATE_Signal = STATE_CLEAR;
							else if (SC_STATEMACHINEFROGGER_upButton_InLow == 1'b0) STATE_Signal = STATE_CHECK1;
							else if (SC_STATEMACHINEFROGGER_downButton_InLow == 1'b0) STATE_Signal = STATE_CHECK1;
							else if (SC_STATEMACHINEFROGGER_leftButton_InLow == 1'b0) STATE_Signal = STATE_CHECK1;
							else if (SC_STATEMACHINEFROGGER_rightButton_InLow == 1'b0) STATE_Signal = STATE_CHECK1;
							else STATE_Signal = STATE_CHECK0;		
		default : 		STATE_Signal = STATE_CHECK0;
	endcase
end
// STATE REGISTER : SEQUENTIAL
always @ ( posedge SC_STATEMACHINEFROGGER_CLOCK_50 , posedge SC_STATEMACHINEFROGGER_RESET_InHigh)
begin
	if (SC_STATEMACHINEFROGGER_RESET_InHigh == 1'b1)
		STATE_Register <= STATE_CHECK0;
	else
		STATE_Register <= STATE_Signal;
end
//=======================================================
//  Outputs
//=======================================================
// OUTPUT LOGIC : COMBINATIONAL

always @(*)
begin
	case (STATE_Register)
//=========================================================
// STATE_CHECK0
//=========================================================
	STATE_CHECK0:
		begin
			SC_STATEMACHINEFROGGER_clear_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_init_OutLow  = 1'b1;
			SC_STATEMACHINEFROGGER_load0_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_load1_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_shiftselection_Out  = 2'b11; 
		end
//=========================================================
// STATE_CHECK1
//=========================================================
	STATE_CHECK1:
		begin
			SC_STATEMACHINEFROGGER_clear_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_init_OutLow  = 1'b1;
			SC_STATEMACHINEFROGGER_load0_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_load1_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_shiftselection_Out  = 2'b11; 
		end
//=========================================================
// STATE_INIT
//=========================================================
	STATE_INIT:
		begin
			SC_STATEMACHINEFROGGER_clear_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_init_OutLow  = 1'b0;
			SC_STATEMACHINEFROGGER_load0_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_load1_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_shiftselection_Out  = 2'b11; 
		end
//=========================================================
// STATE_CLEAR
//=========================================================
	STATE_CLEAR:
		begin
			SC_STATEMACHINEFROGGER_clear_OutLow = 1'b0;
			SC_STATEMACHINEFROGGER_init_OutLow  = 1'b1;
			SC_STATEMACHINEFROGGER_load0_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_load1_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_shiftselection_Out  = 2'b11; 
		end
//=========================================================
// STATE_UP
//=========================================================
	STATE_UP:
		begin
			SC_STATEMACHINEFROGGER_clear_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_init_OutLow  = 1'b1;
			SC_STATEMACHINEFROGGER_load0_OutLow = 1'b0;
			SC_STATEMACHINEFROGGER_load1_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_shiftselection_Out  = 2'b11; 
		end
//=========================================================
// STATE_DOWN
//=========================================================
	STATE_DOWN:
		begin
			SC_STATEMACHINEFROGGER_clear_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_init_OutLow  = 1'b1;
			SC_STATEMACHINEFROGGER_load0_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_load1_OutLow = 1'b0;
			SC_STATEMACHINEFROGGER_shiftselection_Out  = 2'b11; 
		end
//=========================================================
// STATE_LEFT
//=========================================================
	STATE_LEFT:
		begin
			SC_STATEMACHINEFROGGER_clear_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_init_OutLow  = 1'b1;
			SC_STATEMACHINEFROGGER_load0_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_load1_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_shiftselection_Out  = 2'b01; 
		end
//=========================================================
// STATE_RIGHT
//=========================================================
	STATE_RIGHT:
		begin
			SC_STATEMACHINEFROGGER_clear_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_init_OutLow  = 1'b1;
			SC_STATEMACHINEFROGGER_load0_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_load1_OutLow = 1'b1;
			SC_STATEMACHINEFROGGER_shiftselection_Out  = 2'b10; 
		end
//=========================================================
// DEFAULT
//=========================================================
	default:
		begin
			
		end
	endcase
end

endmodule

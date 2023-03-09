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
module SC_STATEMACHINEBACKG (
	//////////// OUTPUTS //////////
	SC_STATEMACHINEBACKG_setFrogger_Out,
	SC_STATEMACHINEBACKG_clearBackg_OutLow,
	SC_STATEMACHINEBACKG_loadLevel_Out,
	SC_STATEMACHINEBACKG_loadFigure_Out,
	SC_STATEMACHINEBACKG_loadEntry_Out,
	SC_STATEMACHINEBACKG_shift_Out,
	SC_STATEMACHINEBACKG_upCount_OutLow,
	SC_STATEMACHINEBACKG_resetLevel_OutHigh,
	SC_STATEMACHINEBACKG_resetLives_OutHigh,
	SC_STATEMACHINEBACKG_resetEntry_OutHigh,
	SC_STATEMACHINEBACKG_resetPrescaler_OutHigh,
	//////////// INPUTS //////////
	SC_STATEMACHINEBACKG_CLOCK_50,
	SC_STATEMACHINEBACKG_RESET_InHigh,
	SC_STATEMACHINEBACKG_startButton_InLow,
	SC_STATEMACHINEBACKG_T0_InLow,
	SC_STATEMACHINEBACKG_lose_InLow,
	SC_STATEMACHINEBACKG_chgEntry_InLow,
	SC_STATEMACHINEBACKG_numEntry_In,
	SC_STATEMACHINEBACKG_numLives_In,
	SC_STATEMACHINEBACKG_numLevel_In
);
//=======================================================
//  PARAMETER declarations
//=======================================================
// states declaration
localparam STATE_RESET									= 0;
localparam STATE_START									= 1;
localparam STATE_INIT									= 2;
localparam STATE_INITLVL								= 3;
localparam STATE_CHECK									= 4;
localparam STATE_CHENTRY								= 5;
localparam STATE_COUNT									= 6;
localparam STATE_SHIFT									= 7;
localparam STATE_LOSE0									= 8;
localparam STATE_LOSE1									= 9;
localparam STATE_LOSE2									= 10;
localparam STATE_WIN0									= 11;
localparam STATE_WIN1									= 12;
localparam STATE_WIN2									= 13;
//=======================================================
//  PORT declarations
//=======================================================
output reg		[1:0] SC_STATEMACHINEBACKG_setFrogger_Out;
output reg		SC_STATEMACHINEBACKG_clearBackg_OutLow;
output reg		[2:0] SC_STATEMACHINEBACKG_loadLevel_Out;
output reg		[2:0] SC_STATEMACHINEBACKG_loadFigure_Out;
output reg 		[1:0] SC_STATEMACHINEBACKG_loadEntry_Out;
output reg		[1:0] SC_STATEMACHINEBACKG_shift_Out;
output reg 		SC_STATEMACHINEBACKG_upCount_OutLow;
output reg 		SC_STATEMACHINEBACKG_resetLevel_OutHigh;
output reg 		SC_STATEMACHINEBACKG_resetLives_OutHigh;
output reg 		SC_STATEMACHINEBACKG_resetEntry_OutHigh;
output reg 		SC_STATEMACHINEBACKG_resetPrescaler_OutHigh;
input			SC_STATEMACHINEBACKG_CLOCK_50;
input 		SC_STATEMACHINEBACKG_RESET_InHigh;
input			SC_STATEMACHINEBACKG_startButton_InLow;
input			SC_STATEMACHINEBACKG_T0_InLow;
input			SC_STATEMACHINEBACKG_lose_InLow;
input			SC_STATEMACHINEBACKG_chgEntry_InLow;
input 		[1:0] SC_STATEMACHINEBACKG_numEntry_In;
input 		[1:0] SC_STATEMACHINEBACKG_numLives_In;
input 		[2:0] SC_STATEMACHINEBACKG_numLevel_In;
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
		STATE_RESET:   STATE_Signal = STATE_START;
		STATE_START:   STATE_Signal = STATE_INIT;
		STATE_INIT:    if (SC_STATEMACHINEBACKG_startButton_InLow == 1'b0) STATE_Signal = STATE_INITLVL;
							else STATE_Signal = STATE_INIT;
		STATE_INITLVL: STATE_Signal = STATE_CHECK;
		STATE_CHECK:   if (SC_STATEMACHINEBACKG_T0_InLow == 1'b0) STATE_Signal = STATE_SHIFT;
						   else if (SC_STATEMACHINEBACKG_lose_InLow == 1'b0) STATE_Signal = STATE_LOSE0; //hubo colisión
						   else if (SC_STATEMACHINEBACKG_chgEntry_InLow == 1'b0) begin //entró alguna rana
								if (SC_STATEMACHINEBACKG_numEntry_In == 2'b11) STATE_Signal = STATE_WIN0; //ya entraron las 2 ranas
								else STATE_Signal = STATE_CHENTRY;
							end else STATE_Signal = STATE_COUNT;
		STATE_CHENTRY: STATE_Signal = STATE_INITLVL;
		STATE_COUNT:   STATE_Signal = STATE_CHECK;
		STATE_SHIFT:   STATE_Signal = STATE_CHECK;
		STATE_LOSE0:   STATE_Signal = STATE_LOSE1;
		STATE_LOSE1:   if (SC_STATEMACHINEBACKG_startButton_InLow == 1'b0) begin 
							   if (SC_STATEMACHINEBACKG_numLives_In == 2'b00) STATE_Signal = STATE_START; //Perdida Definitiva (vidas = 0)
							   else STATE_Signal = STATE_LOSE2;
						   end else STATE_Signal = STATE_LOSE1;
		STATE_LOSE2: STATE_Signal = STATE_INITLVL;
		STATE_WIN0:    STATE_Signal = STATE_WIN1;
		STATE_WIN1:    if (SC_STATEMACHINEBACKG_startButton_InLow == 1'b0) begin 
							   if (SC_STATEMACHINEBACKG_numLevel_In == 3'b101) STATE_Signal = STATE_START; //Ganada Definitiva (nivel = 5)
							   else STATE_Signal = STATE_WIN2;
						   end else STATE_Signal = STATE_WIN1;
		STATE_WIN2: STATE_Signal = STATE_INITLVL;
		default:       STATE_Signal = STATE_START;
	endcase
end
// STATE REGISTER : SEQUENTIAL
always @ ( posedge SC_STATEMACHINEBACKG_CLOCK_50 , posedge SC_STATEMACHINEBACKG_RESET_InHigh)
begin
	if (SC_STATEMACHINEBACKG_RESET_InHigh == 1'b1)
		STATE_Register <= STATE_RESET;
	else
		STATE_Register <= STATE_Signal;
end
//=======================================================
//  Outputs
//=======================================================
// OUTPUT LOGIC : COMBINATIONAL
always @ (*)
begin
	case (STATE_Register)
//=========================================================
// STATE_RESET
//=========================================================
	STATE_RESET : //Nada
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b00;
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = 2'b11;
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// STATE_START
//=========================================================
	STATE_START :
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b10; //Envía frogger abajo
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b0; //Sin mostrar nada de fondo
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = 2'b11;
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b1; //Reinicia Niveles (solo se reinicia niveles en este estado)
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b1; //Reinicia Vidas
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b1; //Reinicia Entradas
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b1; //Reinicia contador Prescaler
		end
//=========================================================
// STATE_INIT
//=========================================================
	STATE_INIT : //A LA ESPERA DE START
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b01; //Fija el frogger en las posición (abajo)
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = 2'b11; //No mostrar entradas
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// STATE_INITLVL
//=========================================================
	STATE_INITLVL :
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b00; //Frogger libre de moverse
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = SC_STATEMACHINEBACKG_numLevel_In; //Se cargan los carros iniciales del nivel actual
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = SC_STATEMACHINEBACKG_numEntry_In; //Se cargan el número de entradas actuales
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// STATE_CHECK
//=========================================================
	STATE_CHECK : //A LA ESPERA DE PERDER, GANAR O HACER SHIFT
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b00;
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000; //nota: Solo se deben cargar los carros 1 vez
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = SC_STATEMACHINEBACKG_numEntry_In; //Las entradas si deben permanecer cargándose
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// STATE_CHENTRY
//=========================================================
	STATE_CHENTRY :
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b10; //Reinicia el frogger cada vez que entra un frogger a la casa
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = SC_STATEMACHINEBACKG_numEntry_In; //Las entradas si deben permanecer cargándose
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// STATE_COUNT
//=========================================================
	STATE_COUNT :
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b00;
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = SC_STATEMACHINEBACKG_numEntry_In; //Las entradas si deben permanecer cargándose
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b0; //Se hace un conteo al prescaler
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// STATE_SHIFT
//=========================================================
	STATE_SHIFT :
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b00;
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = SC_STATEMACHINEBACKG_numEntry_In; //Las entradas si deben permanecer cargándose
			SC_STATEMACHINEBACKG_shift_Out = 2'b10; //Hace shift a la derecha
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b1; //Reinicia el prescaler
		end
//=========================================================
// STATE_LOSE0
//=========================================================
	STATE_LOSE0 :
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b11; //Elimina el frogger de la vista (clear)
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b111 - SC_STATEMACHINEBACKG_numLives_In; //Muestra la figura del número de vidas que le quedan
			SC_STATEMACHINEBACKG_loadEntry_Out = 2'b11; //No mostrar entradas
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// STATE_LOSE1
//=========================================================
	STATE_LOSE1 : //A LA ESPERA DE START
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b01; //Fija el frogger en la posición (escondido)
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = 2'b11; //No mostrar entradas
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// STATE_LOSE2
//=========================================================
	STATE_LOSE2 : //Ubicar el frogger
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b10; //Envía el frogger abajo
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = 2'b11;
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b1; //Reinicia Entradas
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// STATE_WIN0
//=========================================================
	STATE_WIN0 :
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b11; //Elimina el frogger de la vista (clear)
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = SC_STATEMACHINEBACKG_numLevel_In - 1'b1; //Muestra la figura del nivel al que pasó
			SC_STATEMACHINEBACKG_loadEntry_Out = 2'b11; //No mostrar entradas
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// STATE_WIN1
//=========================================================
	STATE_WIN1 : //A LA ESPERA DE START
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b01; //Fija el frogger en la posición (escondido)
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = 2'b11; //No mostrar entradas
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// STATE_WIN2
//=========================================================
	STATE_WIN2 : //Ubicar el frogger
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b10; //Envía el frogger abajo
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000;
			SC_STATEMACHINEBACKG_loadEntry_Out = 2'b11;
			SC_STATEMACHINEBACKG_shift_Out = 2'b11;
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1;
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0;
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b1; //Reinicia vidas
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b1; //Reinicia entradas
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0;
		end
//=========================================================
// DEFAULT
//=========================================================
	default : //Valores que muestran la matriz por defecto
		begin
			SC_STATEMACHINEBACKG_setFrogger_Out = 2'b00; //Frogger libre
			SC_STATEMACHINEBACKG_clearBackg_OutLow = 1'b1; //No limpia backg
			SC_STATEMACHINEBACKG_loadLevel_Out = 3'b000; //No carga carros
			SC_STATEMACHINEBACKG_loadFigure_Out = 3'b000; //No carga figuras
			SC_STATEMACHINEBACKG_loadEntry_Out = 2'b11; //No muestra entradas
			SC_STATEMACHINEBACKG_shift_Out = 2'b11; //No hace shift
			SC_STATEMACHINEBACKG_upCount_OutLow = 1'b1; //No hace conteo de prescaler
			SC_STATEMACHINEBACKG_resetLevel_OutHigh = 1'b0; //No reinicia niveles
			SC_STATEMACHINEBACKG_resetLives_OutHigh = 1'b0; //No reinicia vidas
			SC_STATEMACHINEBACKG_resetEntry_OutHigh = 1'b0; //No reinicia entradas
			SC_STATEMACHINEBACKG_resetPrescaler_OutHigh = 1'b0; //No reeinicia prescaler
		end
	endcase
end
endmodule


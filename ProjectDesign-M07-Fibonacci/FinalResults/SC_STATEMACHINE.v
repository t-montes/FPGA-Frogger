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

/*
Presentado por: 
	* Tony Santiago Montes Buitrago - 202014562
	* Alejandro Pasachoa Aranguren - 202014669

DESCRIPCIÓN ALGORITMO:
	La señal RESET inicia el algoritmo, y lo envía al estado State_START_0.
	Inicialmente el algoritmo pasa los valores de los registros fijos 0 y 1 a los registros generales
	RegGENERAL_u0 y RegGENERAL_u1 respectivamente; luego de esto comienza la parte iterativa.
	PARTE ITERATIVA:
		Se suman mediante la ALU los registros RegGENERAL_u0 y RegGENERAL_u1 y se carga el valor resultado
		al registro RegGENERAL_u3, en el cuál está la salida, posteriormente se mueve el valor del registro
		RegGENERAL_u1 al registro RegGENERAL_u0, y luego el valor del resgistro RegGENERAL_u3 al registro
		RegGENERAL_u1. 
		Finalmente, se envía al estado State_RESULT_0 para indicar que ha terminado una iteración; el resultado
		será el valor almacenado en el registro RegGENERAL_u3.
		Se inicia una nueva iteración.
*/

module SC_STATEMACHINE #(parameter DATAWIDTH_DECODER_SELECTION=3, parameter DATAWIDTH_MUX_SELECTION=3, parameter DATAWIDTH_ALU_SELECTION=4,  parameter DATAWIDTH_REGSHIFTER_SELECTION=2 ) (
	//////////// OUTPUTS //////////
	SC_STATEMACHINE_decoderclearselection_OutBUS,
	SC_STATEMACHINE_decoderloadselection_OutBUS,
	SC_STATEMACHINE_muxselectionBUSA_OutBUS,
	SC_STATEMACHINE_muxselectionBUSB_OutBUS,
	SC_STATEMACHINE_aluselection_OutBUS,
	SC_STATEMACHINE_regSHIFTERclear_OutLow,
	SC_STATEMACHINE_regSHIFTERload_OutLow,
	SC_STATEMACHINE_regSHIFTERshiftselection_OutLow,
	//////////// INPUTS //////////
	SC_STATEMACHINE_CLOCK_50,
	SC_STATEMACHINE_RESET_InHigh,
	SC_STATEMACHINE_overflow_InLow,
	SC_STATEMACHINE_carry_InLow,
	SC_STATEMACHINE_negative_InLow,
	SC_STATEMACHINE_zero_InLow
);	
//=======================================================
//  PARAMETER declarations
//=======================================================
// states declaration
localparam State_RESET_0							= 0;
localparam State_START_0							= 1;
localparam State_MOVFIXED0_0						= 2;
localparam State_MOVFIXED0_1						= 3;
localparam State_MOVFIXED0_2						= 4;
localparam State_MOVFIXED1_0						= 5;
localparam State_MOVFIXED1_1						= 6;
localparam State_MOVFIXED1_2						= 7;
localparam State_SUM_0								= 8;
localparam State_SUM_1								= 9;
localparam State_SUM_2								= 10;
localparam State_MOVReg1to0_0						= 11;
localparam State_MOVReg1to0_1						= 12;
localparam State_MOVReg1to0_2						= 13;
localparam State_MOVReg3to1_0						= 14;
localparam State_MOVReg3to1_1						= 15;
localparam State_MOVReg3to1_2						= 16;
localparam State_RESULT_0							= 17;
localparam State_END_0								= 18;
//=======================================================
//  PORT declarations
//=======================================================
output reg	[DATAWIDTH_DECODER_SELECTION-1:0] SC_STATEMACHINE_decoderclearselection_OutBUS;
output reg	[DATAWIDTH_DECODER_SELECTION-1:0] SC_STATEMACHINE_decoderloadselection_OutBUS;
output reg	[DATAWIDTH_MUX_SELECTION-1:0] SC_STATEMACHINE_muxselectionBUSA_OutBUS;
output reg	[DATAWIDTH_MUX_SELECTION-1:0] SC_STATEMACHINE_muxselectionBUSB_OutBUS;
output reg	[DATAWIDTH_ALU_SELECTION-1:0] SC_STATEMACHINE_aluselection_OutBUS;
output reg	SC_STATEMACHINE_regSHIFTERclear_OutLow;
output reg	SC_STATEMACHINE_regSHIFTERload_OutLow;
output reg	[DATAWIDTH_REGSHIFTER_SELECTION-1:0] SC_STATEMACHINE_regSHIFTERshiftselection_OutLow;
input		SC_STATEMACHINE_CLOCK_50;
input		SC_STATEMACHINE_RESET_InHigh;
input		SC_STATEMACHINE_overflow_InLow;	
input		SC_STATEMACHINE_carry_InLow;	
input		SC_STATEMACHINE_negative_InLow;	
input		SC_STATEMACHINE_zero_InLow;		
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [7:0] State_Register;
reg [7:0] State_Signal;
//=======================================================
//  Structural coding
//=======================================================
//=========================================================
// ADD: RegGEN3 = RegFIX0 + RegFIX1
//=========================================================
//INPUT LOGIC: COMBINATIONAL
// NEXT STATE LOGIC : COMBINATIONAL
always @(*)
case (State_Register)
//TO INIT REGISTERS
	State_RESET_0: State_Signal = 		State_START_0;
	State_START_0: State_Signal = 		State_MOVFIXED0_0;
	State_MOVFIXED0_0: State_Signal = 	State_MOVFIXED0_1;
	State_MOVFIXED0_1: State_Signal = 	State_MOVFIXED0_2;
	State_MOVFIXED0_2: State_Signal = 	State_MOVFIXED1_0;
	State_MOVFIXED1_0: State_Signal = 	State_MOVFIXED1_1;
	State_MOVFIXED1_1: State_Signal = 	State_MOVFIXED1_2;
	State_MOVFIXED1_2: State_Signal = 	State_SUM_0;
	State_SUM_0: State_Signal = 			State_SUM_1;
	State_SUM_1: State_Signal = 			State_SUM_2;
	State_SUM_2: State_Signal = 			State_MOVReg1to0_0;
	State_MOVReg1to0_0: State_Signal = 	State_MOVReg1to0_1;
	State_MOVReg1to0_1: State_Signal = 	State_MOVReg1to0_2;
	State_MOVReg1to0_2: State_Signal = 	State_MOVReg3to1_0;
	State_MOVReg3to1_0: State_Signal = 	State_MOVReg3to1_1;
	State_MOVReg3to1_1: State_Signal = 	State_MOVReg3to1_2;
	State_MOVReg3to1_2: State_Signal = 	State_RESULT_0;
	State_RESULT_0: State_Signal = 		State_SUM_0; 
	State_END_0: State_Signal = 			State_END_0;
	default : State_Signal = 				State_RESET_0;
endcase
	
// STATE REGISTER : SEQUENTIAL
always @ ( posedge SC_STATEMACHINE_CLOCK_50 , posedge SC_STATEMACHINE_RESET_InHigh)
if (SC_STATEMACHINE_RESET_InHigh==1)
	State_Register <= State_RESET_0;
else
	State_Register <= State_Signal;
//=======================================================
//  Outputs
//=======================================================
// OUTPUT LOGIC : COMBINATIONAL
always @ (*)
case (State_Register)
//=========================================================
// RESET_0 STATE
//=========================================================
State_RESET_0 :	
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;				
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;			
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// START_0 STATE
//=========================================================
State_START_0 :	
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// MOVFIXED0_0 STATE
//=========================================================
State_MOVFIXED0_0 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b100; //RegA == RegFIXED_u0 == 0
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0000; //Result == RegFIXED_u0 == 0
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// MOVFIXED0_1 STATE
//=========================================================
State_MOVFIXED0_1 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b100; //RegA == RegFIXED_u0 == 0
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0000; //Result == RegFIXED_u0 == 0
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0; //Load Result
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// MOVFIXED0_2 STATE
//=========================================================
State_MOVFIXED0_2 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b000; //Load Result to RegGENERAL_u0
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// MOVFIXED1_0 STATE
//=========================================================
State_MOVFIXED1_0 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b101; //RegA == RegFIXED_u1 == 1
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0000; //Result == RegFIXED_u1 == 1 
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// MOVFIXED1_1 STATE
//=========================================================
State_MOVFIXED1_1 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b101; //RegA == RegFIXED_u1 == 1
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0000; //Result == RegFIXED_u1 == 1
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0; //Load Result
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// MOVFIXED1_2 STATE
//=========================================================
State_MOVFIXED1_2 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b001; //Load Result to RegGENERAL_u1
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// SUM_0 STATE
//=========================================================
State_SUM_0 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b000; //RegA == RegGENERAL_u0
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b001; //RegB == RegGENERAL_u1
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1000; //Result == RegA + RegB
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// SUM_1 STATE
//=========================================================
State_SUM_1 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b000; //RegA == RegGENERAL_u0
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b001; //RegB == RegGENERAL_u1
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1000; //Result == RegA + RegB
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0; //Load result
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// SUM_2 STATE
//=========================================================
State_SUM_2 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b011; //Load Result to RegGENERAL_u3
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// State_MOVReg1to0_0 STATE
//=========================================================
State_MOVReg1to0_0 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b001; //RegA == RegGENERAL_u1
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0000; //Result == RegA == RegGENERAL_u1
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// State_MOVReg1to0_1 STATE
//=========================================================
State_MOVReg1to0_1 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b001; //RegA == RegGENERAL_u1
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0000; //Result == RegA == RegGENERAL_u1
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0; //Load Result
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// State_MOVReg1to0_2 STATE
//=========================================================
State_MOVReg1to0_2 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b000; //Load Result to RegGENERAL_u0
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// State_MOVReg3to1_0 STATE
//=========================================================
State_MOVReg3to1_0 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b011; //RegA == RegGENERAL_u3
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0000; //Result == RegA == RegGENERAL_u3
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// State_MOVReg3to1_1 STATE
//=========================================================
State_MOVReg3to1_1 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b011; //RegA == RegGENERAL_u3
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b0000; //Result == RegA == RegGENERAL_u3
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 0; //Load Result
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// State_MOVRe3to1_2 STATE
//=========================================================
State_MOVReg3to1_2 :
	begin
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b001; //Load Result to RegGENERAL_u1
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
//=========================================================
// RESULT_0 STATE
//=========================================================
State_RESULT_0 :	// Next number STATE
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;				
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;						
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end	
//=========================================================
// END STATE
//=========================================================
State_END_0 :	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;				
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;				
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;						
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;		
	end	
//=========================================================
// DEFAULT 
//=========================================================
default:	
	begin	
		SC_STATEMACHINE_decoderclearselection_OutBUS = 3'b111;
		SC_STATEMACHINE_decoderloadselection_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSA_OutBUS = 3'b111;
		SC_STATEMACHINE_muxselectionBUSB_OutBUS = 3'b111;
		SC_STATEMACHINE_aluselection_OutBUS = 4'b1111;
		SC_STATEMACHINE_regSHIFTERclear_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERload_OutLow = 1;
		SC_STATEMACHINE_regSHIFTERshiftselection_OutLow = 2'b11;
	end
endcase

endmodule

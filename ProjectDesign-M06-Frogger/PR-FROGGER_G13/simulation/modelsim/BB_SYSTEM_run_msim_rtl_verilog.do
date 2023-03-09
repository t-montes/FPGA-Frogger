transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/SC_RegENTRY.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/SC_RegLEVEL.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/SC_RegLIVES.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/CC_COLLISIONCOMPARATOR.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/CC_ENTRYCOMPARATOR.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/CC_BOTTOMSIDECOMPARATOR.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/SC_RegENTRYFROGGER.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/CC_SPEEDCOMPARATOR.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/SC_upSPEEDCOUNTER.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/SC_RegBACKG.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/SC_STATEMACHINEBACKG.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/SC_RegFROGGER.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/SC_STATEMACHINEFROGGER.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/shift_reg_start_done.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/max7219_ctrl.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/rtl/SC_DEBOUNCE1.v}
vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/BB_SYSTEM.v}

vlog -vlog01compat -work work +incdir+C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/simulation/modelsim {C:/Users/santi/OneDrive/Escritorio/carpetaPruebaSED/PR-FROGGER_G13_FuncionalidadTotal/simulation/modelsim/TB_SYSTEM.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  TB_SYSTEM

add wave *
view structure
view signals
run -all

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CHANNEL" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_BITS" -parent ${Page_0}


}

proc update_PARAM_VALUE.CHANNEL { PARAM_VALUE.CHANNEL } {
	# Procedure called to update CHANNEL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CHANNEL { PARAM_VALUE.CHANNEL } {
	# Procedure called to validate CHANNEL
	return true
}

proc update_PARAM_VALUE.DATA_BITS { PARAM_VALUE.DATA_BITS } {
	# Procedure called to update DATA_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_BITS { PARAM_VALUE.DATA_BITS } {
	# Procedure called to validate DATA_BITS
	return true
}


proc update_MODELPARAM_VALUE.CHANNEL { MODELPARAM_VALUE.CHANNEL PARAM_VALUE.CHANNEL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHANNEL}] ${MODELPARAM_VALUE.CHANNEL}
}

proc update_MODELPARAM_VALUE.DATA_BITS { MODELPARAM_VALUE.DATA_BITS PARAM_VALUE.DATA_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_BITS}] ${MODELPARAM_VALUE.DATA_BITS}
}


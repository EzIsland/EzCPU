create_clock -name i_clk -period 50MHz [get_ports {i_clk}]
derive_pll_clocks
derive_clock_uncertainty
create_generated_clock -name o_clk -source [get_pins {my_pll|altpll_component|auto_generated|pll1|clk[0]}] [get_ports {o_clk}]
set_input_delay -clock {o_clk} -max 2 [get_ports {i_gpio?[*]}]
set_input_delay -clock {o_clk} -min 1 [get_ports {i_gpio?[*]}]
set_output_delay -clock {o_clk} -max 2 [get_ports {o_gpio[*]}]
set_output_delay -clock {o_clk} -min -1 [get_ports {o_gpio[*]}]

vlib work
vmap work work

vlog SPI_Slave.v SPR_Ram.v SPI_wrapper.v tb_wrapper.v

vsim -voptargs=+acc work.tb_SPI_Wrapper

add wave /*
run -all
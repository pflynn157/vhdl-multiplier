# The files
FILES		= src/mul.vhdl src/mul2.vhdl \
                src/slow_exp.vhdl \
                src/rsh.vhdl src/lsh.vhdl src/adder.vhdl
SIMDIR		= sim
SIMFILES	= test/mul_tb.vhdl test/mul_tb2.vhdl test/slow_exp_tb.vhdl

# GHDL
GHDL_CMD	= ghdl
GHDL_FLAGS	= --ieee=synopsys --warn-no-vital-generic
GHDL_WORKDIR = --workdir=sim --work=work
GHDL_STOP	= --stop-time=1200ns

# For visualization
VIEW_CMD        = /usr/bin/gtkwave

# The commands
all:
	make compile
	make run

compile:
	mkdir -p sim
	ghdl -a $(GHDL_FLAGS) $(GHDL_WORKDIR) $(FILES)
	ghdl -a $(GHDL_FLAGS) $(GHDL_WORKDIR) $(SIMFILES)
	ghdl -e -o sim/mul_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) mul_tb
	ghdl -e -o sim/mul_tb2 $(GHDL_FLAGS) $(GHDL_WORKDIR) mul_tb2
	ghdl -e -o sim/slow_exp_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) slow_exp_tb

run:
	cd sim; \
	ghdl -r $(GHDL_FLAGS) mul_tb $(GHDL_STOP) --wave=wave.ghw; \
	ghdl -r $(GHDL_FLAGS) mul_tb2 $(GHDL_STOP) --wave=wave2.ghw; \
	ghdl -r $(GHDL_FLAGS) slow_exp_tb --stop-time=1800ns --wave=slow_exp.ghw; \
	cd ..

view:
	gtkwave sim/wave.ghw

clean:
	$(GHDL_CMD) --clean --workdir=sim

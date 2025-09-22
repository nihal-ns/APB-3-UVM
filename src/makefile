# --- Variables ---
FILE ?= top.sv
TOP  ?= top
test ?= apb_test  # Default test name, can be overridden from the command line

# --- Simulation Options ---
# This section sets the simulation flags.
VERBOSITY ?= NORMAL
VSIM_EXTRA_OPTS =

# Set verbosity based on the VERBOSITY variable
ifeq ($(VERBOSITY), HIGH)
 VSIM_EXTRA_OPTS += +UVM_VERBOSITY=UVM_HIGH
endif
ifeq ($(VERBOSITY), DEBUG)
 VSIM_EXTRA_OPTS += +UVM_VERBOSITY=UVM_DEBUG
endif

# Set the testname if the TEST variable is provided
ifneq ($(test),)
 VSIM_EXTRA_OPTS += +UVM_TESTNAME=$(test)
endif


# --- Targets ---
.PHONY: all compile simulate clean h d

# Default target runs a normal simulation
all: simulate

# --- Shortcut Targets ---
# make      - executes normally
# make h    - executes with VERBOSITY=HIGH
# make d    - executes with VERBOSITY=DEBUG
h:
 @$(MAKE) --no-print-directory simulate VERBOSITY=HIGH

d:
 @$(MAKE) --no-print-directory simulate VERBOSITY=DEBUG
 # --- End of Shortcut Targets ---


compile:
 @vlog -sv apb_pkg.sv $(FILE)

simulate: compile
 @echo "--- Running Simulation (Verbosity: $(VERBOSITY), Test: $(test)) ---"
 @vsim -c $(TOP) $(VSIM_EXTRA_OPTS) -do "run -all ; quit"

clean:
 @rm -rf transcript vsim.wlf work *.log

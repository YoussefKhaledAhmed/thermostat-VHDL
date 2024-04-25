# thermostat-VHDL:

1. [block_diagram](#blockDiagram)
2. [RTL_design_specifications](#RTLDesignSpecifications)


## <a name="blockDiagram">**block_diagram**</a>:
![block diagram](https://github.com/YoussefKhaledAhmed/thermostat_RTL-VHDL/assets/101673979/66cfcae3-75f7-4d98-865b-d14a71bfc146)

## <a name="RTLDesignSpecifications">**RTL_design_specifications**</a>:
1. adding all inputs and outputs to the entity:
   **inputs**:
     a. CURRENT_TEMP.
     b. DESIRED_TEMP.
     c. DISPLAY_SELECT.
     d. COOL.
     e. HEAT.
     f. FURNACE_HOT.
     g. AC_READY.
     h. CLK.
     i. RESET.
   **outputs**:
     a. TEMP_DISPLAY.
     b. A_C_ON.
     c. FURNACE_ON.
     d. FAN_ON.
2. registering all the ***inputs*** and ***outputs***.
3. ***TEMP_DISPLAY*** should be `one` of `two` values according to ***DISPLAY_SELECT*** value:
   a. CURRENT_TEMP: when `DISPLAY_SELECT = 1`.
   b. DESIRED_TEMP: when `DISPLAY_SELECT = 0`.
4. ***A_C_ON*** should be `high` when:
     a. ***COOL*** bit is high.
     b. ***DESIRED_TEMP*** is less than the ***CURRENT_TEMP***.
5. ***FURNACE_ON*** should be `high` when:
     a. ***HEAT*** bit is high.
     b. ***DESIRED_TEMP*** is higher than***CURRENT_TEMP***.
6. ***FAN_ON*** should be `high` when:
     a. ***FURNACE_HOT*** or the ***AC_READY*** is high.
     b. ***A_C_ON*** or ***FURNACE_ON*** is `high`.
7. adding counters:
     a. waiting ***20 clocks*** before allowing the ***A/C*** to be turned on again.
     b. waiting ***10 clocks*** before allowing the ***furnace*** to be turned on again.
8. Adding assert statements to verify that the requirements are met.

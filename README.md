# Memory Game FPGA Project

A “Simon-style” memory sequence game on FPGA: a random pattern of LED blinks grows each round, and the player must reproduce it via push-button switches. A seven-segment display shows the current score or “F”/“A” for failure/victory.

## Description

This project builds a hardware memory game using:

1. **Pattern generation**  
   A 22-bit Linear Feedback Shift Register (LFSR) produces a pseudo-random sequence. Every two bits map to one of four LEDs, creating a growing blink pattern up to a programmable length (default 7 steps).

2. **Pattern display & timing**  
   A `CountAndToggle` counter triggers precise on/off durations for each LED in the pattern (“Pattern Off” → “Pattern Show” states), with timing derived from the FPGA clock.

3. **Player input & scoring**  
   After showing the full pattern, the game enters “Wait Player.” Debounced button presses are checked against the stored pattern. Correct inputs advance the score (shown on the seven-segment), incorrect inputs end the game with an “F,” and reaching the final step yields an “A” for victory.

4. **Reset & replay**  
   A dedicated reset switch clears score and regenerates a new pattern, allowing endless replay.

## How It Works

- **Top-Level Integration**  
  The `MemoryGameTopLvl` module wires together:
  - Five instances of `DebounceFilter` (one per switch)  
  - The `StateMachineGame` core (driving LEDs & score logic)  
  - A `BinaryToSevSeg` converter for the seven-segment display  

- **State Machine**  
  A one-block FSM cycles through `START → PATTERN_OFF → SHOW_STEP → WAIT_PLAYER → [INCR_SCORE/LOSE/WIN]` using edge-detects on a slow toggle and valid-press flags.

- **Pattern Storage**  
  On reset, the LFSR seeds and writes pairs of bits into an array. The FSM indexes through this array to flash LEDs and to verify button inputs.

- **Timing Logic**  
  The `CountAndToggle` module, parameterized by `CLK_PER_SEC/4`, produces a slow “toggle” that the FSM watches to know when to advance states, ensuring consistent blink durations.

## Skills & Modules Used

- **Verilog/SystemVerilog** for RTL design  
- **Finite State Machines (FSMs)** using one-block `always` best practices  
- **Debouncing** mechanical switches with a counter-based filter  
- **Pseudo-random generation** via a 22-bit LFSR  
- **Parameterized timing** with `CountAndToggle`  
- **Seven-segment display driving** through binary→segment decoding  
- **Hierarchical design** and clean top-level integration  
- **Simulation & Testbench** development in ModelSim/Questa  

## Testing

Each core module was verified with SystemVerilog testbenches and waveform inspection:

1. **LFSR22 Module**  
   ![LFSR22 Testbench Waveform](images/lfsr_waveform.png)

2. **CountAndToggle Module**  
   ![CountAndToggle Testbench Waveform](images/count_and_toggle_waveform.png)

3. **StateMachineGame Module**  
   ![StateMachineGame Testbench Waveform](images/statemachinegame_waveform.png)

*(Replace `images/...` with your actual paths in the repository.)*  

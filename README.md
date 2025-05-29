# Memory Game FPGA Project

A “Simon-style” memory sequence game on FPGA: a random pattern of LED blinks grows each round, and the player must reproduce it using the corresponding switches. A seven-segment display shows the current score or “F”/“A” for failure/victory. Implemented on a Terasic DE10-Lite board; see the demonstration video on YouTube: https://youtu.be/kQlF9GM71I8?si=0GL5G2Z6p1wwK7_O

## Description

This project builds a hardware memory game using:

1. **Pattern generation**  
   A 22-bit Linear Feedback Shift Register (LFSR) generates a pseudo-random sequence. Every two bits map to one of four LEDs, creating a growing blink pattern up to a programmable length (default 7 steps).

2. **Pattern display & timing**  
   A counter toggles precise on/off durations for each LED in the pattern (“Pattern Off” → “Show Step” states), with timing derived from the DE10-Lite’s 50 MHz clock.

3. **Player input & scoring**  
   After showing the full pattern, the game enters “Wait Player.” Debounced button presses are checked against the stored pattern. Correct inputs increment the score (shown on the seven-segment), incorrect inputs end the game displaying an “F,” and reaching the final step displays an “A” for victory.

4. **Reset & replay**  
   A dedicated reset switch clears score and regenerates a new pattern, allowing endless replay.

## How It Works

- **Top-Level Integration**  
  The `MemoryGameTopLvl` module wires together:
  - Five instances of `DebounceFilter` (one per switch)  
  - The `StateMachineGame` instance (driving LEDs & score logic)  
  - A `BinaryToSevSeg` for the seven-segment display  

- **State Machine**  
  A one-block FSM cycles through `START → PATTERN_OFF → SHOW_STEP → WAIT_PLAYER → [INCR_SCORE/LOSE/WIN]` using edge-detects on a slow toggle and data-valid flags.

- **Pattern Storage**  
  On reset, the LFSR writes pairs of bits into an array. The FSM indexes through this array to flash LEDs and verify button inputs.

- **Timing Logic**  
  The `CountAndToggle` module, with the parameter `CLK_PER_SEC/4`, produces a slow “toggle” for the FSM to know when to advance states for consistent blink durations.

## Skills & Modules Used

- **Verilog/SystemVerilog** for RTL design  
- **Finite State Machines (FSMs)** using one-block `always` best practices  
- **Debouncing** mechanical switches with a counter-based filter  
- **Pseudo-random generation** using a 22-bit LFSR  
- **Parameterized timing** with `CountAndToggle`  
- **Seven-segment display driving** through binary to segment decoding  
- **Hierarchical design** and clean top-level integration
- **Simulation & Testbench** development in ModelSim 

## Testing

Each core module was verified with SystemVerilog testbenches and waveform inspection:

1. **LFSR22 Module**  
   ![LFSR22 Testbench Waveform](https://github.com/DanKim15/MemoryGame/blob/main/lfsr_waveform.png)

2. **CountAndToggle Module**  
   ![CountAndToggle Testbench Waveform](https://github.com/DanKim15/MemoryGame/blob/main/count_and_toggle_waveform.png)

3. **StateMachineGame Module**  
   ![StateMachineGame Testbench Waveform](https://github.com/DanKim15/MemoryGame/blob/main/statemachinegame_waveform.png)



**Intial State Machine Diagram**  
![State Machine Diagram](https://github.com/DanKim15/MemoryGame/blob/main/initial_statemachine_diagram.jpg)

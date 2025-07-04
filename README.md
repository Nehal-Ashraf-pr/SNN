
# Spiking Neural Network (SNN) Hardware Simulation

A Verilog-based digital hardware project simulating a multi-layer spiking neural network (SNN) for image input processing and neuromorphic computation.

---

## Features

- **Modular SNN Architecture:**  
  Includes programmable controller, stochastic spike generator, and parameterized neuron models.
- **Image-to-Spike Conversion:**  
  Converts RGB image data into spike trains using a 16-bit LFSR for randomness.
- **Layered Processing:**  
  Implements hidden and output neuron layers with configurable weights, bias, and thresholds.
- **Testbench Automation:**  
  Simulates video frame input, processes output, and writes results to PPM image files for easy verification.

---

## File Structure

| File              | Description                                      |
|-------------------|--------------------------------------------------|
| `Controller.v`    | Handles signal pipelines and layer-wise resets   |
| `gen_input.v`     | Generates stochastic spikes from RGB inputs      |
| `neuron.v`        | Biologically inspired spiking neuron model       |
| `snn_rgb.v`       | Top-level SNN system integrating all modules     |
| `sim_snn_rgb.v`   | Testbench for simulation and output monitoring   |

---

## Getting Started

### Prerequisites

- Verilog simulator (e.g., Icarus Verilog, ModelSim)
- [Optional] GTKWave for waveform viewing

### Running the Simulation

1. Place all Verilog source files in the same directory.
2. Compile and run the testbench:
   ```
   iverilog -o snn_sim sim_snn_rgb.v snn_rgb.v neuron.v gen_input.v Controller.v
   vvp snn_sim
   ```
3. View simulation output or generated `output.ppm` image.

---

## Project Status

This project is **ongoing** and under active development as part of academic research at Delhi Technological University (DTU).

---

## Reference

This project is inspired by and adapted from the open-source repository:  
**Marco-Winzker/Spiking_NN_RGB_FPGA – FPGA Design of a Spiking Neural Network**.

Please see the [original repository](https://github.com/Marco-Winzker/Spiking_NN_RGB_FPGA) for additional resources, documentation, and educational materials on SNN FPGA design.

### Citation

**APA:**  
Winzker, M. (2024, May 15). *Spiking_NN_RGB_FPGA* [FPGA Design of a Spiking Neural Network]. GitHub. https://github.com/Marco-Winzker/Spiking_NN_RGB_FPGA

**MLA:**  
Winzker, Marco. "Spiking_NN_RGB_FPGA." GitHub, 15 May 2024, https://github.com/Marco-Winzker/Spiking_NN_RGB_FPGA.

**IEEE:**  
M. Winzker, "Spiking_NN_RGB_FPGA," GitHub. [Online]. Available: https://github.com/Marco-Winzker/Spiking_NN_RGB_FPGA. [Accessed: July 5, 2025].


---

## Acknowledgements

- Inspired by neuromorphic hardware concepts and SNN research.
- Developed as part of a research initiative at DTU.
```

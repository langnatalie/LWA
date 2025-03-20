# Wideband THz Multi-User Downlink Communications with Leaky Wave Antennas

| ![Image 1](https://github.com/user-attachments/assets/ad019028-850c-4f47-9d6f-de61ebc0614d) | ![Image 2](https://github.com/user-attachments/assets/7407592d-522f-4aa8-969e-08b9ec1beb6a) |
|:----------------------:|:----------------------:|
| **Figure 1:** Beamforming of different frequency components using an LWA with plate separation $b$ and slit length $L$. | **Figure 2:** Downlink THz communications with a single LWA transmitting to $K$ users using $N$ frequency bins. |

## Introduction
In this work we propose _Wideband THz Multi-User Downlink Communications with Leaky Wave Antennas_, that explores the usage of the Leaky Wave Antennas (LWAs) for wideband downlink multi-
user THz communications. This repository contains a basic MATLAB implementation of if. Please refer to our [paper](https://arxiv.org/abs/2312.08833) for more details.

## Usage
This code has been tested on MATLAB R2024b Version 24.2.

### Prerequisite
1. Optimization Toolbox
2. Parallel Computing Toolbox
3. Global Optimization Toolbox
   
### Running
The main file is `LWAOpt_.m`. Before running it, add to path all folders of the project. This code will automatically save the content needed for latter plottings.

### Plotting
All plotting functions appear in the `plotting` folder. Load the needed data the has been saved, and provide it as argumets for the functions.

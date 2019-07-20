# trillionParticlesODEs
MATLAB script to simulate rate of uptake of nanoparticles from the blood into the liver, tumour, and other organs and their total accumulations over 24 hours

This MATLAB script solves the ODE posed by a compartment model of nanoparticle transport.

TumourLiverDose.m is a function called within simulate_TumourLiverDose.m

To run this file, set MATLAB path to both files (probably in the same folder), then run simulate_TumourLiverDose.m
*note there are two USER INPUTS that can be changed in simulate_TumourLiverDose.m
* 1. Dose can be toggled to a low dose or a high dose.
* 2. Output plot can be selected to be either uptake rate vs time or total uptake vs time.

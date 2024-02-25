# 2DEVS (2D Eikonal Vidale Solver)
## DESCRIPTION:

The scripts and files saved in the folder `originalMatlab` correspond to the Thesis Project I submitted to complete the Bachelor's Degree in Geophysical Engineering at the National Autonomous University of Mexico.

The original title, *Alternativa al trazado de rayos para el cálculo de tiempos de arribo de ondas sísmicas* (in Spanish), translates to *Raytracing alternative to computing travel times of seismic waves*.

The scripts calculate travel times of a seismic wave (head wave) in heterogeneous 2D mediums with Vidale (1988) approach by solving the *eikonal equation* using finite difference and geometrical approximations.

### Achievements
- The program proved to be an efficient and quick alternative to ray tracing.
- A detailed analysis of the numerical proposal, expanding on Vidale's notes and identifying scopes and limitations of his approach.
- Proposed strategies to overcome the above-mentioned limitations.
- A verification of Vidale's approach and examples in seismic prospection and seismology applications.


## PROJECT OBJECTIVES

The end goal is to translate the original code written in Matlab to Python.

Before achieving this it would be beneficial to go back and review the original literature as well as the written Thesis to understand the code better.

Once completed, this project will achieve the following objectives:

1) 2DEVS translated to Python (rename to 2DEVSpy?)
2) 2DEVS ability to work with SEG-Y files (a format better suited for this type of application)
    - What other formats should 2DEVS work with? (CSV? txt? What does a SEG-Y file exported to txt look like?)
3) A way of comparing the evolution of my coding skills from 2017 to present


## REFERENCES

- Vidale, J. (1988). Finite-difference calculation of travel times. Bulletin of the Seismological Society of America, 78 (6), 2062-2076
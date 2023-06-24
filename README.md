# Approximation of the cosine function using Taylor series - FPGA
### Miłosz Janik & Piotr Podkówka
### AGH SDUP Project
The aim of the project was to create software on the FPGA platform for calculating the approximate value of the cosine function in the range from 0 to 90 degrees using the Taylor series.

The project was implemented in two alternative versions. The first is to use the taylor_rtl module, which is based on the classic Taylor formula for approximating the cosine function. The second uses the taylor_horner_rtl module, which uses Horner's rule to reduce the number of multiplications performed.

![formulas](https://github.com/mijanik/TaylorCos/blob/main/images/formulas.png)

Forms of formulas used for approximation in modules taylor_rtl and taylor_horner_rtl

High-precision calculations were used, based on data in the Fixed-Point representation [12:10]. The modules have a sequential mode of operation and their state diagram is included in the further part of the description. Considering hardware resources, values 1/n! have been previously prepared and saved in binary Fixed Point form or implemented with use of bit shifts.

![FSMD Taylor](https://github.com/mijanik/TaylorCos/blob/main/images/taylor_fsmd.png)

FSMD state machine for the taylor_rtl module, without using Horner's rule

[Short presentation video](drive.google.com/file/d/15-wdSZD2HDbZ2N2pl6DcoiQvqIsFRjsE)

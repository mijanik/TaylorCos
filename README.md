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

![FSMD Horner](https://github.com/mijanik/TaylorCos/blob/main/images/horner_fsmd.png)

FSMD state machine for the taylor_rtl module, with usage of Horner's rule

Results:

![Putty](https://github.com/mijanik/TaylorCos/blob/main/images/putty.png)

To check the correct operation of the module, an ARM microcontroller was used, communicating with the module via the AXI bus. Using the Vivado SDK, an application was created in the C language, which, via the UART interface, allows the user to calculate the value of the cosine function for an angle in the range of 0 to 360 degrees.

![Chart](https://github.com/mijanik/TaylorCos/blob/main/images/chart.png)

The graph above shows a comparison of the function approximation values using modules using the classic Taylor formula and its transformation, according to Horner's rule. For angles greater than 70°, it can be seen that the module using Horner's rule inaccurately approximates the cosine function. As this angle increases, the error value also increases. The module using the classic Taylor formula works very precisely. The difference in performance may be due to a different order of operations, which resulted in numerical errors and loss of accuracy.

[Short presentation video](https://drive.google.com/file/d/15-wdSZD2HDbZ2N2pl6DcoiQvqIsFRjsE)

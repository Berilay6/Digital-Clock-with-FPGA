# Digital-Clock-with-FPGA

## 1. Project Overview

This project implements a digital calendar and clock system on an FPGA. The system includes time components such as seconds, minutes, hours, days, months, and years. Users can adjust the time and date settings using increment and decrement buttons. Additionally, the system allows users to control the clock speed and pause the time.

The design consists of modular components, each controlling a specific time element. Each module updates its respective time component based on input signals.

### Digital_Calendar Module
This is the main module that integrates all the other time modules in a synchronized manner. It processes user inputs from buttons and sends appropriate signals to the corresponding modules. It also handles pausing the system and preparing data for the seven-segment display.

### Seconds Module
This module controls the seconds component:
- Increments the seconds value every clock pulse.
- Resets to `00` and sends a "minute increment" signal when it reaches `59`.
- Allows clock speed control for faster or slower operation.
- Default starting value: `00`.

### Minutes Module
This module controls the minutes component:
- Increments or decrements the value based on signals from buttons.
- Resets to `00` and sends an "hour increment" signal when it reaches `59`.
- Rolls back to `59` if decremented below `0` and sends an "hour decrement" signal.
- Default starting value: `30`.

### Hours Module
This module controls the hours component:
- Resets to `00` and sends a "day increment" signal when it reaches `23`.
- Rolls back to `23` if decremented below `0` and sends a "day decrement" signal.
- Hours can be adjusted using increment or decrement buttons.
- Default starting value: `18`.

### Day, Month, and Year Module
These modules manage the calendar information:
- Automatically update based on signals from the hours component.
- Each month is set to have 30 days, with 360 days (12 months) in a year.
- Default starting date: `01.01.2024`.

---

## 2. Design Details and FPGA Integration

The digital calendar module interacts with the FPGA using additional support modules to process inputs and outputs effectively.

### Debouncer Module
This module removes noise from user button inputs to ensure accurate signal processing.

### Seven-Segment Display Module
This module:
- Converts time values (e.g., hours and minutes) into decimal numbers.
- Generates 7-bit output for each segment of the display.
- Uses a counter and millisecond signals to select which digit is displayed.

### BASYS3.xdc (Constraints File)
This file defines the input and output constraints for FPGA communication with the digital calendar module.
Leds count the seconds in binary
Buttons can set or stop the clock
Switches can make you control the seconds and speed the clock

---

## 3. Conclusion

This project successfully implements a digital calendar and clock system on an FPGA. Users can pause, reset, adjust the speed, and modify time and date settings easily. 

Thanks to its modular design:
- Each time component operates independently.
- The system is flexible, extendable, and easy to understand.

The project demonstrates the effective use of FPGA for real-time clock and calendar management.

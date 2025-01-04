# Playing-WAV-files-on-an-FPGA
# ALL FILES ON THE MASTER BRANCH!!
For use in doing PWM based audio on an FPGA.

Verilog files have a pwm driver. Change the bram instantiation to use the coe file you want. You can generate a .COE file using the wavPlayerHelper.ipynb which will walk you through the conversion of a .wav file to a .coe file.

If you need to create a digital filter for your audio, the digitalFilterHelper.ipynb will guide you through that process as well. A digital filter is already set up in verilog for you if you just want to use that one.

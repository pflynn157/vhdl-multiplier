
## VHDL Multiplier

This is a simple VHDL multiplier for 8-bit numbers. There are two multipliers right now: A 1-stage and 2-stage multiplier.

The 1-stage multiplier is the simplest in terms of components, but it is extremely slow, taking 25 clock cycles (250 ns) to compute the product. 

The 2-stage multiplier attempts to do two operations on each stage; it has significantly better performance than the one-stage, taking 13 clock cycles (130 ns) to compute the product. However, it is also more complex because it requires extra signals and two of every component (x2 right shifters, x2 left shifters, and x3 adders).

I also have an experimental exponent solving circuit. When I say experimental, I very much mean that. Its extremely inefficient; it uses one of the multipliers to continually multiply based on the exponent provided until it is solved. The result of this is that it takes a very long time in terms of clock cycles. There's also an issue with one of the multipliers that I really can't figure out at the moment where it won't clear and work properly after the first round of solving.

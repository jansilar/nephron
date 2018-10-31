within Nephron;

model OsmoticSource
  Physiolibrary.Osmotic.Interfaces.OsmoticPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {0, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter PLT.VolumeFlowRate Q "water flow";
  parameter PLT.Concentration o "osmolarity";
equation
  port_b.q = -Q;
  port_b.o = o;
annotation(
    Icon(graphics = {Rectangle(lineColor = {252, 233, 79}, fillColor = {252, 233, 79}, fillPattern = FillPattern.Solid, extent = {{-80, 80}, {80, -80}})}));end OsmoticSource;
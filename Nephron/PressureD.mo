within Nephron;

model PressureD
  parameter Real dP(unit="Pa") = 0 "pressure difference";
  Physiolibrary.Hydraulic.Interfaces.HydraulicPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {-50, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Interfaces.HydraulicPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {50, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {70, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  port_a.q + port_b.q = 0;
  port_b.pressure - port_a.pressure = dP;

annotation(
    Icon(graphics = {Rectangle(origin = {-11, 21}, lineColor = {114, 159, 207}, fillColor = {114, 159, 207}, fillPattern = FillPattern.Solid, extent = {{-29, 59}, {51, -101}}), Ellipse(origin = {-20, 81}, lineColor = {114, 159, 207}, fillColor = {52, 101, 164}, fillPattern = FillPattern.Solid, extent = {{-20, 7}, {60, -9}}, endAngle = 360), Ellipse(origin = {-20, -80}, lineColor = {114, 159, 207}, fillColor = {114, 159, 207}, fillPattern = FillPattern.Solid, extent = {{-20, 7}, {60, -7}}, endAngle = 360), Rectangle(origin = {55, 76}, lineColor = {114, 159, 207}, fillColor = {114, 159, 207}, fillPattern = FillPattern.Solid, extent = {{-15, 4}, {15, -4}}), Rectangle(origin = {-55, -76}, lineColor = {114, 159, 207}, fillColor = {114, 159, 207}, fillPattern = FillPattern.Solid, extent = {{-15, 4}, {15, -4}}), Text(origin = {-13, 31}, extent = {{-15, 17}, {39, -81}}, textString = "deltaP")}, coordinateSystem(initialScale = 0.1)));end PressureD;
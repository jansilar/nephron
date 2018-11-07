within Nephron.Models;

model Nephron
  parameter Integer NNep = 2000000 "total nephron count";
  parameter Real GFR = 180 "[l/day] total GFR";
  parameter PLT.VolumeFlowRate GFR1 = GFR/1000/24/60/NNep "GFR per nephron";
  Components.OsmoticSource glomerulus(Q(displayUnit = "m3/s") = GFR1, o = 300)  annotation(
    Placement(visible = true, transformation(origin = {-26, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.DLOH dloh annotation(
    Placement(visible = true, transformation(origin = {24, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.OsmoticDrain drain annotation(
    Placement(visible = true, transformation(origin = {24,-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.PT pt annotation(
    Placement(visible = true, transformation(origin = {8, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(glomerulus.port_b, pt.port_in) annotation(
    Line(points = {{-16, 60}, {-2, 60}, {-2, 60}, {0, 60}}, color = {127, 127, 0}));
  connect(pt.port_out, dloh.port_in) annotation(
    Line(points = {{18, 60}, {24, 60}, {24, 44}, {24, 44}}, color = {127, 127, 0}));
  connect(dloh.port_out, drain.port_a) annotation(
    Line(points = {{24, 25}, {24, -7}}, color = {127, 127, 0}));
end Nephron;
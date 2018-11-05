within Nephron;

model NephronModel
  parameter Integer NNep = 2000000 "total nephron count";
  parameter Real GFR = 180 "[l/day] total GFR";
  parameter PLT.VolumeFlowRate GFR1 = GFR/1000/24/60/NNep "GFR per nephron";
  OsmoticSource glomerulus(Q(displayUnit = "m3/s") = GFR1, o = 300)  annotation(
    Placement(visible = true, transformation(origin = {-16, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  DLOH dloh annotation(
    Placement(visible = true, transformation(origin = {-16, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OsmoticDrain drain annotation(
    Placement(visible = true, transformation(origin = {-16, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(dloh.port_out, drain.port_a) annotation(
    Line(points = {{-16, 18}, {-16, 18}, {-16, 2}, {-16, 2}}, color = {127, 127, 0}));
  connect(glomerulus.port_b, dloh.port_in) annotation(
    Line(points = {{-16, 52}, {-16, 52}, {-16, 38}, {-16, 38}}, color = {127, 127, 0}));
end NephronModel;
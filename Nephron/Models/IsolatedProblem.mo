within Nephron.Models;

model IsolatedProblem
  parameter Real gfr_mod = 1;
  inner Nephron.Components.NephronParameters nephronPar annotation(
    Placement(visible = true, transformation(origin = {84, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.OsmoticSource glomerulus(Q(displayUnit = "m3/s") = 9e-14, o = 100)   annotation(
    Placement(visible = true, transformation(origin = {-96, 16}, extent = {{-4, -4}, {4, 4}}, rotation = 90)));
  Nephron.Components.OsmoticDrain osmoticDrain annotation(
    Placement(visible = true, transformation(origin = {66, -47}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Nephron.Components.DT dt(N=15) annotation(
    Placement(visible = true, transformation(origin = {34, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  connect(dt.port_out, osmoticDrain.port_a) annotation(
    Line(points = {{44, 18}, {66, 18}, {66, -44}, {66, -44}, {66, -44}}, color = {127, 127, 0}));
  connect(glomerulus.port_b, dt.port_in) annotation(
    Line(points = {{-92, 16}, {24, 16}, {24, 18}, {26, 18}}, color = {127, 127, 0}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.05));
end IsolatedProblem;
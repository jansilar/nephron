within Nephron.Tests;

model ClosedTubuleTest
  Nephron.Tests.ClosedTubule closedTubule1 annotation(
    Placement(visible = true, transformation(origin = {10, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OsmoticDrain osmoticDrain1 annotation(
    Placement(visible = true, transformation(origin = {10, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.OsmoticSource osmoticSource1(Q = 1.66667e-8, o = 0.5)  annotation(
    Placement(visible = true, transformation(origin = {10, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(osmoticSource1.port_b, closedTubule1.port_in) annotation(
    Line(points = {{10, 24}, {10, 24}, {10, 6}, {10, 6}}, color = {127, 127, 0}));
  connect(closedTubule1.port_out, osmoticDrain1.port_a) annotation(
    Line(points = {{10, -12}, {10, -12}, {10, -32}, {10, -32}}, color = {127, 127, 0}));
end ClosedTubuleTest;
within Nephron.Tests;

model TubuleConstFTest
  OsmoticSource osmoticSource1(Q(displayUnit = "ml/min") = 1.66667e-8, o(displayUnit = "mmol/l") = 300)  annotation(
    Placement(visible = true, transformation(origin = {-14, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Tests.TubuleConstF tubuleConstF1(f_H2O_const = 0, f_Na_const (displayUnit = "mmol/(min.m)") = 1.66667e-5)  annotation(
    Placement(visible = true, transformation(origin = {-14, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OsmoticDrain osmoticDrain1 annotation(
    Placement(visible = true, transformation(origin = {-14, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(tubuleConstF1.port_out, osmoticDrain1.port_a) annotation(
    Line(points = {{-14, 22}, {-14, 22}, {-14, -4}, {-14, -4}}, color = {127, 127, 0}));
  connect(osmoticSource1.port_b, tubuleConstF1.port_in) annotation(
    Line(points = {{-14, 56}, {-14, 39}}, color = {127, 127, 0}));
end TubuleConstFTest;
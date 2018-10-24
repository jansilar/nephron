within Nephron.Tests;

model DLH_test
  Nephron.DLOH dloh annotation(
    Placement(visible = true, transformation(origin = {8, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Osmotic.Sources.UnlimitedSolution unlimitedSolution1(Osm = 300)  annotation(
    Placement(visible = true, transformation(origin = {-40, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Osmotic.Components.SolventFlux solventFlux1(SolutionFlow = 1.04167e-12)  annotation(
    Placement(visible = true, transformation(origin = {-12, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.OsmoticDrain osmoticDrain1 annotation(
    Placement(visible = true, transformation(origin = {8, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(dloh.port_out, osmoticDrain1.port_a) annotation(
    Line(points = {{8, -8}, {8, -8}, {8, -14}, {8, -14}}, color = {127, 127, 0}));
  connect(solventFlux1.q_out, dloh.port_in) annotation(
    Line(points = {{-2, 32}, {8, 32}, {8, 9}}, color = {127, 127, 0}));
  connect(unlimitedSolution1.port, solventFlux1.q_in) annotation(
    Line(points = {{-30, 32}, {-26, 32}, {-26, 32}, {-22, 32}, {-22, 32}}, color = {127, 127, 0}));
end DLH_test;
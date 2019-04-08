within Nephron.Tests;

model AveCOPTest
  Components.AveCOP aveCOP1 annotation(
    Placement(visible = true, transformation(origin = {0, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant RBF(k = 1.2 / 60)  annotation(
    Placement(visible = true, transformation(origin = {-68, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant GFR(k = 0.125 / 60)  annotation(
    Placement(visible = true, transformation(origin = {-68, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(GFR.y, aveCOP1.inputGFR) annotation(
    Line(points = {{-56, -30}, {-40, -30}, {-40, -4}, {-10, -4}, {-10, -4}}, color = {0, 0, 127}));
  connect(RBF.y, aveCOP1.inputRBF) annotation(
    Line(points = {{-56, 38}, {-40, 38}, {-40, 10}, {-10, 10}, {-10, 10}}, color = {0, 0, 127}));
end AveCOPTest;
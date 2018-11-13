within Nephron.Components;

model CD
  extends Nephron.Components.Partial.TubuleADH(L=0.04,k_H2O = 6.0e-15);
equation
  o_medulla = linspace(nephronPar.o_plasma_norm,nephronPar.o_max,N+1);

annotation(
    Icon(graphics = {Text(origin = {-18, -17}, rotation = -90, extent = {{-48, 47}, {22, -15}}, textString = "CD"), Line(origin = {47, -2}, points = {{-19, 0}, {19, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Open}, arrowSize = 12), Text(origin = {83, -2}, rotation = -90, extent = {{-29, 14}, {29, -14}}, textString = "H2O")}, coordinateSystem(initialScale = 0.1)));end CD;
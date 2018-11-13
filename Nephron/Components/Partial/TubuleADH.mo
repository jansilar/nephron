within Nephron.Components.Partial;

partial model TubuleADH
  extends Nephron.Components.Partial.Tubule;
  PLT.Concentration[N+1] o_medulla(each start = 300, each fixed = false) "osmolarity";
  parameter Real k_H2O = 7.0e-14 "tubule permeablilit for H2O";
  Real[N] testVal;
equation
  for i in 1:N loop
    f_H2O[i] = nephronPar.ADH*k_H2O * (o_medulla[i+1] + o_medulla[i] - o[i + 1] - o[i]) / 2.0;
    testVal[i] = (o_medulla[i+1] + o_medulla[i] - o[i + 1] - o[i]) / 2.0;
  end for;
  f_Na = zeros(N);
  annotation(
    Icon(graphics = {Line(origin = {47, -2}, points = {{-19, 0}, {19, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Open}, arrowSize = 12), Text(origin = {83, -2}, rotation = -90, extent = {{-29, 14}, {29, -14}}, textString = "H2O")}, coordinateSystem(initialScale = 0.1)));
end TubuleADH;
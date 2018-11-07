within Nephron.Components;

model PT
  extends Partial.Tubule(L = 0.05);
  Types.VolumeFlowRateLinearDensity f_H2O_const = Q[1]/L*k_reabs;
  parameter Real k_reabs = 2.0/3.0;
equation
  o[2:N+1] = ones(N)*o[1];
  f_H2O = ones(N)*f_H2O_const;


annotation(
    Icon(graphics = {Text(origin = {8, -19}, rotation = 90, extent = {{-20, -17}, {46, 35}}, textString = "PT"), Line(origin = {30, -10}, points = {{-16, 0}, {30, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Open}), Text(origin = {73, -22}, rotation = 90, extent = {{-23, 14}, {41, -32}}, textString = "H2O+Na")}));

end PT;
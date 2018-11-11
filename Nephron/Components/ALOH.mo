within Nephron.Components;

model ALOH
  extends Nephron.Components.Partial.Tubule(L=0.04);
  parameter PLT.VolumeFlowRate Q_in_norm = nephronPar.GFR1_norm/3*nephronPar.o_plasma_norm/nephronPar.o_max;
  parameter Types.MolarFlowRateLinearDensity f_Na_const = Q_in_norm*(nephronPar.o_max-nephronPar.o_dt_norm)/L;
  
equation
  f_H2O = zeros(N);
  f_Na = ones(N)*f_Na_const;

annotation(
    Icon(graphics = {Text(origin = {-5, -4}, rotation = 90, extent = {{-73, 18}, {77, -28}}, textString = "ALOH"), Line(origin = {-38, -11.05}, points = {{17.9969, 9.05216}, {-18.0031, 9.05216}}, thickness = 1, arrow = {Arrow.None, Arrow.Open}, arrowSize = 12), Text(origin = {-78, -7}, extent = {{-26, 41}, {22, -27}}, textString = "Na")}, coordinateSystem(initialScale = 0.1)));
end ALOH;
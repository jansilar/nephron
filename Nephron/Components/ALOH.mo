within Nephron.Components;

model ALOH
function LimitFactor
  input Real o;
  input Real o_treshold;
  output Real fac;
algorithm
  fac := max(0.0,min(1.0, o/o_treshold));
end LimitFactor;

model LimitFactorTest
  Real o = time - 1;
  Real fac = LimitFactor(o, 5);
end LimitFactorTest;

  extends Nephron.Components.Partial.Tubule(L=0.04, N=40);
  constant Integer NDLOH = 10;
  parameter PLT.VolumeFlowRate Q_in_norm = nephronPar.GFR1_norm/3*nephronPar.o_plasma_norm/nephronPar.o_max;
  parameter Types.MolarFlowRateLinearDensity f_Na_const = Q_in_norm*(nephronPar.o_max-nephronPar.o_dt_norm)/L;
  PLT.VolumeFlowRate[NDLOH+1] Qhelp = {Q[1 + integer((i-1)*N/NDLOH+0.5)] for i in 1:NDLOH+1};
  PLT.Concentration[NDLOH+1] oheplp = {o[1 + integer((i-1)*N/NDLOH+0.5)] for i in 1:NDLOH+1};
equation
  f_H2O = zeros(N);
  f_Na = f_Na_const*{LimitFactor(o[i],100) for i in 1:N}; 

annotation(
    Icon(graphics = {Text(origin = {-5, -4}, rotation = 90, extent = {{-73, 18}, {77, -28}}, textString = "ALOH"), Line(origin = {-38, -11.05}, points = {{17.9969, 9.05216}, {-18.0031, 9.05216}}, thickness = 1, arrow = {Arrow.None, Arrow.Open}, arrowSize = 12), Text(origin = {-78, -7}, extent = {{-26, 41}, {22, -27}}, textString = "Na")}, coordinateSystem(initialScale = 0.1)));
end ALOH;
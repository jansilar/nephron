within Nephron.Components;

model ALOH
  extends Nephron.Components.Partial.Tubule(L=0.04, N=40);
  parameter PLT.Concentration oMed[N+1] = linspace(nephronPar.o_max,nephronPar.o_plasma_norm,N+1);
  parameter Real oMaxDif = 200;
  parameter Real f_Na_mod = 1.17;
  constant Integer NDLOH = 10;
  parameter PLT.VolumeFlowRate Q_in_norm = nephronPar.GFR1_norm/3*nephronPar.o_plasma_norm/nephronPar.o_max;
  parameter Types.MolarFlowRateLinearDensity f_Na_const = f_Na_mod*Q_in_norm*(nephronPar.o_max-nephronPar.o_dt_norm)/L;
  PLT.VolumeFlowRate[NDLOH+1] Qhelp = {Q[1 + integer((i-1)*N/NDLOH+0.5)] for i in 1:NDLOH+1};
  PLT.Concentration[NDLOH+1] oheplp = {o[1 + integer((i-1)*N/NDLOH+0.5)] for i in 1:NDLOH+1};
equation
  f_H2O = zeros(N);
algorithm
  for i in 1:N loop
    f_Na[i] := min(f_Na_const, Q[i]*(oMaxDif + o[i] - oMed[min(i+1,N+1)])/dx);
  end for;
  
annotation(
    Icon(graphics = {Text(origin = {-5, -4}, rotation = 90, extent = {{-73, 18}, {77, -28}}, textString = "ALOH"), Line(origin = {-38, -11.05}, points = {{17.9969, 9.05216}, {-18.0031, 9.05216}}, thickness = 1, arrow = {Arrow.None, Arrow.Open}, arrowSize = 12), Text(origin = {-78, -7}, extent = {{-26, 41}, {22, -27}}, textString = "Na")}, coordinateSystem(initialScale = 0.1)));
end ALOH;
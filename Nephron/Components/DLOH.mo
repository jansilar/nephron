within Nephron.Components;

model DLOH
  extends Partial.Tubule(L=0.04);
  parameter PLT.Concentration oPlasma = nephronPar.o_plasma_norm "osmolarity of plasma";
  parameter PLT.Concentration oMax = nephronPar.o_max "maximal osmolarity at turn of LOH";
  PLT.Concentration oMed[N+1] = linspace(oPlasma,oMax,N+1);
equation
  f_Na = zeros(N) "impermeable for Na";
  o[2:N+1] = oMed[2:N+1] "wather leavs the tubule so that osmolarity equalizes with medula";

annotation(
    Icon(graphics = {Line(origin = {38.8, -8.75}, rotation = -90, points = {{-3.14373, 20.6756}, {-3.14373, -21.3244}}, thickness = 1, arrow = {Arrow.Open, Arrow.None}, arrowSize = 12), Text(origin = {80, -5}, extent = {{-20, 33}, {20, -33}}, textString = "H2O"), Text(origin = {-1, -7}, rotation = 90, extent = {{-25, 43}, {25, -43}}, textString = "DLOH", fontSize = 24)}, coordinateSystem(initialScale = 0.1)));

end DLOH;
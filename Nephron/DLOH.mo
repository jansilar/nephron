within Nephron;

model DLOH
  extends Nephron.Partial.Tubule(L=1);
  parameter PLT.Concentration oPlasma = 300 "osmolarity of plasma";
  parameter PLT.Concentration oMax = 1200 "maximal osmolarity at turn of LOH";
  PLT.Concentration oMed[N] = linspace(oPlasma,oMax,N);
equation
  f_Na = zeros(N) "impermeable for Na";
  o = oMed "wather leavs the tubule so that osmolarity equalizes with medula";

annotation(
    Icon(graphics = {Line(origin = {38.8, -8.75}, rotation = -90, points = {{-3.14373, 20.6756}, {-3.14373, -21.3244}}, thickness = 1, arrow = {Arrow.Open, Arrow.None}), Text(origin = {80, -5}, extent = {{-20, 33}, {20, -33}}, textString = "H2O"), Text(origin = {-1, -7}, rotation = 90, extent = {{-25, 43}, {25, -43}}, textString = "DLOH", fontSize = 24)}));end DLOH;
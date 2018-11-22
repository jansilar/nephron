within Nephron.Components;

model DT
  extends Nephron.Components.Partial.TubuleADH(L=0.01);
initial equation
  o_medulla = ones(N+1)*nephronPar.o_plasma_norm;
  
annotation(
    Icon(graphics = {Text(origin = {-18, -17}, rotation = -90, extent = {{-48, 47}, {22, -15}}, textString = "DT")}, coordinateSystem(initialScale = 0.1)));end DT;
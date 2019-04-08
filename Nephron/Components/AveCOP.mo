within Nephron.Components;

model AveCOP "calculates avarage coloid osmotic pressure in glomerulus"
  Modelica.Blocks.Interfaces.RealInput inputGFR annotation(
    Placement(visible = true, transformation(origin = {-74, 84}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-92, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput inputRBF annotation(
    Placement(visible = true, transformation(origin = {-102, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-96, 72}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput outputCOP = aveCOP*tor2pasc annotation(
    Placement(visible = true, transformation(origin = {98, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {98, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Real GFR = inputGFR*1000*60;
  Real RBF = inputRBF*1000*60;
  Real aveCOP = (ACOP + ECOP)/2.0;
  Real ACOP = (A*APr + B*APr^2) "Afferent coloid osmotic pressure";
  Real ECOP = (A*EPr + B*EPr^2) "Efferent coloid osmotic pressure";
  parameter Real A = 320 "mmHg/(G/mL) Landis - Pappernheimer linear Coefficient";
  parameter Real B = 1160 "mmHg/(G/mL)^2 Landis - Pappernheimer quadratic Coefficient";
  parameter Real APr = 0.07 "G/mL afferent protein concentration";
  Real EPr(start = 0.09) = APr/(1-FF) "G/mL efferent protein concentration";
  Real FF = GFR/RPF "filtration fraction";
  Real RPF = RBF*(1-Hct) "renal plasma flow";
  parameter Real Hct = 0.44 "hematocryt";
  

  annotation(
    Icon(graphics = {Rectangle(origin = {3, 2}, lineColor = {252, 233, 79}, fillColor = {252, 233, 79}, fillPattern = FillPattern.Solid, extent = {{-89, 88}, {89, -88}}), Text(origin = {0, 1}, extent = {{-92, 79}, {92, -79}}, textString = "COP")}));end AveCOP;
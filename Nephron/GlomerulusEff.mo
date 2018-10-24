within Nephron;

model GlomerulusEff
  import PLT = Physiolibrary.Types;
  constant Real tor2pasc = 133.322387415;
  //hydrostatic pressures:
  parameter PLT.Pressure MAP = 84 * tor2pasc "blood pressure befor afferent arteriole, https://en.wikipedia.org/wiki/Blood_pressure, https://www.omnicalculator.com/health/mean-arterial-pressure";
  parameter PLT.Pressure CVP = 6 * tor2pasc "blood pressure after efferent arteriole, https://en.wikipedia.org/wiki/Central_venous_pressure";
  parameter PLT.Pressure P_bowm = 10 * tor2pasc "primary urine pressure in bowman capsule, papír od Honzy Živnýho";
  parameter PLT.Pressure normal_P_Filter = 6 * tor2pasc "normal filtration pressure, papír od HŽ";
  parameter PLT.Pressure normal_P_Glom = normal_P_Filter + P_bowm + pi_blood - pi_bowm "hydrostatic pressure in glomerular capilaries";
  //oncotic pressures:
  parameter PLT.Pressure pi_bowm = 0 "Oncotic pressure of primary urine, říkal Honza Živný";
  parameter PLT.Pressure pi_blood = 30 * tor2pasc "oncotic pressure of blood, papír od HŽ, 28 v en.wikipedia.org/wiki/Oncotic_pressure";
  //volumetric fluxes:
  parameter PLT.VolumeFlowRate CO = 5 / 60 / 1000 "cardiac output";
  parameter PLT.VolumeFlowRate RBF1 = CO * 0.2 / N "blood flow into each glomerulus";
  parameter PLT.VolumeFlowRate GFR1 = 180 / 1000 / 24 / 60 / 60 / N "primary urine production per each nephron";
  //resistances:
  parameter PLT.HydraulicResistance R_aff = (MAP - normal_P_Glom) / RBF1 "afferent arteriol resistance";
  parameter PLT.HydraulicResistance R_eff = (normal_P_Glom - CVP) / (RBF1 - GFR1) "efferent arteriol resistance";
  parameter PLT.HydraulicResistance R_filter = normal_P_Filter / GFR1 "efferent arteriol resistance";
  //other:
  parameter PLT.Density rho = 1060 "blood density";
  parameter PLT.Acceleration g = 9.8 "gravitational acceleration";
  parameter Integer N = 2000000 "Number of nephrones in both kidneys";
  //components:
  Physiolibrary.Hydraulic.Components.Resistor efferentResistance(Resistance = R_eff) annotation(
    Placement(visible = true, transformation(origin = {-54, -14}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodDrain(P(displayUnit = "Pa") = CVP) annotation(
    Placement(visible = true, transformation(origin = {-32, -68}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume glomerulusPress(P = normal_P_Glom)  annotation(
    Placement(visible = true, transformation(origin = {-72, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation

equation
  connect(glomerulusPress.y, efferentResistance.q_in) annotation(
    Line(points = {{-62, 44}, {-54, 44}, {-54, -4}, {-54, -4}}));
  connect(efferentResistance.q_out, bloodDrain.y) annotation(
    Line(points = {{-54, -24}, {-54, -68}, {-42, -68}}));
  annotation(
    uses(Physiolibrary(version = "2.3.2-beta")));
end GlomerulusEff;
within Nephron.Tests.GlomerulusTests;

model GlomerulusAff
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
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodSource(P(displayUnit = "Pa") = MAP) annotation(
    Placement(visible = true, transformation(origin = {-82, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Resistor afferentResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_aff) annotation(
    Placement(visible = true, transformation(origin = {-54, 26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume glomPress(P = normal_P_Glom)  annotation(
    Placement(visible = true, transformation(origin = {-78, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation

equation
  connect(afferentResistance.q_out, glomPress.y) annotation(
    Line(points = {{-54, 16}, {-54, 16}, {-54, -28}, {-68, -28}, {-68, -28}}));
  connect(bloodSource.y, afferentResistance.q_in) annotation(
    Line(points = {{-72, 56}, {-63, 56}, {-63, 56}, {-54, 56}, {-54, 36}}));
  annotation(
    uses(Physiolibrary(version = "2.3.2-beta")));
end GlomerulusAff;

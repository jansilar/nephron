within Nephron.Models;

model Glomerulus
  constant Real tor2pasc = 133.322387415;
//hydrostatic pressures:
  parameter PLT.Pressure MAP_norm = 84 * tor2pasc "blood pressure befor afferent arteriole, https://en.wikipedia.org/wiki/Blood_pressure, https://www.omnicalculator.com/health/mean-arterial-pressure";
  parameter Real MAP_mod = 1;
  parameter PLT.Pressure MAP = MAP_mod*84 * tor2pasc "blood pressure befor afferent arteriole, https://en.wikipedia.org/wiki/Blood_pressure, https://www.omnicalculator.com/health/mean-arterial-pressure";
  parameter PLT.Pressure P_diff_a = MAP - pi_blood "hydrostatic minus oncotic arterial pressure";
  parameter PLT.Pressure CVP = 6 * tor2pasc "blood pressure after efferent arteriole, https://en.wikipedia.org/wiki/Central_venous_pressure";
  parameter PLT.Pressure P_diff_e = CVP - pi_blood "hydrostatic minus oncotic venous pressure";
  parameter PLT.Pressure P_bowm = 10 * tor2pasc "primary urine pressure in bowman capsule, papír od Honzy Živnýho";
  parameter PLT.Pressure normal_P_Filter = 6*tor2pasc "normal filtration pressure, papír od HŽ";
  parameter PLT.Pressure normal_P_Glom = normal_P_Filter + P_bowm + pi_blood - pi_bowm "hydrostatic pressure in glomerular capilaries";
  
//oncotic pressures:
  parameter PLT.Pressure pi_bowm = 0 "Oncotic pressure of primary urine, říkal Honza Živný";
  parameter PLT.Pressure pi_blood = 30 * tor2pasc "oncotic pressure of blood, papír od HŽ, 28 v en.wikipedia.org/wiki/Oncotic_pressure";

//volumetric fluxes:
  parameter PLT.VolumeFlowRate CO = 5 / 60 / 1000 "cardiac output";
  parameter PLT.VolumeFlowRate RBF1 = CO * 0.2 / N "blood flow into each glomerulus";
  parameter PLT.VolumeFlowRate GFR1 = 180 / 1000 / 24 / 60 / 60 / N "primary urine production per each nephron";

//resistances:
  parameter Real R_aff_mod = 1;
  parameter Real R_eff_mod = 1;
  parameter PLT.HydraulicResistance R_aff = R_aff_mod*(MAP_norm-normal_P_Glom)/RBF1 "afferent arteriol resistance";
  parameter PLT.HydraulicResistance R_eff = R_eff_mod*(normal_P_Glom - CVP)/(RBF1 - GFR1) "efferent arteriol resistance";
  parameter PLT.HydraulicResistance R_filter = normal_P_Filter/GFR1 "efferent arteriol resistance";
  
//other:
  parameter PLT.Density rho = 1060 "blood density";
  parameter PLT.Acceleration g = 9.8 "gravitational acceleration";
  parameter Integer N = 2000000 "Number of nephrones in both kidneys";

//components:
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodSource(P (displayUnit = "Pa") = MAP)  annotation(
    Placement(visible = true, transformation(origin = {-82, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Resistor afferentResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_aff) annotation(
    Placement(visible = true, transformation(origin = {-40, 26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Components.Resistor efferentResistance(Resistance (displayUnit = "(Pa.s)/m3") = R_eff)  annotation(
    Placement(visible = true, transformation(origin = { -40, -14}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodDrain(P(displayUnit = "Pa") = CVP)  annotation(
    Placement(visible = true, transformation(origin = {-18, -64}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Resistor filterResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_filter)  annotation(
    Placement(visible = true, transformation(origin = {10, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume urineDrain(P(displayUnit = "Pa") = P_bowm)  annotation(
    Placement(visible = true, transformation(origin = {88, 8}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Nephron.Components.PressureD osmoticBlood(dP = -pi_blood)  annotation(
    Placement(visible = true, transformation(origin = {-16, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.PressureD pressureD1(dP = -pi_bowm)  annotation(
    Placement(visible = true, transformation(origin = {66, 16}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sensors.PressureMeasure GBHP annotation(
    Placement(visible = true, transformation(origin = {-70, 14}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  inner Nephron.Components.NephronParameters nephronPar annotation(
    Placement(visible = true, transformation(origin = {70, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.FlowPressureMeasure measureAff annotation(
    Placement(visible = true, transformation(origin = {-58, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.FlowPressureMeasure measureGFR annotation(
    Placement(visible = true, transformation(origin = {40, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.FlowPressureMeasure measureEff annotation(
    Placement(visible = true, transformation(origin = {-40, -46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));


equation
  connect(measureEff.q_out, bloodDrain.y) annotation(
    Line(points = {{-40, -56}, {-40, -56}, {-40, -64}, {-28, -64}, {-28, -64}}));
  connect(efferentResistance.q_out, measureEff.q_in) annotation(
    Line(points = {{-40, -24}, {-40, -24}, {-40, -36}, {-40, -36}}));
  connect(measureGFR.q_out, pressureD1.port_b) annotation(
    Line(points = {{50, 24}, {60, 24}, {60, 24}, {60, 24}}));
  connect(filterResistance.q_out, measureGFR.q_in) annotation(
    Line(points = {{20, 24}, {30, 24}, {30, 24}, {30, 24}}));
  connect(measureAff.q_out, afferentResistance.q_in) annotation(
    Line(points = {{-48, 56}, {-40, 56}, {-40, 36}, {-40, 36}}));
  connect(bloodSource.y, measureAff.q_in) annotation(
    Line(points = {{-72, 56}, {-68, 56}, {-68, 56}, {-68, 56}}));
  connect(afferentResistance.q_out, GBHP.q_in) annotation(
    Line(points = {{-40, 16}, {-40, 16}, {-40, 8}, {-66, 8}, {-66, 8}}));
  connect(pressureD1.port_a, urineDrain.y) annotation(
    Line(points = {{73, 8.4}, {78, 8.4}}));
  connect(osmoticBlood.port_b, filterResistance.q_in) annotation(
    Line(points = {{-9, 25.6}, {-4.5, 25.6}, {-4.5, 23.6}, {0, 23.6}}));
  connect(afferentResistance.q_out, osmoticBlood.port_a) annotation(
    Line(points = {{-40, 16}, {-40, 13}, {-40, 13}, {-40, 10}, {-23, 10}}));
  connect(afferentResistance.q_out, efferentResistance.q_in) annotation(
    Line(points = {{-40, 16}, {-40, 16}, {-40, 16}, {-40, 16}, {-40, -4}, {-40, -4}}));
  annotation(
    uses(Physiolibrary(version = "2.3.2-beta")));
end Glomerulus;
within Nephron.Models;

model Glomerulus
  constant Real tor2pasc = 133.322387415;
//hydrostatic pressures:
  parameter PLT.Pressure MAP_norm = 84 * tor2pasc "blood pressure befor afferent arteriole, https://en.wikipedia.org/wiki/Blood_pressure, https://www.omnicalculator.com/health/mean-arterial-pressure";
  parameter Real MAP_mod = 1;
  parameter PLT.Pressure MAP = MAP_mod*84 * tor2pasc "blood pressure befor afferent arteriole, https://en.wikipedia.org/wiki/Blood_pressure, https://www.omnicalculator.com/health/mean-arterial-pressure";
  //"Systolic a diastolic pressures calculated from MAP = 2/3DP + 1/3SP, SP/DP = 120/80)"
  parameter PLT.Pressure DP = 6/7*MAP "diastolic pressure";
  parameter PLT.Pressure SP = 9/7*MAP "systolic pressure";
  parameter Real Aff_MAP_ratio = 50/84;
  parameter PLT.Pressure P_aff = MAP*Aff_MAP_ratio "pressure in afferent arteriole";
  parameter PLT.Pressure P_aff_norm = MAP_norm*Aff_MAP_ratio "normal pressure in afferent arteriole";
  parameter Real Eff_MAP_ratio = 40/84;
  parameter PLT.Pressure P_eff = MAP*Eff_MAP_ratio "pressure in efferent arteriole";
  parameter PLT.Pressure P_eff_norm = MAP_norm*Eff_MAP_ratio "normal pressure in efferent arteriole";
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
  parameter PLT.HydraulicResistance R_aff = R_aff_mod*(P_aff_norm-normal_P_Glom)/RBF1 "afferent arteriol resistance";
  parameter PLT.HydraulicResistance R_eff = R_eff_mod*(normal_P_Glom - P_eff_norm)/(RBF1 - GFR1) "efferent arteriol resistance";
  parameter Real R_filter_mod = 1 "qotient to modify R_filter";
  parameter PLT.HydraulicResistance R_filter = R_filter_mod*normal_P_Filter/GFR1 "efferent arteriol resistance";
  
//other:
  parameter PLT.Density rho = 1060 "blood density";
  parameter PLT.Acceleration g = 9.8 "gravitational acceleration";
  parameter Integer N = 2000000 "Number of nephrones in both kidneys";

//components:
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodSource(P (displayUnit = "Pa") = P_aff)  annotation(
    Placement(visible = true, transformation(origin = {-18, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Resistor afferentResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_aff) annotation(
    Placement(visible = true, transformation(origin = {-44, 22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Components.Resistor efferentResistance(Resistance (displayUnit = "(Pa.s)/m3") = R_eff)  annotation(
    Placement(visible = true, transformation(origin = {-44, -18}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodDrain(P(displayUnit = "Pa") = P_eff)  annotation(
    Placement(visible = true, transformation(origin = {-22, -68}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Resistor filterResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_filter)  annotation(
    Placement(visible = true, transformation(origin = {2, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume urineDrain(P(displayUnit = "Pa") = P_bowm)  annotation(
    Placement(visible = true, transformation(origin = {84, 6}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Nephron.Components.PressureD osmoticBlood(dP = -pi_blood)  annotation(
    Placement(visible = true, transformation(origin = {-24, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.PressureD pressureD1(dP = -pi_bowm)  annotation(
    Placement(visible = true, transformation(origin = {64, 14}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sensors.PressureMeasure GBHP annotation(
    Placement(visible = true, transformation(origin = {-74, 10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  inner Nephron.Components.NephronParameters nephronPar annotation(
    Placement(visible = true, transformation(origin = {74, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.FlowPressureMeasure measureAff annotation(
    Placement(visible = true, transformation(origin = {-44, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Nephron.Components.FlowPressureMeasure measureGFR annotation(
    Placement(visible = true, transformation(origin = {46, 22}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Nephron.Components.FlowPressureMeasure measureEff annotation(
    Placement(visible = true, transformation(origin = { -44, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Components.IdealValve idealValve1(_Goff (displayUnit = "m3/(Pa.s)") = 1.2501e-21)  annotation(
    Placement(visible = true, transformation(origin = {25, 22}, extent = {{-5, -4}, {5, 4}}, rotation = 0)));
equation
  connect(measureAff.q_in, bloodSource.pressure) annotation(
    Line(points = {{-44, 62}, {-44, 70}, {-28, 70}}));
  connect(idealValve1.q_out, measureGFR.q_in) annotation(
    Line(points = {{30, 22}, {40, 22}}));
  connect(filterResistance.q_out, idealValve1.q_in) annotation(
    Line(points = {{12, 22}, {14, 22}, {14, 22}, {16, 22}, {16, 20}, {20, 20}, {20, 20}, {20, 20}, {20, 22}, {20, 22}}));
  connect(measureEff.q_out, bloodDrain.y) annotation(
    Line(points = {{-44, -60}, {-44, -60}, {-44, -60}, {-44, -60}, {-44, -62}, {-44, -62}, {-44, -68}, {-32, -68}, {-32, -68}, {-32, -68}, {-32, -68}}));
  connect(efferentResistance.q_out, measureEff.q_in) annotation(
    Line(points = {{-44, -28}, {-44, -28}, {-44, -28}, {-44, -28}, {-44, -40}, {-44, -40}, {-44, -40}, {-44, -40}}));
  connect(measureGFR.q_out, pressureD1.port_b) annotation(
    Line(points = {{52, 22}, {57, 22}}));
  connect(measureAff.q_out, afferentResistance.q_in) annotation(
    Line(points = {{-44, 42}, {-44, 32}}));
  connect(afferentResistance.q_out, GBHP.q_in) annotation(
    Line(points = {{-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 4}, {-70, 4}, {-70, 4}, {-70, 4}, {-70, 4}, {-70, 4}, {-70, 4}}));
  connect(pressureD1.port_a, urineDrain.y) annotation(
    Line(points = {{71, 6.4}, {74, 6.4}}));
  connect(osmoticBlood.port_b, filterResistance.q_in) annotation(
    Line(points = {{-17, 21.6}, {-8, 21.6}}));
  connect(afferentResistance.q_out, osmoticBlood.port_a) annotation(
    Line(points = {{-44, 12}, {-44, 9}, {-44, 9}, {-44, 6}, {-37.5, 6}, {-37.5, 6}, {-34.25, 6}, {-34.25, 6}, {-31, 6}}));
  connect(afferentResistance.q_out, efferentResistance.q_in) annotation(
    Line(points = {{-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, -8}, {-44, -8}, {-44, -8}, {-44, -8}}));
  annotation(
    uses(Physiolibrary(version = "2.3.2-beta")));
end Glomerulus;
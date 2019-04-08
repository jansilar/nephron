within Nephron.Models;

model Glomerulus
  
//hydrostatic pressures:
  parameter PLT.Pressure MAP_norm = 84 * tor2pasc "blood pressure befor afferent arteriole, https://en.wikipedia.org/wiki/Blood_pressure, https://www.omnicalculator.com/health/mean-arterial-pressure";
  parameter Real MAP_mod = 1;
  parameter PLT.Pressure MAP = MAP_mod*84 * tor2pasc "blood pressure befor afferent arteriole, https://en.wikipedia.org/wiki/Blood_pressure, https://www.omnicalculator.com/health/mean-arterial-pressure";
  //"Systolic a diastolic pressures calculated from MAP = 2/3DP + 1/3SP, SP/DP = 120/80)"
  parameter PLT.Pressure DP = 6/7*MAP "diastolic pressure";
  parameter PLT.Pressure SP = 9/7*MAP "systolic pressure";
  parameter PLT.Pressure P_aff_norm = 50*tor2pasc "normal pressure in afferent arteriole";
  parameter PLT.Pressure P_eff_norm = 40*tor2pasc "normal pressure in efferent arteriole";
  parameter PLT.Pressure P_bowm = 10 * tor2pasc "primary urine pressure in bowman capsule, papír od Honzy Živnýho";
  parameter PLT.Pressure CVP = 5*tor2pasc "central venous pressure";
  parameter PLT.Pressure P_Filter_norm = 6*tor2pasc "normal filtration pressure, papír od HŽ";
  parameter PLT.Pressure P_Glom_norm = P_Filter_norm + P_bowm + pi_blood - pi_bowm "hydrostatic pressure in glomerular capilaries";
  
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
  parameter PLT.HydraulicResistance R_ra = (MAP_norm - P_aff_norm)/RBF1 "renal artery resistance";
  parameter PLT.HydraulicResistance R_aff = R_aff_mod*(P_aff_norm-P_Glom_norm)/RBF1 "afferent arteriol resistance";
  parameter PLT.HydraulicResistance R_eff = R_eff_mod*(P_Glom_norm - P_eff_norm)/(RBF1 - GFR1) "efferent arteriol resistance";
  parameter PLT.HydraulicResistance R_vr = (P_eff_norm - CVP)/(RBF1 - GFR1) "vasa recta resistance";
  parameter Real R_filter_mod = 1 "qotient to modify R_filter";
  parameter PLT.HydraulicResistance R_filter = R_filter_mod*P_Filter_norm/GFR1 "efferent arteriol resistance";
//  parameter Real K_filter = K_filter_mod*GFR1/P_Filter_norm "glomerular filtration coefficient (conductance)";
//  parameter PLT.HydraulicResistance R_filter = 1/K_filter "efferent arteriol resistance";
  
//other:
  parameter PLT.Density rho = 1060 "blood density";
  parameter PLT.Acceleration g = 9.8 "gravitational acceleration";
  parameter Integer N = 2000000 "Number of nephrones in both kidneys";

//components:
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodSource(P (displayUnit = "Pa") = MAP)  annotation(
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Resistor afferentResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_aff) annotation(
    Placement(visible = true, transformation(origin = {-44, 22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Components.Resistor efferentResistance(Resistance (displayUnit = "(Pa.s)/m3") = R_eff)  annotation(
    Placement(visible = true, transformation(origin = {-44, -18}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodDrain(P(displayUnit = "Pa") = CVP)  annotation(
    Placement(visible = true, transformation(origin = {10, -86}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Resistor filterResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_filter)  annotation(
    Placement(visible = true, transformation(origin = {8, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume urineDrain(P(displayUnit = "Pa") = P_bowm)  annotation(
    Placement(visible = true, transformation(origin = {84, 6}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Nephron.Components.PressureDVariable osmoticBlood  annotation(
    Placement(visible = true, transformation(origin = {-18, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
    Placement(visible = true, transformation(origin = {31, 22}, extent = {{-5, -4}, {5, 4}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Resistor renalArteryResistance(Resistance = R_ra)  annotation(
    Placement(visible = true, transformation(origin = {-44, 80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Components.Resistor vasaRectaResistance(Resistance = R_vr)  annotation(
    Placement(visible = true, transformation(origin = {-44, -76}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Nephron.Components.AveCOP aveCOP annotation(
    Placement(visible = true, transformation(origin = {34, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainGFR(k = nephronPar.NNeph)  annotation(
    Placement(visible = true, transformation(origin = {-5, 71}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainRBF(k = nephronPar.NNeph)  annotation(
    Placement(visible = true, transformation(origin = {-7, 53}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain inverseCOP(k = -1)  annotation(
    Placement(visible = true, transformation(origin = {58, 64}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
equation
  connect(inverseCOP.y, osmoticBlood.dP) annotation(
    Line(points = {{62, 64}, {66, 64}, {66, 38}, {-32, 38}, {-32, 16}, {-26, 16}, {-26, 16}}, color = {0, 0, 127}));
  connect(aveCOP.outputCOP, inverseCOP.u) annotation(
    Line(points = {{44, 64}, {53, 64}}, color = {0, 0, 127}));
  connect(gainRBF.y, aveCOP.inputGFR) annotation(
    Line(points = {{-2, 54}, {14, 54}, {14, 56}, {25, 56}}, color = {0, 0, 127}));
  connect(gainGFR.y, aveCOP.inputRBF) annotation(
    Line(points = {{1, 71}, {24, 71}, {24, 69}}, color = {0, 0, 127}));
  connect(measureGFR.volumeFlow, gainRBF.u) annotation(
    Line(points = {{46, 30}, {46, 30}, {46, 36}, {-22, 36}, {-22, 54}, {-14, 54}, {-14, 54}}, color = {0, 0, 127}));
  connect(measureAff.volumeFlow, gainGFR.u) annotation(
    Line(points = {{-56, 52}, {-68, 52}, {-68, 71}, {-11, 71}}, color = {0, 0, 127}));
  connect(filterResistance.q_out, idealValve1.q_in) annotation(
    Line(points = {{18, 22}, {20, 22}, {20, 22}, {22, 22}, {22, 20}, {26, 20}, {26, 20}, {26, 20}, {26, 22}, {26, 22}}));
  connect(idealValve1.q_out, measureGFR.q_in) annotation(
    Line(points = {{36, 22}, {40, 22}}));
  connect(afferentResistance.q_out, osmoticBlood.port_a) annotation(
    Line(points = {{-44, 12}, {-44, 6}, {-25, 6}}));
  connect(osmoticBlood.port_b, filterResistance.q_in) annotation(
    Line(points = {{-11, 21.6}, {-2, 21.6}}));
  connect(vasaRectaResistance.q_out, bloodDrain.y) annotation(
    Line(points = {{-44, -86}, {-44, -86}, {-44, -96}, {-16, -96}, {-16, -86}, {0, -86}, {0, -86}}));
  connect(measureEff.q_out, vasaRectaResistance.q_in) annotation(
    Line(points = {{-44, -60}, {-44, -60}, {-44, -66}, {-44, -66}}));
  connect(bloodSource.y, renalArteryResistance.q_in) annotation(
    Line(points = {{-80, 90}, {-64, 90}, {-64, 98}, {-44, 98}, {-44, 90}}));
  connect(renalArteryResistance.q_out, measureAff.q_in) annotation(
    Line(points = {{-44, 70}, {-44, 70}, {-44, 62}, {-44, 62}}));
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
  connect(afferentResistance.q_out, efferentResistance.q_in) annotation(
    Line(points = {{-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, 12}, {-44, -8}, {-44, -8}, {-44, -8}, {-44, -8}}));
  annotation(
    uses(Physiolibrary(version = "2.3.2-beta")));
end Glomerulus;
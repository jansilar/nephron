within Nephron.Models;

model GlomerulusColeman
  constant Real cond2SI = 1/1.0e6/60/tor2pasc "multiplier for conductance mL/min/mmHg->SI";
  //arterial blood pressure
  parameter Real AP_mod = 1;
  parameter PLT.Pressure AP = AP_mod * 100 * tor2pasc "arterial pressure";
  parameter PLT.Pressure RAP = AP - Clamp "renal artery pressure";
  parameter PLT.Pressure Clamp = 0 "Renal Artery Clamp";
  parameter PLT.Pressure DP = 6/7*AP "diastolic pressure";
  parameter PLT.Pressure SP = 9/7*AP "systolic pressure";
  //afferent artery
  parameter PLT.HydraulicConductance AffC = AffNorm/AffMod "afferent artery conductance";
  parameter PLT.HydraulicConductance AffNorm = colemanConductances.AffNorm*cond2SI "afferent normal conducatance";
  parameter Real AffMod = 1 "afferent relative resistance";
  //efferent artery
  parameter PLT.HydraulicConductance EffC = EffNorm/EffMod "efferent artery conductance";
  parameter PLT.HydraulicConductance EffNorm = colemanConductances.EffNorm*cond2SI "efferent normal conducatance";
  parameter Real EffMod = 1 "efferent relative resistance";
  //venous conductance
  parameter PLT.HydraulicConductance VenC =  200*cond2SI "venous conductance";
  //venous pressure
  parameter PLT.Pressure VP = 7*tor2pasc "venous pressure";
  //filtration coefficient
  parameter PLT.HydraulicConductance KfNorm = colemanConductances.KfNorm*cond2SI "normal glomerular filtration coefficient";
  parameter Real KfMod = 1 "glomerular filtration coefficient modifier";
  parameter PLT.HydraulicConductance Kf = KfNorm*KfMod "glomerular filtration coefficient";
  //proximal tubule
  parameter PLT.HydraulicConductance TubC =  colemanConductances.TubC*cond2SI "proximal tubule conductance";
  

  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodSource(P(displayUnit = "Pa") = RAP) annotation(
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodDrain(P(displayUnit = "Pa") = VP) annotation(
    Placement(visible = true, transformation(origin = {10, -86}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume urineDrain(P(displayUnit = "Pa") = 18 * tor2pasc) annotation(
    Placement(visible = true, transformation(origin = {108, 22}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Nephron.Components.PressureDVariable osmoticBlood(port_a.pressure(start=7676)) annotation(
    Placement(visible = true, transformation(origin = {-18, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sensors.PressureMeasure GP annotation(
    Placement(visible = true, transformation(origin = {-74, 10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.IdealValve idealValve1(_Goff(displayUnit = "m3/(Pa.s)") = 1.2501e-21) annotation(
    Placement(visible = true, transformation(origin = {31, 22}, extent = {{-5, -4}, {5, 4}}, rotation = 0)));
  Nephron.Components.AveCOP aveCOP annotation(
    Placement(visible = true, transformation(origin = {34, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain inverseCOP(k = -1) annotation(
    Placement(visible = true, transformation(origin = {58, 64}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Conductor afferentArtery(Conductance = AffC)  annotation(
    Placement(visible = true, transformation(origin = {-44, 74}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Sensors.FlowMeasure RBF(volumeFlowRate(start=2.0e-5),volumeFlow(start=2.0e-5)) annotation(
    Placement(visible = true, transformation(origin = {-44, 44}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Components.Conductor efferentArtery(Conductance = EffC, dp(start = 6650), q_out.pressure(start=1650))  annotation(
    Placement(visible = true, transformation(origin = {-44, -16}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Sensors.FlowMeasure GFR annotation(
    Placement(visible = true, transformation(origin = {52, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Conductor vena(Conductance = VenC)  annotation(
    Placement(visible = true, transformation(origin = {-42, -60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Components.Conductor glomMembrane(Conductance = Kf, volumeFlowRate(start = 2.08e-6))  annotation(
    Placement(visible = true, transformation(origin = {8, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sensors.PressureMeasure PTP annotation(
    Placement(visible = true, transformation(origin = {76, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.ColemanConductancesUpdated colemanConductances annotation(
    Placement(visible = true, transformation(origin = {78, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sensors.PressureMeasure pressureAff annotation(
    Placement(visible = true, transformation(origin = {-22, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sensors.PressureMeasure pressureEff annotation(
    Placement(visible = true, transformation(origin = {-16, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add pAffEffective(k1 = 1, k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {44, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add pEffEffective(k1 = -1, k2 = 1)  annotation(
    Placement(visible = true, transformation(origin = {22, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(osmoticBlood.port_b, glomMembrane.q_in) annotation(
    Line(points = {{-10, 22}, {-6, 22}, {-6, 24}, {-2, 24}}));
  connect(glomMembrane.q_out, idealValve1.q_in) annotation(
    Line(points = {{18, 24}, {22, 24}, {22, 22}, {26, 22}}));
  connect(GFR.q_out, urineDrain.y) annotation(
    Line(points = {{62, 22}, {98, 22}, {98, 22}, {98, 22}}));
  connect(pressureEff.pressure, pEffEffective.u2) annotation(
    Line(points = {{-10, -38}, {0, -38}, {0, -22}, {10, -22}, {10, -22}}, color = {0, 0, 127}));
  connect(aveCOP.outputECOP, pEffEffective.u1) annotation(
    Line(points = {{44, 54}, {56, 54}, {56, 4}, {-4, 4}, {-4, -10}, {10, -10}, {10, -10}}, color = {0, 0, 127}));
  connect(aveCOP.outputACOP, pAffEffective.u2) annotation(
    Line(points = {{44, 70}, {44, 74}, {14, 74}, {14, 86}, {32, 86}}, color = {0, 0, 127}));
  connect(pressureAff.pressure, pAffEffective.u1) annotation(
    Line(points = {{-16, 94}, {10, 94}, {10, 98}, {32, 98}}, color = {0, 0, 127}));
  connect(efferentArtery.q_out, pressureEff.q_in) annotation(
    Line(points = {{-44, -26}, {-42, -26}, {-42, -40}, {-20, -40}, {-20, -40}}));
  connect(afferentArtery.q_in, pressureAff.q_in) annotation(
    Line(points = {{-44, 84}, {-44, 84}, {-44, 92}, {-26, 92}, {-26, 92}}));
  connect(bloodSource.y, afferentArtery.q_in) annotation(
    Line(points = {{-80, 90}, {-70, 90}, {-70, 106}, {-44, 106}, {-44, 84}}));
  connect(afferentArtery.q_out, RBF.q_in) annotation(
    Line(points = {{-44, 64}, {-44, 54}}));
  connect(RBF.q_out, efferentArtery.q_in) annotation(
    Line(points = {{-44, 34}, {-44, -6}}));
  connect(RBF.volumeFlow, aveCOP.inputRBF) annotation(
    Line(points = {{-32, 44}, {0, 44}, {0, 70}, {24, 70}}, color = {0, 0, 127}));
  connect(RBF.q_out, osmoticBlood.port_a) annotation(
    Line(points = {{-44, 34}, {-44, 6}, {-24, 6}}));
  connect(PTP.q_in, GFR.q_out) annotation(
    Line(points = {{72, -16}, {62, -16}, {62, 22}}));
  connect(vena.q_out, bloodDrain.y) annotation(
    Line(points = {{-42, -70}, {-42, -70}, {-42, -86}, {0, -86}, {0, -86}}));
  connect(efferentArtery.q_out, vena.q_in) annotation(
    Line(points = {{-44, -26}, {-42, -26}, {-42, -50}, {-42, -50}}));
  connect(GFR.volumeFlow, aveCOP.inputGFR) annotation(
    Line(points = {{52, 34}, {52, 34}, {52, 46}, {12, 46}, {12, 56}, {24, 56}, {24, 56}}, color = {0, 0, 127}));
  connect(idealValve1.q_out, GFR.q_in) annotation(
    Line(points = {{36, 22}, {42, 22}, {42, 22}, {42, 22}}));
  connect(GP.q_in, efferentArtery.q_in) annotation(
    Line(points = {{-70, 4}, {-44, 4}, {-44, -6}, {-44, -6}}));
  connect(inverseCOP.y, osmoticBlood.dP) annotation(
    Line(points = {{62, 64}, {66, 64}, {66, 40}, {-32, 40}, {-32, 16}, {-26, 16}}, color = {0, 0, 127}));
  connect(aveCOP.outputCOP, inverseCOP.u) annotation(
    Line(points = {{44, 64}, {53, 64}}, color = {0, 0, 127}));
  annotation(
    uses(Physiolibrary(version = "2.3.2-beta")));
end GlomerulusColeman;
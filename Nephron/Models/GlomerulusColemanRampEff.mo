within Nephron.Models;

model GlomerulusColemanRampEff
  constant Real cond2SI = 1 / 1.0e6 / 60 / tor2pasc "multiplier for conductance mL/min/mmHg->SI";
  //arterial blood pressure
  parameter Real AP_mod = 1;
  parameter PLT.Pressure AP = AP_mod * 100 * tor2pasc "arterial pressure";
  parameter PLT.Pressure RAP = AP - Clamp "renal artery pressure";
  parameter PLT.Pressure Clamp = 0 "Renal Artery Clamp";
  //afferent artery
  parameter PLT.HydraulicConductance AffC = AffNorm / AffMod "afferent artery conductance";
  parameter PLT.HydraulicConductance AffNorm = colemanConductances.AffNorm * cond2SI "afferent normal conducatance";
  parameter Real AffMod(min = 1 / (0.1 * 0.5), max = 1 / (1.5 * 1.5)) = 1 "afferent relative resistance";
  //efferent artery
  parameter Real EffModMin = 0.5;
  parameter Real EffModMax = 5;
  PLT.HydraulicConductance EffC = EffNorm / EffMod "efferent artery conductance";
  parameter PLT.HydraulicConductance EffNorm = colemanConductances.EffNorm * cond2SI "efferent normal conducatance";
  Real EffMod(min = 1 / (0.9 * 0.6), max = 1 / (1.4 * 1.1)) = EffModMin + time*(EffModMax - EffModMin) "efferent relative resistance";
  //venous conductance
  parameter PLT.HydraulicConductance VenC = 200 * cond2SI "venous conductance";
  //venous pressure
  parameter PLT.Pressure VP = 7 * tor2pasc "venous pressure";
  //filtration coefficient
  parameter PLT.HydraulicConductance KfNorm = colemanConductances.KfNorm * cond2SI "normal glomerular filtration coefficient";
  parameter Real KfMod = 1 "glomerular filtration coefficient modifier";
  parameter PLT.HydraulicConductance Kf = KfNorm * KfMod "glomerular filtration coefficient";
  //proximal tubule
  parameter PLT.HydraulicConductance TubC = colemanConductances.TubC * cond2SI "proximal tubule conductance";
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodSource(P(displayUnit = "Pa") = RAP) annotation(
    Placement(visible = true, transformation(origin = {-90, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodDrain(P(displayUnit = "Pa") = VP) annotation(
    Placement(visible = true, transformation(origin = {10, -86}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume urineDrain(P(displayUnit = "Pa") = 0) annotation(
    Placement(visible = true, transformation(origin = {108, 22}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Nephron.Components.PressureDVariable osmoticBlood annotation(
    Placement(visible = true, transformation(origin = {-18, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sensors.PressureMeasure GP annotation(
    Placement(visible = true, transformation(origin = {-74, 10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.IdealValve idealValve1(_Goff(displayUnit = "m3/(Pa.s)") = 1.2501e-21) annotation(
    Placement(visible = true, transformation(origin = {31, 22}, extent = {{-5, -4}, {5, 4}}, rotation = 0)));
  Nephron.Components.AveCOP aveCOP annotation(
    Placement(visible = true, transformation(origin = {34, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain inverseCOP(k = -1) annotation(
    Placement(visible = true, transformation(origin = {58, 64}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Conductor afferentArtery(Conductance = AffC) annotation(
    Placement(visible = true, transformation(origin = {-44, 80}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Sensors.FlowMeasure RBF annotation(
    Placement(visible = true, transformation(origin = {-44, 52}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Components.Conductor efferentArtery(dp(start = 6650), useConductanceInput = true) annotation(
    Placement(visible = true, transformation(origin = {-44, -16}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  /*Conductance = 6650, */
  Physiolibrary.Hydraulic.Sensors.FlowMeasure GFR annotation(
    Placement(visible = true, transformation(origin = {52, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Conductor vena(Conductance = VenC) annotation(
    Placement(visible = true, transformation(origin = {-42, -60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Components.Conductor glomMembrane(Conductance = Kf) annotation(
    Placement(visible = true, transformation(origin = {8, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Conductor proximalTubule(Conductance = TubC) annotation(
    Placement(visible = true, transformation(origin = {78, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sensors.PressureMeasure PTP annotation(
    Placement(visible = true, transformation(origin = {76, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.ColemanConductances colemanConductances(AffNorm = 28.3, EffNorm = 23.8, KfNorm = 17.6, TubC = 6.8) annotation(
    Placement(visible = true, transformation(origin = {78, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  efferentArtery.cond = EffC;
  connect(PTP.q_in, GFR.q_out) annotation(
    Line(points = {{72, -16}, {62, -16}, {62, 22}}));
  connect(proximalTubule.q_out, urineDrain.y) annotation(
    Line(points = {{88, 22}, {98, 22}}));
  connect(GFR.q_out, proximalTubule.q_in) annotation(
    Line(points = {{62, 22}, {68, 22}, {68, 22}, {68, 22}}));
  connect(RBF.q_out, osmoticBlood.port_a) annotation(
    Line(points = {{-44, 42}, {-44, 42}, {-44, 6}, {-24, 6}, {-24, 6}}));
  connect(glomMembrane.q_out, idealValve1.q_in) annotation(
    Line(points = {{18, 22}, {26, 22}, {26, 22}, {26, 22}}));
  connect(osmoticBlood.port_b, glomMembrane.q_in) annotation(
    Line(points = {{-10, 22}, {-2, 22}, {-2, 22}, {-2, 22}}));
  connect(vena.q_out, bloodDrain.y) annotation(
    Line(points = {{-42, -70}, {-42, -70}, {-42, -86}, {0, -86}, {0, -86}}));
  connect(efferentArtery.q_out, vena.q_in) annotation(
    Line(points = {{-44, -26}, {-42, -26}, {-42, -50}, {-42, -50}}));
  connect(GFR.volumeFlow, aveCOP.inputGFR) annotation(
    Line(points = {{52, 34}, {52, 34}, {52, 46}, {12, 46}, {12, 56}, {24, 56}, {24, 56}}, color = {0, 0, 127}));
  connect(idealValve1.q_out, GFR.q_in) annotation(
    Line(points = {{36, 22}, {42, 22}, {42, 22}, {42, 22}}));
  connect(RBF.volumeFlow, aveCOP.inputRBF) annotation(
    Line(points = {{-32, 52}, {0, 52}, {0, 70}, {24, 70}, {24, 70}}, color = {0, 0, 127}));
  connect(GP.q_in, efferentArtery.q_in) annotation(
    Line(points = {{-70, 4}, {-44, 4}, {-44, -6}, {-44, -6}}));
  connect(RBF.q_out, efferentArtery.q_in) annotation(
    Line(points = {{-44, 42}, {-44, 42}, {-44, -6}, {-44, -6}}));
  connect(afferentArtery.q_out, RBF.q_in) annotation(
    Line(points = {{-44, 70}, {-44, 70}, {-44, 62}, {-44, 62}}));
  connect(bloodSource.y, afferentArtery.q_in) annotation(
    Line(points = {{-80, 90}, {-70, 90}, {-70, 106}, {-44, 106}, {-44, 90}}));
  connect(inverseCOP.y, osmoticBlood.dP) annotation(
    Line(points = {{62, 64}, {66, 64}, {66, 40}, {-32, 40}, {-32, 16}, {-26, 16}}, color = {0, 0, 127}));
  connect(aveCOP.outputCOP, inverseCOP.u) annotation(
    Line(points = {{44, 64}, {53, 64}}, color = {0, 0, 127}));
  annotation(
    uses(Physiolibrary(version = "2.3.2-beta")));
end GlomerulusColemanRampEff;
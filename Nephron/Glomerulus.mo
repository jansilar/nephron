within Nephron;

model Glomerulus
  constant Real tor2pasc = 133.322387415;
  parameter Real P_aff(unit = "Pa") = 88 * tor2pasc "blood pressure befor afferent arteriole";
  parameter Real P_eff(unit = "Pa") = 40 * tor2pasc "blood pressure after efferent arteriole TODO:correct value";
  parameter Real P_bowm(unit = "Pa") = 10 * tor2pasc "primary urine pressure in bowman capsule TODO:correct value";
  parameter Real rho(unit = "kg/m3") = 1060 "blood density";
  parameter Real g(unit = "m/s2") = 9.8 "gravitational acceleration";
  parameter Real R_aff(unit = "Pa.s/m3") = (P_aff - P_eff) / control_Q_in / 2 "afferent arteriol resistance, TODO:correct value";
  parameter Real R_eff(unit = "Pa.s/m3") = (P_aff - P_eff) / control_Q_in / 2 "efferent arteriol resistance, TODO:correct value";
  parameter Real R_filter(unit = "Pa.s/m3") = (P_aff + P_eff - P_bowm) / 2 / control_Q_1urine_out  "efferent arteriol resistance, TODO: correct value";
  parameter Integer N = 2000000 "Number of nephrones in both kidneys";
  parameter Real CO(unit = "m3/s") = 5 / 60 / 1000 "cardiac output";
  parameter Real control_Q_in(unit = "m3/s") = CO * 0.2 / N "blood flow into each glomerulus";
  parameter Real control_Q_in_mlpermin(unit = "ml/min") = control_Q_in*1000*1000*60;
  parameter Real control_Q_1urine_out(unit = "m3/s") = 180 / 1000 / 24 / 60 / 60 / N "primary urine production per each nephron";
  parameter Real control_Q_1urine_out_mlpermin(unit = "m3/s") = control_Q_1urine_out*1000*1000*60;
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodSource annotation(
    Placement(visible = true, transformation(origin = {-82, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.HydrostaticColumn afferentPressure(H(displayUnit = "m") = P_aff / rho / g, ro(displayUnit = "kg/m3") = rho) annotation(
    Placement(visible = true, transformation(origin = {-4, 52}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Resistor afferentResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_aff) annotation(
    Placement(visible = true, transformation(origin = {-18, 26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Components.Resistor efferentResistance(Resistance = R_eff)  annotation(
    Placement(visible = true, transformation(origin = { -18, -14}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Physiolibrary.Hydraulic.Components.HydrostaticColumn efferentPressure(H = P_eff / rho / g, ro(displayUnit = "kg/m3") = rho)  annotation(
    Placement(visible = true, transformation(origin = {4, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodDrain annotation(
    Placement(visible = true, transformation(origin = {56, -34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.Resistor filterResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_filter)  annotation(
    Placement(visible = true, transformation(origin = {12, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Sources.UnlimitedVolume urineDrain annotation(
    Placement(visible = true, transformation(origin = {54, 46}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Physiolibrary.Hydraulic.Components.HydrostaticColumn bowmansPressure(H = P_bowm / rho / g, ro = rho)  annotation(
    Placement(visible = true, transformation(origin = {52, 12}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(urineDrain.y, bowmansPressure.q_up) annotation(
    Line(points = {{44, 46}, {32, 46}, {32, 16}, {44, 16}, {44, 16}}));
  connect(filterResistance.q_out, bowmansPressure.q_down) annotation(
    Line(points = {{22, 6}, {44, 6}, {44, 6}, {44, 6}}));
  connect(afferentResistance.q_out, filterResistance.q_in) annotation(
    Line(points = {{-18, 16}, {-18, 6}, {2, 6}}));
  connect(bloodSource.y, afferentPressure.q_up) annotation(
    Line(points = {{-72, 56}, {-12, 56}, {-12, 56}, {-12, 56}}));
  connect(bloodDrain.y, efferentPressure.q_up) annotation(
    Line(points = {{46, -34}, {-10, -34}, {-10, -46}, {-7, -46}, {-7, -46}, {-4, -46}}));
  connect(efferentResistance.q_out, efferentPressure.q_down) annotation(
    Line(points = {{-18, -24}, {-18, -24}, {-18, -56}, {-4, -56}, {-4, -56}}));
  connect(afferentResistance.q_out, efferentResistance.q_in) annotation(
    Line(points = {{-18, 16}, {-18, 16}, {-18, 16}, {-18, 16}, {-18, -4}, {-18, -4}}));
  connect(afferentPressure.q_down, afferentResistance.q_in) annotation(
    Line(points = {{-12, 46}, {-18, 46}, {-18, 36}}));
  annotation(
    uses(Physiolibrary(version = "2.3.2-beta")));
end Glomerulus;
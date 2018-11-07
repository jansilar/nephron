within Nephron.Models;

model NephronModel
  inner parameter Integer NNeph = 2000000 "total nephron count";
  parameter Real GFR = 180 "[l/day] total GFR";
  parameter PLT.VolumeFlowRate GFR1 = GFR/1000/24/60/60/NNeph "GFR per nephron";
  Nephron.Components.OsmoticSource glomerulus(Q(displayUnit = "m3/s") = GFR1, o = 300)  annotation(
    Placement(visible = true, transformation(origin = {-84, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Nephron.Components.DLOH dloh annotation(
    Placement(visible = true, transformation(origin = {12, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.OsmoticDrain drain annotation(
    Placement(visible = true, transformation(origin = {12, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.PT pt annotation(
    Placement(visible = true, transformation(origin = {-26, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Nephron.Components.FlowOsmosisMeasure measureGlom annotation(
    Placement(visible = true, transformation(origin = {-54, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.FlowOsmosisMeasure measurePT annotation(
    Placement(visible = true, transformation(origin = {-2, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.FlowOsmosisMeasure measureDLH annotation(
    Placement(visible = true, transformation(origin = {12, 14}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(measureDLH.q_out, drain.port_a) annotation(
    Line(points = {{12, 4}, {12, 4}, {12, -4}, {12, -4}}, color = {127, 127, 0}));
  connect(dloh.port_out, measureDLH.q_in) annotation(
    Line(points = {{12, 32}, {12, 32}, {12, 24}, {12, 24}}, color = {127, 127, 0}));
  connect(measurePT.q_out, dloh.port_in) annotation(
    Line(points = {{8, 60}, {12, 60}, {12, 49}}, color = {127, 127, 0}));
  connect(pt.port_out, measurePT.q_in) annotation(
    Line(points = {{-16, 60}, {-12, 60}, {-12, 60}, {-12, 60}}, color = {127, 127, 0}));
  connect(measureGlom.q_out, pt.port_in) annotation(
    Line(points = {{-44, 60}, {-35, 60}}, color = {127, 127, 0}));
  connect(glomerulus.port_b, measureGlom.q_in) annotation(
    Line(points = {{-74, 60}, {-64, 60}}, color = {127, 127, 0}));
end NephronModel;
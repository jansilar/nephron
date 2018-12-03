within Nephron.Models;

model NephronModel
  parameter Real gfr_mod = 1;
  inner Nephron.Components.NephronParameters nephronPar annotation(
    Placement(visible = true, transformation(origin = {84, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.OsmoticSource glomerulus(Q = gfr_mod * nephronPar.GFR1_norm)   annotation(
    Placement(visible = true, transformation(origin = {-96, 16}, extent = {{-4, -4}, {4, 4}}, rotation = 90)));
  Nephron.Components.DLOH dloh annotation(
    Placement(visible = true, transformation(origin = {-20, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.PT pt annotation(
    Placement(visible = true, transformation(origin = {-54, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Nephron.Components.FlowOsmosisMeasure measureGlom annotation(
    Placement(visible = true, transformation(origin = {-78, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.FlowOsmosisMeasure measurePT annotation(
    Placement(visible = true, transformation(origin = {-30, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.FlowOsmosisMeasure measureDLH annotation(
    Placement(visible = true, transformation(origin = {-10, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.OsmoticDrain osmoticDrain annotation(
    Placement(visible = true, transformation(origin = {66, -47}, extent = {{-3, -3}, {3, 3}}, rotation = 0)));
  Nephron.Components.ALOH aloh annotation(
    Placement(visible = true, transformation(origin = {0, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Nephron.Components.FlowOsmosisMeasure measureALOH annotation(
    Placement(visible = true, transformation(origin = {10, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.DT dt annotation(
    Placement(visible = true, transformation(origin = {34, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Nephron.Components.FlowOsmosisMeasure measureDT annotation(
    Placement(visible = true, transformation(origin = {56, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.CD cd(N=20) annotation(
    Placement(visible = true, transformation(origin = {66, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Nephron.Components.FlowOsmosisMeasure cdMeasure annotation(
    Placement(visible = true, transformation(origin = {66, -28}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product Na annotation(
    Placement(visible = true, transformation(origin = {20, -52}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product Na_tot annotation(
    Placement(visible = true, transformation(origin = {-46, -58}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant NNeph(k = nephronPar.NNeph)  annotation(
    Placement(visible = true, transformation(origin = {20, -82}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
equation
  connect(Na_tot.u2, NNeph.y) annotation(
    Line(points = {{-34, -64}, {-12, -64}, {-12, -82}, {8, -82}, {8, -82}, {8, -82}}, color = {0, 0, 127}));
  connect(Na_tot.u1, Na.y) annotation(
    Line(points = {{-34, -52}, {8, -52}}, color = {0, 0, 127}));
  connect(cdMeasure.volumeFlowRate, Na.u2) annotation(
    Line(points = {{58, -28}, {46, -28}, {46, -58}, {32, -58}}, color = {0, 0, 127}));
  connect(cdMeasure.osmolarity, Na.u1) annotation(
    Line(points = {{58, -20}, {32, -20}, {32, -46}}, color = {0, 0, 127}));
  connect(cdMeasure.q_out, osmoticDrain.port_a) annotation(
    Line(points = {{66, -38}, {66, -38}, {66, -44}, {66, -44}}, color = {127, 127, 0}));
  connect(cd.port_out, cdMeasure.q_in) annotation(
    Line(points = {{66, -12}, {66, -12}, {66, -18}, {66, -18}}, color = {127, 127, 0}));
  connect(measureDT.q_out, cd.port_in) annotation(
    Line(points = {{66, 18}, {66, 5}}, color = {127, 127, 0}));
  connect(dt.port_out, measureDT.q_in) annotation(
    Line(points = {{43, 18}, {46, 18}}, color = {127, 127, 0}));
  connect(measureALOH.q_out, dt.port_in) annotation(
    Line(points = {{20, 18}, {25, 18}}, color = {127, 127, 0}));
  connect(measureALOH.q_in, aloh.port_out) annotation(
    Line(points = {{0, 18}, {0, 18}, {0, 2}, {0, 2}}, color = {127, 127, 0}));
  connect(measureDLH.q_out, aloh.port_in) annotation(
    Line(points = {{0, -24}, {0, -17}}, color = {127, 127, 0}));
  connect(dloh.port_out, measureDLH.q_in) annotation(
    Line(points = {{-20, -13}, {-20, -24}}, color = {127, 127, 0}));
  connect(measurePT.q_out, dloh.port_in) annotation(
    Line(points = {{-20, 16}, {-20, 5}}, color = {127, 127, 0}));
  connect(pt.port_out, measurePT.q_in) annotation(
    Line(points = {{-45, 16}, {-40, 16}}, color = {127, 127, 0}));
  connect(measureGlom.q_out, pt.port_in) annotation(
    Line(points = {{-68, 16}, {-63, 16}}, color = {127, 127, 0}));
  connect(glomerulus.port_b, measureGlom.q_in) annotation(
    Line(points = {{-92.4, 16}, {-88.4, 16}}, color = {127, 127, 0}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.05));
end NephronModel;
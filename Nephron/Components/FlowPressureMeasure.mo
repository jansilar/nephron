within Nephron.Components;

model FlowPressureMeasure
  extends Physiolibrary.Hydraulic.Sensors.FlowMeasure;
  outer Components.NephronParameters nephronPar;
  Physiolibrary.Types.RealIO.PressureOutput pressure annotation(
    Placement(visible = true, transformation(origin = {-70, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, -80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput volumeFlowRateTot "flow rate per both kidneys [L/day]"annotation(
    Placement(visible = true, transformation(origin = {68, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, -80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
equation
  assert(nephronPar.NNeph>0,"NNep must be greater than zero.");
  volumeFlowRateTot = nephronPar.NNeph*volumeFlowRate*1e3*60*60*24;
  pressure = q_in.pressure;
end FlowPressureMeasure;
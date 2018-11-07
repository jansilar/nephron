within Nephron.Components;

model FlowOsmosisMeasure
  extends Physiolibrary.Osmotic.Sensors.FlowMeasure;
  outer parameter Integer NNeph;
  Physiolibrary.Types.RealIO.OsmolarityOutput osmolarity annotation(
    Placement(visible = true, transformation(origin = {-70, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, -80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput volumeFlowRateTot "flow rate per both kidneys [L/day]"annotation(
    Placement(visible = true, transformation(origin = {68, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, -80}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
equation
  assert(NNeph>0,"NNep must be greater than zero.");
  volumeFlowRateTot = NNeph*volumeFlowRate*1e3*60*60*24;
  osmolarity = q_in.o;
end FlowOsmosisMeasure;
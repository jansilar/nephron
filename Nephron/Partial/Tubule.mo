within Nephron.Partial;
model Tubule
  constant Integer N = 3;
  parameter Real L;
  PLT.VolumeFlowRate[N] Q "water flow";
  PLT.Concentration[N] o "osmolarity";
  Real[N] f_H2O "water out-flow per unit length";
  Real[N] f_Na "Na out-flow per unit length";
  Physiolibrary.Osmotic.Interfaces.OsmoticPort_a port_in annotation(
    Placement(visible = true, transformation(origin = {0, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Physiolibrary.Osmotic.Interfaces.OsmoticPort_b port_out annotation(
    Placement(visible = true, transformation(origin = {0, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));  
protected
  parameter Real dx = L/N;
equation
  for i in 1:N loop
    assert(Q[i] >= 0, "negative flux in tubule " + getInstanceName(), level = AssertionLevel.warning);
    assert(o[i] >= 0, "negative concentration in tubule", level = AssertionLevel.warning);
  end for;

  
  0 = (Q[1] - port_in.q)/dx + f_H2O[1];
  0 = (Q[1]*o[1] - port_in.q*port_in.o)/dx + f_Na[1];

  for i in 2:N loop
    0 = (Q[i] - Q[i-1])/dx + f_H2O[i];
    0 = (Q[i]*o[i] - Q[i-1]*o[i-1])/dx + f_Na[i];
  end for;
  Q[N] = port_out.q;
  o[N] = port_out.o;
annotation(
    Icon(graphics = {Rectangle(origin = {-11, -1}, lineColor = {52, 101, 164}, fillColor = {52, 101, 164}, fillPattern = FillPattern.Solid, extent = {{-29, 80}, {51, -80}}), Ellipse(origin = {2, 80}, lineColor = {52, 101, 164}, fillColor = {32, 74, 135}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-42, 15}, {38, -15}}, endAngle = 360), Ellipse(origin = {2, -82}, lineColor = {52, 101, 164}, fillColor = {52, 101, 164}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-42, 15}, {38, -15}}, endAngle = 360)}));end Tubule;
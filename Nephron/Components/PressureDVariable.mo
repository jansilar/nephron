within Nephron.Components;

model PressureDVariable
  extends Nephron.Components.Partial.PressureDBase(dPVar=dP);
  Modelica.Blocks.Interfaces.RealInput dP annotation(
    Placement(visible = true, transformation(origin = {-82, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-82, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
end PressureDVariable;
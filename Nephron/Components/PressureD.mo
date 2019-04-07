within Nephron.Components;

model PressureD
  extends Nephron.Components.Partial.PressureDBase(dPVar=dP);
  parameter Real dP(unit="Pa") = 0 "pressure difference";
end PressureD;
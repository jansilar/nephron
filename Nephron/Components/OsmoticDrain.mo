within Nephron.Components;

model OsmoticDrain
  Physiolibrary.Osmotic.Interfaces.OsmoticPort_a port_a annotation(
    Placement(visible = true, transformation(origin = {2, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {2, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

annotation(
    Icon(graphics = {Rectangle(origin = {-2, -1}, fillPattern = FillPattern.Solid, extent = {{-78, 81}, {82, -79}})}));
end OsmoticDrain;
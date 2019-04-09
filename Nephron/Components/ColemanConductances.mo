within Nephron.Components;

record ColemanConductances
extends Modelica.Icons.Record;

  //afferent artery
  parameter Real AffNorm = 30 "afferent normal conducatance";
  //efferent artery
  parameter Real EffNorm = 25 "efferent normal conducatance";
  //venous conductance
  parameter Real VenC =  200 "venous conductance";
  parameter Real KfNorm = 16 "normal glomerular filtration coefficient";
  //proximal tubule
  parameter Real TubC =  6.25 "Proximal Tubule conductance";

end ColemanConductances;
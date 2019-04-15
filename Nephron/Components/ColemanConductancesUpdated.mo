within Nephron.Components;

record ColemanConductancesUpdated
extends Modelica.Icons.Record;

  //afferent artery
  parameter Real AffNorm = 28.285 "afferent normal conducatance";
  //efferent artery
  parameter Real EffNorm = 23.787 "efferent normal conducatance";
  //venous conductance
  parameter Real VenC =  200 "venous conductance";
  parameter Real KfNorm = 16.7 "normal glomerular filtration coefficient";
  //proximal tubule
  parameter Real TubC =  6.8 "Proximal Tubule conductance";

end ColemanConductancesUpdated;
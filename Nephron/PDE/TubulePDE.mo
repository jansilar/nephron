within Nephron.PDE;
partial model TubulePDE
  parameter Real Ltub;
  DomainLineSegment1D tubule(N=11, L=Ltub);
  field Real Q(domain=tubule);
//  field Real c(domain=tubule);
  field Real f_H2O(domain=tubule);
//  field Real f_Na(domain=tubule);
equation
  0 = pder(Q,x) + f_H2O     indomain tubule;
//  0 = pder(c,x)*Q + c*pder(Q,x) + f_Na    indomain tubule; 
end TubulePDE;

within Nephron;
model Hoppensteadt
  DomainLineSegment1D radial(N=100, L = 0.04);
  DomainLineSegment1D superficial(N=25, L = 0.01);
  field Real c(domain=radial);
//DLH  
  field Real Q_1(domain=radial);
  field Real c_1(domain=radial);
  field Real f_H2O_1(domain=radial);
  parameter Real Q_1_0 = 180/1000/24/60/60 "180L/24h -> m3/s ?";
  parameter Real c_0 = 140/1000 "mmoll/L -> moll/L ?";
//ALH
  field Real Q_2(domain=radial);
  field Real c_2(domain=radial);
  Real f_Na;
  parameter Real alpha = 0.8;//0.8 "Sodium recovery quotient ?";
  
  parameter Real ADH = 0.5 "anti-diuretic hormone 0-1";
//DT
  field Real Q_DT(domain=superficial);
  field Real c_DT(domain=superficial);
//CD
  field Real Q_CD(domain=radial);
  field Real c_CD(domain=radial);

equation
  alpha = f_Na*radial.L/Q_1_0/c_0                       "(4.3.16)";
//DLH
  c_1 = c                               indomain radial "(4.3.3) c_1";
  f_Na = c*f_H2O_1                      indomain radial "(4.3.8) f_H2O_1";
  Q_1 = Q_1_0*c_0/c                     indomain radial "(4.3.11) Q_1";
  c = c_0*exp(f_Na*radial.x/(Q_1_0*c_0)) indomain radial "(4.3.14) c";
//ALH
  Q_2 = Q_1_0*exp(-alpha)               indomain radial "(4.3.18)";
  c_2 = c_0*exp(alpha) + (radial.x - radial.L)*f_Na*exp(alpha)/Q_1_0  indomain radial "(4.3.21)";
//DT
  c_DT = c_0*(exp(alpha)*(1-alpha) + ADH*superficial.x/superficial.L*(1-exp(alpha)*(1-alpha)))  indomain superficial "notes eq:c_DT";
  Q_DT = Q_1_0*(1-alpha)/(exp(alpha)*(1-alpha) + ADH*superficial.x/superficial.L*(1-exp(alpha)*(1-alpha))) indomain superficial "notes eq:Q_DT";
//CD
  c_CD = c_0*((1-ADH)*exp(alpha)*(1-alpha) + ADH + radial.x/radial.L*ADH*(exp(alpha)-1)) indomain radial "notes eq:c_CD";
  Q_CD = Q_1_0*(1-alpha)/((1-ADH)*exp(alpha)*(1-alpha) + ADH + radial.x/radial.L*ADH*(exp(alpha)-1)) indomain radial "notes eq:Q_CD";
  
end Hoppensteadt;
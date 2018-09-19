within Nephron;

model HoppensteadtNoPDE
  DLS1D radial(N = 100, L = 0.04);
  DLS1D superficial(N = 25, L = 0.01);
  Real c[radial.N];
  //DLH
  Real Q_1[radial.N];
  Real c_1[radial.N];
  Real f_H2O_1[radial.N];
  parameter Real Q_1_0 = 180 / 1000 / 24 / 60 / 60 "180L/24h -> m3/s ?";
  parameter Real c_0 = 140 / 1000 "mmoll/L -> moll/L ?";
  //ALH
  Real Q_2[radial.N];
  Real c_2[radial.N];
  Real f_Na;
  parameter Real alpha = 0.999;
  //0.8 "Sodium recovery quotient ?";
  parameter Real ADH = 0.5 "anti-diuretic hormone 0-1";
  //DT
  Real Q_DT[superficial.N];
  Real c_DT[superficial.N];
  //CD
  Real Q_CD[radial.N];
  Real c_CD[radial.N];
equation
  alpha = f_Na * radial.L / Q_1_0 / c_0 "(4.3.16)";
  for i in 1:radial.N loop
  //DLH
    c_1[i] = c indomain radial "(4.3.3) c_1";
    f_Na = c * f_H2O_1[i] indomain radial "(4.3.8) f_H2O_1";
    Q_1[i] = Q_1_0 * c_0 / c indomain radial "(4.3.11) Q_1";
    c = c_0 * exp(f_Na * radial.x[i] / (Q_1_0 * c_0)) indomain radial "(4.3.14) c";
  //ALH
    Q_2[i] = Q_1_0 * exp(-alpha) indomain radial "(4.3.18)";
    c_2[i] = c_0 * exp(alpha) + (radial.x[i] - radial.L) * f_Na * exp(alpha) / Q_1_0 indomain radial "(4.3.21)";
  
  //CD
    c_CD = c_0 * ((1 - ADH) * exp(alpha) * (1 - alpha) + ADH + radial.x[i] / radial.L * ADH * (exp(alpha) - 1)) indomain radial "notes eq:c_CD";
    Q_CD = Q_1_0 * (1 - alpha) / ((1 - ADH) * exp(alpha) * (1 - alpha) + ADH + radial.x[i] / radial.L * ADH * (exp(alpha) - 1)) indomain radial "notes eq:Q_CD";
  end for;
  for i in 1:superficial.N loop
  //DT
    c_DT[i] = c_0 * (exp(alpha) * (1 - alpha) + ADH * superficial.x[i] / superficial.L * (1 - exp(alpha) * (1 - alpha))) indomain superficial "notes eq:c_DT";
    Q_DT[i] = Q_1_0 * (1 - alpha) / (exp(alpha) * (1 - alpha) + ADH * superficial.x[i] / superficial.L * (1 - exp(alpha) * (1 - alpha))) indomain superficial "notes eq:Q_DT";
  end for;
end HoppensteadtNoPDE;
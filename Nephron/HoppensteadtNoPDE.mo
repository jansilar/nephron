within Nephron;

model HoppensteadtNoPDE
  constant Integer radial_N=100;
  Real radial_L = 0.04;
  Real[radial_N] radial_x = {0 + radial_L/(radial_N-1)*i for i in 0:radial_N-1};
  
  constant Integer superficial_N = 25;
  Real superficial_L = 0.01;
  Real[superficial_N] superficial_x = {0 + superficial_L/(superficial_N-1)*i for i in 0:superficial_N-1};
  
  Real c[radial_N];
  //DLH
  Real Q_1[radial_N];
  Real c_1[radial_N];
  Real f_H2O_1[radial_N];
  parameter Real Q_1_0 = 180 / 1000 / 24 / 60 / 60 "180L/24h -> m3/s ?";
  parameter Real c_0 = 140 / 1000 "mmoll/L -> moll/L ?";
  //ALH
  Real Q_2[radial_N];
  Real c_2[radial_N];
  Real f_Na;
  parameter Real alpha = 0.8;
  //0.8 "Sodium recovery quotient ?";
  parameter Real ADH = 0.5 "anti-diuretic hormone 0-1";
  //DT
  Real Q_DT[superficial_N];
  Real c_DT[superficial_N];
  //CD
  Real Q_CD[radial_N];
  Real c_CD[radial_N];

 

equation
  alpha = f_Na * radial_L / Q_1_0 / c_0 "(4.3.16)";
  for i in 1:radial_N loop
  //DLH
    c_1[i] = c[i] "(4.3.3) c_1";
    f_Na = c[i] * f_H2O_1[i] "(4.3.8) f_H2O_1";
    Q_1[i] = Q_1_0 * c_0 / c[i] "(4.3.11) Q_1";
    c[i] = c_0 * exp(f_Na * radial_x[i] / (Q_1_0 * c_0)) "(4.3.14) c";
  //ALH
    Q_2[i] = Q_1_0 * exp(-alpha) "(4.3.18)";
    c_2[i] = c_0 * exp(alpha) + (radial_x[i] - radial_L) * f_Na * exp(alpha) / Q_1_0 "(4.3.21)";
  
  //CD
    c_CD[i] = c_0 * ((1 - ADH) * exp(alpha) * (1 - alpha) + ADH + radial_x[i] / radial_L * ADH * (exp(alpha) - 1)) "notes eq:c_CD";
    Q_CD[i] = Q_1_0 * (1 - alpha) / ((1 - ADH) * exp(alpha) * (1 - alpha) + ADH + radial_x[i] / radial_L * ADH * (exp(alpha) - 1)) "notes eq:Q_CD";
  end for;
  for i in 1:superficial_N loop
  //DT
    c_DT[i] = c_0 * (exp(alpha) * (1 - alpha) + ADH * superficial_x[i] / superficial_L * (1 - exp(alpha) * (1 - alpha))) "notes eq:c_DT";
    Q_DT[i] = Q_1_0 * (1 - alpha) / (exp(alpha) * (1 - alpha) + ADH * superficial_x[i] / superficial_L * (1 - exp(alpha) * (1 - alpha))) "notes eq:Q_DT";
  end for;
end HoppensteadtNoPDE;



within Nephron.Models;

model IsolatedProblem2
  parameter Real ADH = 1;
  parameter Real o_plasma_norm = 300;
  parameter Real[N+1] o_medulla(each start = 300, each fixed = false) "osmolarity";
  parameter Real k_H2O = 7.0e-14 "tubule permeablilit for H2O";
  constant Integer N = 15;
  parameter Real L = 0.01;
  Real[N+1] Q "water flow";
  Real[N+1] o(each start = 300, each fixed = false) "osmolarity";
  Real[N] f_H2O "water out-flow per unit length";
  Real[N] f_Na "Na out-flow per unit length";

  parameter Real dx = L/N;
initial equation  
  o_medulla = ones(N+1).*o_plasma_norm;
equation
  for i in 1:N+1 loop
    assert(Q[i] >= 0, "negative flux in tubule " + getInstanceName(), level = AssertionLevel.warning);
    assert(o[i] >= 0, "negative concentration in tubule", level = AssertionLevel.warning);
  end for;

  Q[1] = 9e-14;
  o[1] = 100;

  for i in 1:N loop
    0 = (Q[i+1] - Q[i])/dx + f_H2O[i];
    0 = (Q[i+1]*o[i+1] - Q[i]*o[i])/dx + f_Na[i];
  end for;

  for i in 1:N loop
    f_H2O[i] = ADH*k_H2O * (o_medulla[i+1] - o[i+1]);
  end for;
  f_Na = zeros(N);

  
  
end IsolatedProblem2;
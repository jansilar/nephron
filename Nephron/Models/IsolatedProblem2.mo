within Nephron.Models;
model IsolatedProblem2
  parameter Real k_H2O = 7.0e-14 "tubule permeablilit for H2O";
  constant Integer N = 15;
  parameter Real L = 0.01;
  Real[N+1] Q "water flow";
  Real[N+1] o(each start = 300, each fixed = false) "osmolarity";
  Real[N] f_H2O "water out-flow per unit length";
  parameter Real dx = L/N;
equation
  Q[1] = 9e-14;
  o[1] = 100;
  for i in 1:N loop
    0 = (Q[i+1] - Q[i])/dx + f_H2O[i];
    0 = (Q[i+1]*o[i+1] - Q[i]*o[i])/dx;
    f_H2O[i] = k_H2O * (300 - o[i+1]);
  end for;
end IsolatedProblem2;
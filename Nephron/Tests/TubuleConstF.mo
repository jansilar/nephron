within Nephron.Tests;

model TubuleConstF
  extends Nephron.Partial.Tubule(L=4, N=5);
  parameter Real f_H2O_const "water flow out throu the tubule wall per unit length";
  parameter Real f_Na_const "solute flow out throu the tubule wall per unit length";
//  Real qq;
equation
  f_H2O = ones(N)*f_H2O_const;
  f_Na = ones(N)*f_Na_const;
//  port_out.q = qq;
end TubuleConstF;
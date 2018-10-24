within Nephron.Tests;

model TubuleTest1
  extends Nephron.Partial.Tubule(L=1);
//  Real qq;
equation
  f_H2O = ones(N)*0.5;
  f_Na = ones(N)*0.1;
  port_in.q = -1;
  port_in.o = 0.5;
//  port_out.q = qq;
end TubuleTest1;
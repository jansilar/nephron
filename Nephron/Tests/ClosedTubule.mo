within Nephron.Tests;

model ClosedTubule
  extends Components.Partial.Tubule(L=1, N=5);
//  Real qq;
equation
  f_H2O = zeros(N);//ones(N)*0.5;
  f_Na = zeros(N);//ones(N)*0.1;
//  port_out.q = qq;
end ClosedTubule;
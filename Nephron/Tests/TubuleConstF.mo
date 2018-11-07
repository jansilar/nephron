within Nephron.Tests;

model TubuleConstF
  extends Components.Partial.Tubule(L=5, N=5);
  parameter Types.VolumeFlowRateLinearDensity f_H2O_const "water flow out throu the tubule wall per unit length";
  parameter Types.MolarFlowRateLinearDensity f_Na_const "solute flow out throu the tubule wall per unit length";
//  Real qq;
equation
  f_H2O = ones(N)*f_H2O_const;
  f_Na = ones(N)*f_Na_const;
//  port_out.q = qq;
end TubuleConstF;
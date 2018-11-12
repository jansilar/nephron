within Nephron.Components;

model DT
  extends Nephron.Components.Partial.Tubule(L=0.01);
  parameter PLT.VolumeFlowRate Q_in_norm = nephronPar.GFR1_norm/3*nephronPar.o_plasma_norm/nephronPar.o_max;
  parameter PLT.VolumeFlowRate Q_out_norm = Q_in_norm*nephronPar.o_dt_norm/nephronPar.o_plasma_norm;
  parameter Types.VolumeFlowRateLinearDensity f_H2O_max = (Q_in_norm - Q_out_norm) / L "water out-flow per unit length with no ADH";
  parameter Real k_H2O = 1.0e-10 "tubule permeablilit for H2O";
  parameter Real kkk = nephronPar.ADH*f_H2O_max;
equation
//  f_H2O = ones(N)*nephronPar.ADH*f_H2O_max;
  for i in 1:N loop
    f_H2O[i] = k_H2O*((o[i+1]+o[i]) /2.0 - nephronPar.o_plasma_norm);
  end for;
  f_Na = zeros(N);

annotation(
    Icon(graphics = {Text(origin = {-18, -17}, rotation = -90, extent = {{-48, 47}, {22, -15}}, textString = "DT"), Line(origin = {47, -2}, points = {{-19, 0}, {19, 0}}, thickness = 1, arrow = {Arrow.None, Arrow.Open}, arrowSize = 12), Text(origin = {83, -2}, rotation = -90, extent = {{-29, 14}, {29, -14}}, textString = "H2O")}));end DT;
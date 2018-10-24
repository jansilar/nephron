within Nephron.PDE;

model DLOHPDE
  extends TubulePDE(Ltub=1);
equation
  f_H2O = 0   indomain tubule;
//  f_Na = 0    indomain tubule;
  Q = 4                   indomain tubule.left;
//  c = 0.5                 indomain tubule.left;
  Q = extrapolateField(Q) indomain tubule.right;
//  c = extrapolateField(c) indomain tubule.right;
end DLOHPDE;

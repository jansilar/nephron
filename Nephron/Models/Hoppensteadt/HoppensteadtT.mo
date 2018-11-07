within Nephron.Models.Hoppensteadt;

model HoppensteadtT "hoppensteadt with arrays coppied into time variables for plotting"
  extends Hoppensteadt;
  Real Q_1_T, Q_2_T, Q_CD_T, c_1_T, c_2_T, c_CD_T;
  Real Q_DT_T, c_DT_T;
  Integer radial_I, superficial_I;
equation
  radial_I = min(floor(time+1),radial.N);
  superficial_I = min(floor(time+1),superficial.N);
  Q_1_T = Q_1[radial_I];
  Q_2_T = Q_2[radial_I];
  Q_CD_T = Q_CD[radial_I];
  c_1_T = c_1[radial_I];
  c_2_T = c_2[radial_I];
  c_CD_T = c_CD[radial_I];
  Q_DT_T = Q_DT[superficial_I];
  c_DT_T = c_DT[superficial_I];

end HoppensteadtT;

within Nephron;
model HoppensteadtNoPDET
    import print = Modelica.Utilities.Streams.print;
    extends Nephron.HoppensteadtNoPDE;
    discrete Real Q_1_T, Q_2_T, Q_CD_T, c_1_T, c_2_T, c_CD_T;
    discrete Real Q_DT_T, c_DT_T;
    Integer radial_I, superficial_I;
    
  equation
    radial_I = min(floor(time+1),radial_N);
    print("radial_I is " + String(radial_I));
    superficial_I = min(floor(time+1),superficial_N);
    
    print("Q_1[radial_I] is " + String(Q_1[radial_I]));
    print("Q_1_T is " + String(Q_1_T));
  algorithm
    Q_1_T := Q_1[radial_I];
    Q_2_T := Q_2[radial_I];
    Q_CD_T := Q_CD[radial_I];
    c_1_T := c_1[radial_I];
    c_2_T := c_2[radial_I];
    c_CD_T := c_CD[radial_I];
    Q_DT_T := Q_DT[superficial_I];
    c_DT_T := c_DT[superficial_I];

end HoppensteadtNoPDET;

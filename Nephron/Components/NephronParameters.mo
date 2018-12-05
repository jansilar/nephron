within Nephron.Components;

model NephronParameters
  extends Modelica.Icons.Record;
  parameter Integer NNeph = 2000000 "total nephron count";
  parameter Real GFR_norm = 180 "[l/day] total GFR";
  parameter PLT.VolumeFlowRate GFR1_norm = GFR_norm/1000/24/60/60/NNeph "GFR per nephron";
  parameter PLT.Concentration o_plasma_norm = 300 "normal plasma concentration";
  parameter PLT.Concentration o_max = 1200 "maximal osmolarity in medulla";
  parameter PLT.Concentration o_dt_norm = 100 "normal osmolarity in distal tubule";
  parameter Real ADH = a*ADH_mod^2 + b*ADH_mod^3 "antidiuretic hormone (vosopresin) should be in range [0,1], 
//      transformation to match urine osmolarity = 650 at ADH_mod = 0.5";
  parameter Real ADH_mod = 0.5 "ADH controll [0,1]";
protected 
  //solution of a*0.5^2+b*O.5^3 = ADH(o=650) - set osmolarity in middle
  //            1 = a + b                    - set ADH = 1 in the end
  parameter Real a = 320/125-1;
  parameter Real b = 1-a;
equation
  assert(NNeph > 0, "Number of nephrones must be > 0");
  assert(ADH>=0,"ADH must be >= 0");
  assert(ADH<=1,"ADH must be <= 1");
  annotation (
    defaultComponentName="nephronPar",
    defaultComponentPrefixes="inner"
  );
end NephronParameters;
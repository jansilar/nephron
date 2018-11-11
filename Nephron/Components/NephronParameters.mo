within Nephron.Components;

model NephronParameters
  extends Modelica.Icons.Record;
  parameter Integer NNeph = 2000000 "total nephron count";
  parameter Real GFR_norm = 180 "[l/day] total GFR";
  parameter PLT.VolumeFlowRate GFR1_norm = GFR_norm/1000/24/60/60/NNeph "GFR per nephron";
  parameter PLT.Concentration o_plasma_norm = 300 "normal plasma concentration";
  parameter PLT.Concentration o_max = 1200 "maximal osmolarity in medulla";
  parameter PLT.Concentration o_dt_norm = 100 "normal osmolarity in distal tubule";
  parameter Real ADH = 1 "antidiuretic hormone (vosopresin) should be in range [0,1]";
equation
  assert(NNeph > 0, "Number of nephrones must be > 0");
  assert(ADH>=0,"ADH must be >= 0");
  assert(ADH<=1,"ADH must be <= 1");

  annotation (
    defaultComponentName="nephronPar",
    defaultComponentPrefixes="inner"
  );
end NephronParameters;
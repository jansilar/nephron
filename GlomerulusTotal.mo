package Physiolibrary  "Modelica library for Physiology (version 2.3.2-beta)" 
  extends Modelica.Icons.Package;

  package Hydraulic  "Domain with Pressure and Volumetric Flow" 
    extends Modelica.Icons.Package;

    package Components  
      extends Modelica.Icons.Package;

      model Conductor  "Hydraulic resistor, where conductance=1/resistance" 
        extends Hydraulic.Interfaces.OnePort;
        extends Icons.HydraulicResistor;
        parameter Boolean useConductanceInput = false "=true, if external conductance value is used" annotation(Evaluate = true, HideResult = true);
        parameter Types.HydraulicConductance Conductance = 0 "Hydraulic conductance if useConductanceInput=false";
        Types.RealIO.HydraulicConductanceInput cond(start = Conductance) = c if useConductanceInput;
      protected
        Types.HydraulicConductance c;
      equation
        if not useConductanceInput then
          c = Conductance;
        end if;
        q_in.q = c * (q_in.pressure - q_out.pressure);
      end Conductor;

      model Resistor  
        extends Physiolibrary.Hydraulic.Components.Conductor(final Conductance = 1 / Resistance);
        parameter Physiolibrary.Types.HydraulicResistance Resistance "Hydraulic conductance if useConductanceInput=false";
      end Resistor;
    end Components;

    package Sensors  
      extends Modelica.Icons.SensorsPackage;

      model FlowMeasure  "Volumetric flow between ports" 
        extends Interfaces.OnePort;
        extends Modelica.Icons.RotationalSensor;
        Types.RealIO.VolumeFlowRateOutput volumeFlow "Actual volume flow rate";
      equation
        q_out.pressure = q_in.pressure;
        volumeFlow = q_in.q;
      end FlowMeasure;

      model PressureMeasure  "Hydraulic pressure at port" 
        extends Icons.PressureMeasure;
        Interfaces.HydraulicPort_a q_in;
        Types.RealIO.PressureOutput pressure "Pressure";
      equation
        pressure = q_in.pressure;
        q_in.q = 0;
      end PressureMeasure;
    end Sensors;

    package Sources  
      extends Modelica.Icons.SourcesPackage;

      model UnlimitedVolume  "Prescribed pressure at port" 
        parameter Boolean usePressureInput = false "=true, if pressure input is used" annotation(Evaluate = true, HideResult = true);
        parameter Types.Pressure P = 0 "Hydraulic pressure if usePressureInput=false";
        Types.RealIO.PressureInput pressure(start = P) = p if usePressureInput "Pressure";
        Interfaces.HydraulicPort_a y "PressureFlow output connectors";
        parameter Boolean isIsolatedInSteadyState = true "=true, if there is no flow at port in steady state";
        parameter Types.SimulationType Simulation = Types.SimulationType.NormalInit "If in equilibrium, then zero-flow equation is added.";
      protected
        Types.Pressure p;
      initial equation
        if isIsolatedInSteadyState and Simulation == Types.SimulationType.InitSteadyState then
          y.q = 0;
        end if;
      equation
        if not usePressureInput then
          p = P;
        end if;
        y.pressure = p;
        if isIsolatedInSteadyState and Simulation == Types.SimulationType.SteadyState then
          y.q = 0;
        end if;
      end UnlimitedVolume;
    end Sources;

    package Interfaces  
      extends Modelica.Icons.InterfacesPackage;

      connector HydraulicPort  "Hydraulical connector with pressure and volumetric flow" 
        Types.Pressure pressure "Pressure";
        flow Types.VolumeFlowRate q "Volume flow";
      end HydraulicPort;

      connector HydraulicPort_a  "Hydraulical inflow connector" 
        extends HydraulicPort;
      end HydraulicPort_a;

      connector HydraulicPort_b  "Hydraulical outflow connector" 
        extends HydraulicPort;
      end HydraulicPort_b;

      partial model OnePort  "Hydraulical OnePort" 
        HydraulicPort_a q_in "Volume inflow";
        HydraulicPort_b q_out "Volume outflow";
        Types.VolumeFlowRate volumeFlowRate "Volumetric flow";
        Types.Pressure dp "Pressure gradient";
      equation
        q_in.q + q_out.q = 0;
        volumeFlowRate = q_in.q;
        dp = q_in.pressure - q_out.pressure;
      end OnePort;
    end Interfaces;
  end Hydraulic;

  package Icons  "Icons for physiological models" 
    extends Modelica.Icons.Package;

    partial class HydraulicResistor  end HydraulicResistor;

    class PressureMeasure  end PressureMeasure;
  end Icons;

  package Types  "Physiological units with nominals" 
    extends Modelica.Icons.Package;

    package RealIO  
      extends Modelica.Icons.Package;
      connector PressureInput = input Pressure "input Pressure as connector";
      connector PressureOutput = output Pressure "output Pressure as connector";
      connector VolumeFlowRateOutput = output VolumeFlowRate "output VolumeFlowRate as connector";
      connector HydraulicConductanceInput = input HydraulicConductance "input HydraulicConductance as connector";
    end RealIO;

    type Density = Modelica.SIunits.Density(displayUnit = "kg/l", nominal = 1e3);
    type Acceleration = Modelica.SIunits.Acceleration(displayUnit = "m/s2", nominal = 1);
    type Pressure = Modelica.SIunits.Pressure(displayUnit = "mmHg", nominal = 133.322387415);
    type VolumeFlowRate = Modelica.SIunits.VolumeFlowRate(displayUnit = "ml/min", nominal = 1e-6 / 60);
    replaceable type Concentration = Modelica.SIunits.Concentration(displayUnit = "mmol/l", min = 0) constrainedby Real;
    type HydraulicConductance = Real(final quantity = "HydraulicConductance", final unit = "m3/(Pa.s)", displayUnit = "ml/(mmHg.min)", nominal = 1e-6 / (133.322387415 * 60), min = 0);
    type HydraulicResistance = Real(final quantity = "HydraulicConductance", final unit = "(Pa.s)/m3", displayUnit = "(mmHg.min)/ml", nominal = 1e+6 * 133.322387415 * 60, min = 0);
    type SimulationType = enumeration(NoInit "Use start values only as a guess of state values", NormalInit "Initialization by start values", ReadInit "Initialization by function Utilities.readReal('state name')", InitSteadyState "Initialization in Steady State (initial derivations are zeros)", SteadyState "Steady State = Derivations are zeros during simulation") "Initialization or Steady state options (to determine model type before simulating)" annotation(Evaluate = true);
  end Types;
  annotation(version = "2.3.2-beta", versionBuild = 1, versionDate = "2015-09-15", dateModified = "2015-09-15 12:49:00Z"); 
end Physiolibrary;

package Nephron  
  extends Modelica.Icons.Package;

  package Components  
    extends Modelica.Icons.Package;

    model PressureD  
      parameter Real dP(unit = "Pa") = 0 "pressure difference";
      Physiolibrary.Hydraulic.Interfaces.HydraulicPort_a port_a;
      Physiolibrary.Hydraulic.Interfaces.HydraulicPort_b port_b;
    equation
      port_a.q + port_b.q = 0;
      port_b.pressure - port_a.pressure = dP;
    end PressureD;

    model NephronParameters  
      extends Modelica.Icons.Record;
      parameter Integer NNeph = 2000000 "total nephron count";
      parameter Real GFR_norm = 180 "[l/day] total GFR";
      parameter .Physiolibrary.Types.VolumeFlowRate GFR1_norm = GFR_norm / 1000 / 24 / 60 / 60 / NNeph "GFR per nephron";
      parameter .Physiolibrary.Types.Concentration o_plasma_norm = 300 "normal plasma concentration";
      parameter .Physiolibrary.Types.Concentration o_max = 1200 "maximal osmolarity in medulla";
      parameter .Physiolibrary.Types.Concentration o_dt_norm = 100 "normal osmolarity in distal tubule";
      parameter Real ADH = 1 "antidiuretic hormone (vosopresin) should be in range [0,1]";
    equation
      assert(NNeph > 0, "Number of nephrones must be > 0");
      assert(ADH >= 0, "ADH must be >= 0");
      assert(ADH <= 1, "ADH must be <= 1");
      annotation(defaultComponentPrefixes = "inner"); 
    end NephronParameters;

    model FlowPressureMeasure  
      extends Physiolibrary.Hydraulic.Sensors.FlowMeasure;
      outer Components.NephronParameters nephronPar;
      Physiolibrary.Types.RealIO.PressureOutput pressure;
      Modelica.Blocks.Interfaces.RealOutput volumeFlowRateTot "flow rate per both kidneys [L/day]";
    equation
      assert(nephronPar.NNeph > 0, "NNep must be greater than zero.");
      volumeFlowRateTot = nephronPar.NNeph * volumeFlowRate * 1e3 * 60 * 60 * 24;
      pressure = q_in.pressure;
    end FlowPressureMeasure;
  end Components;

  package Models  
    extends Modelica.Icons.Package;

    model Glomerulus  
      constant Real tor2pasc = 133.322387415;
      parameter .Physiolibrary.Types.Pressure MAP_norm = 84 * tor2pasc "blood pressure befor afferent arteriole, https://en.wikipedia.org/wiki/Blood_pressure, https://www.omnicalculator.com/health/mean-arterial-pressure";
      parameter Real MAP_mod = 1;
      parameter .Physiolibrary.Types.Pressure MAP = MAP_mod * 84 * tor2pasc "blood pressure befor afferent arteriole, https://en.wikipedia.org/wiki/Blood_pressure, https://www.omnicalculator.com/health/mean-arterial-pressure";
      parameter .Physiolibrary.Types.Pressure P_diff_a = MAP - pi_blood "hydrostatic minus oncotic arterial pressure";
      parameter .Physiolibrary.Types.Pressure CVP = 6 * tor2pasc "blood pressure after efferent arteriole, https://en.wikipedia.org/wiki/Central_venous_pressure";
      parameter .Physiolibrary.Types.Pressure P_diff_e = CVP - pi_blood "hydrostatic minus oncotic venous pressure";
      parameter .Physiolibrary.Types.Pressure P_bowm = 10 * tor2pasc "primary urine pressure in bowman capsule, papír od Honzy Živnýho";
      parameter .Physiolibrary.Types.Pressure normal_P_Filter = 6 * tor2pasc "normal filtration pressure, papír od HŽ";
      parameter .Physiolibrary.Types.Pressure normal_P_Glom = normal_P_Filter + P_bowm + pi_blood - pi_bowm "hydrostatic pressure in glomerular capilaries";
      parameter .Physiolibrary.Types.Pressure pi_bowm = 0 "Oncotic pressure of primary urine, říkal Honza Živný";
      parameter .Physiolibrary.Types.Pressure pi_blood = 30 * tor2pasc "oncotic pressure of blood, papír od HŽ, 28 v en.wikipedia.org/wiki/Oncotic_pressure";
      parameter .Physiolibrary.Types.VolumeFlowRate CO = 5 / 60 / 1000 "cardiac output";
      parameter .Physiolibrary.Types.VolumeFlowRate RBF1 = CO * 0.2 / N "blood flow into each glomerulus";
      parameter .Physiolibrary.Types.VolumeFlowRate GFR1 = 180 / 1000 / 24 / 60 / 60 / N "primary urine production per each nephron";
      parameter Real R_aff_mod = 1;
      parameter Real R_eff_mod = 1;
      parameter .Physiolibrary.Types.HydraulicResistance R_aff = R_aff_mod * (MAP_norm - normal_P_Glom) / RBF1 "afferent arteriol resistance";
      parameter .Physiolibrary.Types.HydraulicResistance R_eff = R_eff_mod * (normal_P_Glom - CVP) / (RBF1 - GFR1) "efferent arteriol resistance";
      parameter Real R_filter_mod = 1 "qotient to modify R_filter";
      parameter .Physiolibrary.Types.HydraulicResistance R_filter = R_filter_mod * normal_P_Filter / GFR1 "efferent arteriol resistance";
      parameter .Physiolibrary.Types.Density rho = 1060 "blood density";
      parameter .Physiolibrary.Types.Acceleration g = 9.8 "gravitational acceleration";
      parameter Integer N = 2000000 "Number of nephrones in both kidneys";
      Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodSource(P(displayUnit = "Pa") = MAP);
      Physiolibrary.Hydraulic.Components.Resistor afferentResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_aff);
      Physiolibrary.Hydraulic.Components.Resistor efferentResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_eff);
      Physiolibrary.Hydraulic.Sources.UnlimitedVolume bloodDrain(P(displayUnit = "Pa") = CVP);
      Physiolibrary.Hydraulic.Components.Resistor filterResistance(Resistance(displayUnit = "(Pa.s)/m3") = R_filter);
      Physiolibrary.Hydraulic.Sources.UnlimitedVolume urineDrain(P(displayUnit = "Pa") = P_bowm);
      Nephron.Components.PressureD osmoticBlood(dP = -pi_blood);
      Nephron.Components.PressureD pressureD1(dP = -pi_bowm);
      Physiolibrary.Hydraulic.Sensors.PressureMeasure GBHP;
      inner Nephron.Components.NephronParameters nephronPar;
      Nephron.Components.FlowPressureMeasure measureAff;
      Components.FlowPressureMeasure measureGFR;
      Nephron.Components.FlowPressureMeasure measureEff;
    equation
      connect(measureEff.q_out, bloodDrain.y);
      connect(efferentResistance.q_out, measureEff.q_in);
      connect(measureGFR.q_out, pressureD1.port_b);
      connect(filterResistance.q_out, measureGFR.q_in);
      connect(measureAff.q_out, afferentResistance.q_in);
      connect(bloodSource.y, measureAff.q_in);
      connect(afferentResistance.q_out, GBHP.q_in);
      connect(pressureD1.port_a, urineDrain.y);
      connect(osmoticBlood.port_b, filterResistance.q_in);
      connect(afferentResistance.q_out, osmoticBlood.port_a);
      connect(afferentResistance.q_out, efferentResistance.q_in);
    end Glomerulus;
  end Models;
end Nephron;

package Modelica  "Modelica Standard Library - Version 3.2.2" 
  extends Modelica.Icons.Package;

  package Blocks  "Library of basic input/output control blocks (continuous, discrete, logical, table blocks)" 
    extends Modelica.Icons.Package;

    package Interfaces  "Library of connectors and partial models for input/output blocks" 
      extends Modelica.Icons.InterfacesPackage;
      connector RealOutput = output Real "'output Real' as connector";
    end Interfaces;
  end Blocks;

  package Icons  "Library of icons" 
    extends Icons.Package;

    partial package Package  "Icon for standard packages" end Package;

    partial package InterfacesPackage  "Icon for packages containing interfaces" 
      extends Modelica.Icons.Package;
    end InterfacesPackage;

    partial package SourcesPackage  "Icon for packages containing sources" 
      extends Modelica.Icons.Package;
    end SourcesPackage;

    partial package SensorsPackage  "Icon for packages containing sensors" 
      extends Modelica.Icons.Package;
    end SensorsPackage;

    partial class RotationalSensor  "Icon representing a round measurement device" end RotationalSensor;

    partial record Record  "Icon for records" end Record;
  end Icons;

  package SIunits  "Library of type and unit definitions based on SI units according to ISO 31-1992" 
    extends Modelica.Icons.Package;
    type Acceleration = Real(final quantity = "Acceleration", final unit = "m/s2");
    type Density = Real(final quantity = "Density", final unit = "kg/m3", displayUnit = "g/cm3", min = 0.0);
    type Pressure = Real(final quantity = "Pressure", final unit = "Pa", displayUnit = "bar");
    type VolumeFlowRate = Real(final quantity = "VolumeFlowRate", final unit = "m3/s");
    type Concentration = Real(final quantity = "Concentration", final unit = "mol/m3");
  end SIunits;
  annotation(version = "3.2.2", versionBuild = 3, versionDate = "2016-04-03", dateModified = "2016-04-03 08:44:41Z"); 
end Modelica;

model Glomerulus_total
  extends Nephron.Models.Glomerulus;
end Glomerulus_total;

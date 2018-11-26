package Physiolibrary  "Modelica library for Physiology (version 2.3.2-beta)" 
  extends Modelica.Icons.Package;

  package Types  "Physiological units with nominals" 
    extends Modelica.Icons.Package;

    package RealIO  
      extends Modelica.Icons.Package;
      connector OsmolarityOutput = output Osmolarity "output Concentration as connector";
      connector VolumeFlowRateOutput = output VolumeFlowRate "output VolumeFlowRate as connector";
    end RealIO;

    type Position = Modelica.SIunits.Position(displayUnit = "cm", nominal = 1e-2);
    type VolumeFlowRate = Modelica.SIunits.VolumeFlowRate(displayUnit = "ml/min", nominal = 1e-6 / 60);
    replaceable type Concentration = Modelica.SIunits.Concentration(displayUnit = "mmol/l", min = 0) constrainedby Real;
    type Osmolarity = Modelica.SIunits.Concentration(displayUnit = "mosm/l", nominal = 1);
  end Types;

  package Osmotic  "Please use 'Chemical' library instead!" 
    extends Modelica.Icons.Package;

    package Sensors  
      extends Modelica.Icons.SensorsPackage;

      model FlowMeasure  "Measurement of flux through semipermeable membrane" 
        extends Interfaces.OnePort;
        extends Modelica.Icons.RotationalSensor;
        Types.RealIO.VolumeFlowRateOutput volumeFlowRate "Flux through membrane";
      equation
        q_out.o = q_in.o;
        volumeFlowRate = q_in.q;
      end FlowMeasure;
    end Sensors;

    package Interfaces  
      extends Modelica.Icons.InterfacesPackage;

      connector OsmoticPort  "Flux through semipermeable membrane by osmotic pressure gradient" 
        Types.Concentration o "Osmolarity is the molar concentration of the impermeable solutes";
        flow Types.VolumeFlowRate q "The flux of the permeable solvent (!not the impermeable solutes!)";
      end OsmoticPort;

      connector OsmoticPort_a  "Influx" 
        extends OsmoticPort;
      end OsmoticPort_a;

      connector OsmoticPort_b  "Outflux" 
        extends OsmoticPort;
      end OsmoticPort_b;

      partial model OnePort  "Osmotic one port" 
        OsmoticPort_a q_in "Forward flux through membrane";
        OsmoticPort_b q_out "Backward flux through membrane";
      equation
        q_in.q + q_out.q = 0;
      end OnePort;
    end Interfaces;
  end Osmotic;
  annotation(version = "2.3.2-beta", versionBuild = 1, versionDate = "2015-09-15", dateModified = "2015-09-15 12:49:00Z"); 
end Physiolibrary;

package Nephron  
  extends Modelica.Icons.Package;

  package Types  
    extends Modelica.Icons.Package;
    type MolarFlowRateLinearDensity = Real(final quantity = "MolarFlowRateLinearDensity", final unit = "mol/(s.m)", displayUnit = "mmol/(min.cm)");
    type VolumeFlowRateLinearDensity = Real(final quantity = "VolumeFlowRateLinearDensity", final unit = "m2/s", displayUnit = "cm2/min");
  end Types;

  package Components  
    extends Modelica.Icons.Package;

    package Partial  
      extends Modelica.Icons.Package;

      partial model Tubule  
        outer Components.NephronParameters nephronPar;
        constant Integer N = 10;
        parameter .Physiolibrary.Types.Position L;
        .Physiolibrary.Types.VolumeFlowRate[N + 1] Q "water flow";
        .Physiolibrary.Types.Concentration[N + 1] o(each start = 300, each fixed = false) "osmolarity";
        Types.VolumeFlowRateLinearDensity[N] f_H2O "water out-flow per unit length";
        Types.MolarFlowRateLinearDensity[N] f_Na "Na out-flow per unit length";
        Physiolibrary.Osmotic.Interfaces.OsmoticPort_a port_in;
        Physiolibrary.Osmotic.Interfaces.OsmoticPort_b port_out;
        parameter .Physiolibrary.Types.Position dx = L / N;
      equation
        for i in 1:N + 1 loop
          assert(Q[i] >= 0, "negative flux in tubule " + getInstanceName(), AssertionLevel.warning);
          assert(o[i] >= 0, "negative concentration in tubule", AssertionLevel.warning);
        end for;
        Q[1] = port_in.q;
        o[1] = port_in.o;
        for i in 1:N loop
          0 = (Q[i + 1] - Q[i]) / dx + f_H2O[i];
          0 = (Q[i + 1] * o[i + 1] - Q[i] * o[i]) / dx + f_Na[i];
        end for;
        -Q[N + 1] = port_out.q;
        o[N + 1] = port_out.o;
      end Tubule;

      partial model TubuleADH  
        extends Nephron.Components.Partial.Tubule;
        parameter .Physiolibrary.Types.Concentration[N + 1] o_medulla(each start = 300, each fixed = false) "osmolarity";
        parameter Real k_H2O = 7.0e-14 "tubule permeablilit for H2O";
        Real[N] testVal;
      equation
        for i in 1:N loop
          f_H2O[i] = nephronPar.ADH * k_H2O * (o_medulla[i + 1] + o_medulla[i] - o[i + 1] - o[i]) / 2.0;
          testVal[i] = (o_medulla[i + 1] + o_medulla[i] - o[i + 1] - o[i]) / 2.0;
        end for;
        f_Na = zeros(N);
      end TubuleADH;
    end Partial;

    model PT  
      extends Partial.Tubule(L = 0.05);
      Types.VolumeFlowRateLinearDensity f_H2O_const = Q[1] / L * k_reabs;
      parameter Real k_reabs = 2.0 / 3.0;
    equation
      o[2:N + 1] = ones(N) * o[1];
      f_H2O = ones(N) * f_H2O_const;
    end PT;

    model DLOH  
      extends Partial.Tubule(L = 0.04);
      parameter .Physiolibrary.Types.Concentration[N + 1] oMed = linspace(nephronPar.o_plasma_norm, nephronPar.o_max, N + 1);
    equation
      f_Na = zeros(N) "impermeable for Na";
      o[2:N + 1] = oMed[2:N + 1] "wather leavs the tubule so that osmolarity equalizes with medula";
    end DLOH;

    model OsmoticSource  
      outer Components.NephronParameters nephronPar;
      Physiolibrary.Osmotic.Interfaces.OsmoticPort_b port_b;
      parameter .Physiolibrary.Types.VolumeFlowRate Q = nephronPar.GFR1_norm "water flow";
      parameter .Physiolibrary.Types.Concentration o = nephronPar.o_plasma_norm "osmolarity";
    equation
      port_b.q = -Q;
      port_b.o = o;
    end OsmoticSource;

    model OsmoticDrain  
      Physiolibrary.Osmotic.Interfaces.OsmoticPort_a port_a;
    end OsmoticDrain;

    model FlowOsmosisMeasure  
      extends Physiolibrary.Osmotic.Sensors.FlowMeasure;
      outer Components.NephronParameters nephronPar;
      Physiolibrary.Types.RealIO.OsmolarityOutput osmolarity;
      Modelica.Blocks.Interfaces.RealOutput volumeFlowRateTot "flow rate per both kidneys [L/day]";
    equation
      assert(nephronPar.NNeph > 0, "NNep must be greater than zero.");
      volumeFlowRateTot = nephronPar.NNeph * volumeFlowRate * 1e3 * 60 * 60 * 24;
      osmolarity = q_in.o;
    end FlowOsmosisMeasure;

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

    model ALOH  
      function LimitFactor  
        input Real o;
        input Real o_treshold;
        output Real fac;
      algorithm
        fac := max(0.0, min(1.0, o / o_treshold));
      end LimitFactor;

      extends Nephron.Components.Partial.Tubule(L = 0.04, N = 40);
      parameter .Physiolibrary.Types.VolumeFlowRate Q_in_norm = nephronPar.GFR1_norm / 3 * nephronPar.o_plasma_norm / nephronPar.o_max;
      parameter Types.MolarFlowRateLinearDensity f_Na_const = Q_in_norm * (nephronPar.o_max - nephronPar.o_dt_norm) / L;
    equation
      f_H2O = zeros(N);
      f_Na = f_Na_const * {LimitFactor(o[i], 100) for i in 1:N};
    end ALOH;

    model DT  
      extends Nephron.Components.Partial.TubuleADH(L = 0.01);
    initial equation
      o_medulla = ones(N + 1) * nephronPar.o_plasma_norm;
    end DT;

    model CD  
      extends Nephron.Components.Partial.TubuleADH(L = 0.04, k_H2O = 6.0e-15);
    initial equation
      o_medulla = linspace(nephronPar.o_plasma_norm, nephronPar.o_max, N + 1);
    end CD;
  end Components;

  package Models  
    extends Modelica.Icons.Package;

    model NephronModel  
      parameter Real gfr_mod = 1;
      inner Nephron.Components.NephronParameters nephronPar;
      Nephron.Components.OsmoticSource glomerulus(Q = gfr_mod * nephronPar.GFR1_norm);
      Nephron.Components.DLOH dloh;
      Nephron.Components.PT pt;
      Nephron.Components.FlowOsmosisMeasure measureGlom;
      Nephron.Components.FlowOsmosisMeasure measurePT;
      Nephron.Components.FlowOsmosisMeasure measureDLH;
      Nephron.Components.OsmoticDrain osmoticDrain;
      Nephron.Components.ALOH aloh;
      Nephron.Components.FlowOsmosisMeasure measureALOH;
      Nephron.Components.DT dt;
      Nephron.Components.FlowOsmosisMeasure measureDT;
      Nephron.Components.CD cd;
      Nephron.Components.FlowOsmosisMeasure cdMeasure;
    equation
      connect(cdMeasure.q_out, osmoticDrain.port_a);
      connect(cd.port_out, cdMeasure.q_in);
      connect(measureDT.q_out, cd.port_in);
      connect(dt.port_out, measureDT.q_in);
      connect(measureALOH.q_out, dt.port_in);
      connect(measureALOH.q_in, aloh.port_out);
      connect(measureDLH.q_out, aloh.port_in);
      connect(dloh.port_out, measureDLH.q_in);
      connect(measurePT.q_out, dloh.port_in);
      connect(pt.port_out, measurePT.q_in);
      connect(measureGlom.q_out, pt.port_in);
      connect(glomerulus.port_b, measureGlom.q_in);
      annotation(experiment(StartTime = 0, StopTime = 0.0001, Tolerance = 1e-6, Interval = 2e-7)); 
    end NephronModel;
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

    partial package SensorsPackage  "Icon for packages containing sensors" 
      extends Modelica.Icons.Package;
    end SensorsPackage;

    partial class RotationalSensor  "Icon representing a round measurement device" end RotationalSensor;

    partial record Record  "Icon for records" end Record;
  end Icons;

  package SIunits  "Library of type and unit definitions based on SI units according to ISO 31-1992" 
    extends Modelica.Icons.Package;
    type Length = Real(final quantity = "Length", final unit = "m");
    type Position = Length;
    type VolumeFlowRate = Real(final quantity = "VolumeFlowRate", final unit = "m3/s");
    type Concentration = Real(final quantity = "Concentration", final unit = "mol/m3");
  end SIunits;
  annotation(version = "3.2.2", versionBuild = 3, versionDate = "2016-04-03", dateModified = "2016-04-03 08:44:41Z"); 
end Modelica;

model NephronModel_total
  extends Nephron.Models.NephronModel;
 annotation(experiment(StartTime = 0, StopTime = 0.0001, Tolerance = 1e-6, Interval = 2e-7));
end NephronModel_total;

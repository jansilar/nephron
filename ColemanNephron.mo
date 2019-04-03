within ;
package ColemanNephron
  package Parts
    model Glomerular_Filtration
      Physiolibrary.Types.RealIO.PressureInput RAP "Renal artery pressure"
        annotation (Placement(transformation(extent={{-130,68},{-90,108}}),
            iconTransformation(extent={{-120,80},{-100,100}})));
      Physiolibrary.Types.RealIO.VolumeFlowRateInput RBF "Renal blood flow"
        annotation (Placement(transformation(extent={{-130,-18},{-90,22}}),
            iconTransformation(extent={{-120,-10},{-100,10}})));
      Physiolibrary.Types.RealIO.VolumeFlowRateInput RPF "Renal plasma flow"
        annotation (Placement(transformation(extent={{-130,-48},{-90,-8}}),
            iconTransformation(extent={{-120,-40},{-100,-20}})));
      Physiolibrary.Types.RealIO.MassConcentrationInput APr
        "Plasma protein concentration" annotation (Placement(transformation(extent={
                {-130,-76},{-90,-36}}), iconTransformation(extent={{-120,-70},{-100,
                -50}})));
      Physiolibrary.Types.RealIO.HydraulicConductanceInput GKf
        "Glomerular membrane conductivity" annotation (Placement(transformation(
              extent={{-130,-106},{-90,-66}}), iconTransformation(extent={{-120,-98},
                {-100,-78}})));
      Physiolibrary.Types.RealIO.VolumeFlowRateOutput GFR( start=120)
        "Glomerular filtration rate" annotation (Placement(transformation(extent={{100,-4},
                {124,20}}),     iconTransformation(extent={{100,-96},{120,-76}})));
      Physiolibrary.Types.RealIO.HydraulicConductanceInput AffC
        "Afferent artery conductance" annotation (Placement(transformation(extent={{-136,26},
                {-96,66}}),             iconTransformation(extent={{-120,50},{-100,70}})));
      Physiolibrary.Types.RealIO.HydraulicConductanceInput TubC
        "Tubule conductance" annotation (Placement(transformation(extent={{-130,-146},
                {-90,-106}}),iconTransformation(extent={{-120,22},{-100,42}})));
      Physiolibrary.Types.RealIO.PressureOutput PTP "Proximal tubule pressure"
        annotation (Placement(transformation(extent={{74,46},{94,66}}),
            iconTransformation(extent={{100,78},{120,98}})));
      Physiolibrary.Types.RealIO.PressureOutput GP "Glomerular pressure"
        annotation (Placement(transformation(extent={{82,-56},{102,-36}}),
            iconTransformation(extent={{100,58},{120,78}})));
      Physiolibrary.Types.RealIO.PressureOutput AVeCOP
        "Average colloid osmotic pressure" annotation (Placement(transformation(
              extent={{80,20},{100,40}}),  iconTransformation(extent={{100,38},{120,
                58}})));
      Physiolibrary.Types.RealIO.FractionOutput FF "Filtration fraction"
        annotation (Placement(transformation(extent={{98,-36},{118,-16}}),
            iconTransformation(extent={{100,-48},{120,-28}})));
      Physiolibrary.Types.RealIO.PressureOutput ACOP
        "Afferent colloid osmotic pressure" annotation (Placement(transformation(
              extent={{50,62},{70,82}}),   iconTransformation(extent={{100,18},{120,
                38}})));
      Physiolibrary.Types.RealIO.PressureOutput ECOP
        "Efferent colloid osmotic pressure" annotation (Placement(transformation(
              extent={{96,82},{116,102}}), iconTransformation(extent={{100,-2},{120,
                18}})));

      Physiolibrary.Types.RealIO.MassConcentrationOutput EPr
        "Efferent protein concentration" annotation (Placement(transformation(
              extent={{72,-84},{92,-64}}), iconTransformation(extent={{100,-70},{120,
                -50}})));
      Physiolibrary.Types.RealIO.PressureOutput NETP
        "Net pressure gradient in glomerulus" annotation (Placement(transformation(
              extent={{96,82},{116,102}}), iconTransformation(extent={{100,-22},{120,
                -2}})));

      parameter Real A=320;//*133.3224*0.0001;
      //Landis-Papanheimer coefficient 320 torr/g/ml = 320 *133.322*1000 Pa/kg/m3
      parameter Real B=1160;//*133.3224*0.0001;
      //Landis-Papanheimer coefficient 1160 torr/g/ml = 320 *133.322*1000 Pa/kg/m3
      Real APr_g_ml = APr*0.001;
      Real EPr_g_ml = EPr*0.001;
    equation
      GP=RAP-RBF/AffC;
      PTP=GFR/TubC;
      NETP=GP-PTP-AVeCOP;
      GFR=GKf*NETP;
      FF=GFR/RPF;
      EPr=APr/(1-FF);
      ACOP=(A*APr_g_ml+B*APr_g_ml*APr_g_ml)*133.3224;
      ECOP=(A*EPr_g_ml+B*EPr_g_ml*EPr_g_ml)*133.3224;
      AVeCOP=(ACOP+ECOP)/2;

      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-98,-82},{-4,-94}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              textString="GKf",
              horizontalAlignment=TextAlignment.Left),
            Text(
              extent={{-98,-56},{-4,-68}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="APr"),
            Text(
              extent={{-96,-26},{-2,-38}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="RPF"),
            Text(
              extent={{-98,6},{-4,-6}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="RBF"),
            Text(
              extent={{-98,38},{-4,26}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="TubC"),
            Text(
              extent={{-98,66},{-4,54}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="AffC"),
            Text(
              extent={{-98,96},{-4,84}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="RAP"),
            Text(
              extent={{2,-78},{96,-90}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="GFR"),
            Text(
              extent={{-62,30},{52,-28}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              textString="GLOMERULAR
FILTRATION"),
            Text(
              extent={{4,70},{98,58}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="GP"),
            Text(
              extent={{4,94},{98,82}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="PTP"),
            Text(
              extent={{2,54},{96,42}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="AVeCOP"),
            Text(
              extent={{0,-30},{94,-42}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="FF"),
            Text(
              extent={{4,32},{98,20}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="ACOP"),
            Text(
              extent={{4,12},{98,0}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="ECOP"),
            Text(
              extent={{4,-54},{98,-66}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="EPr"),
            Text(
              extent={{2,-6},{96,-18}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="NETP")}),
                                  Diagram(coordinateSystem(preserveAspectRatio=false)));
    end Glomerular_Filtration;

    function Lands_Pappenheimer "oncotic pressure calculation"
      input Physiolibrary.Types.MassConcentration proteinConcentration;
      output Physiolibrary.Types.Pressure Pressure;
      output Real ProteinConcentration_g_ml;
      output Real Pressure_mmHg;
    protected
      Real A=320;
      Real B=1160;
    algorithm
      ProteinConcentration_g_ml:=proteinConcentration*0.001;                                                      //kg/m3 ->g/ml
      Pressure_mmHg:=A*ProteinConcentration_g_ml + B*ProteinConcentration_g_ml*
        ProteinConcentration_g_ml;
      Pressure:=Pressure_mmHg*133.3224;//mmHg->Pa
    end Lands_Pappenheimer;

    model RenalPerfusion
      Physiolibrary.Types.RealIO.HydraulicConductanceInput AffC
        "Afferent artery conductance" annotation (Placement(transformation(extent={{-136,26},
                {-96,66}}),             iconTransformation(extent={{-120,76},{-100,96}})));
      Physiolibrary.Types.RealIO.HydraulicConductanceInput EffC
        "Efferent artery conductance" annotation (Placement(transformation(extent={{
                -136,26},{-96,66}}), iconTransformation(extent={{-120,46},{-100,66}})));
      Physiolibrary.Types.RealIO.HydraulicConductanceInput RenVenC
        "Renal venous conductance" annotation (Placement(transformation(extent={{-136,
                26},{-96,66}}), iconTransformation(extent={{-120,18},{-100,38}})));
      Physiolibrary.Types.RealIO.PressureInput AP "Arterial pressure" annotation (
          Placement(transformation(extent={{-130,68},{-90,108}}),
            iconTransformation(extent={{-120,-14},{-100,6}})));
      Physiolibrary.Types.RealIO.PressureInput VP "Arterial pressure" annotation (
          Placement(transformation(extent={{-130,68},{-90,108}}),
            iconTransformation(extent={{-120,-40},{-100,-20}})));
      Physiolibrary.Types.RealIO.PressureInput Clamp
        "Clamp (drop pressure in reanal artery)" annotation (Placement(
            transformation(extent={{-130,68},{-90,108}}), iconTransformation(extent=
               {{-120,-70},{-100,-50}})));
      Physiolibrary.Types.RealIO.FractionInput Hct annotation (Placement(
            transformation(extent={{-226,-98},{-186,-58}}), iconTransformation(
              extent={{-120,-98},{-100,-78}})));
      Physiolibrary.Types.RealIO.VolumeFlowRateOutput RBF "Reanl blood flow rate"
        annotation (Placement(transformation(extent={{-200,192},{-180,212}}),
            iconTransformation(extent={{100,38},{120,58}})));
      Physiolibrary.Types.RealIO.PressureOutput RAP "Reanl artery pressure"
        annotation (Placement(transformation(extent={{-214,160},{-194,180}}),
            iconTransformation(extent={{100,72},{120,92}})));
      Physiolibrary.Types.RealIO.VolumeFlowRateOutput RPF "Reanl plasma flow rate"
        annotation (Placement(transformation(extent={{-200,192},{-180,212}}),
            iconTransformation(extent={{100,8},{120,28}})));
      Physiolibrary.Types.RealIO.HydraulicConductanceOutput TotRenC
        "Total renal vascular conductance" annotation (Placement(transformation(
              extent={{-222,-6},{-202,14}}), iconTransformation(extent={{100,-36},{120,
                -16}})));

    equation
      TotRenC=1/(1/AffC+1/EffC+1/RenVenC);
      RAP=AP-Clamp;
      RBF=TotRenC*(RAP-VP);
      RPF=RBF*(1-Hct);

      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.Solid),
            Text(
              extent={{-98,92},{-4,80}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="AffC"),
            Text(
              extent={{-52,30},{74,-4}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              textString="RENAL
PERFUSION"),Text(
              extent={{-96,62},{-2,50}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="EffC"),
            Text(
              extent={{-96,34},{-2,22}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="RenVenC"),
            Text(
              extent={{-98,2},{-4,-10}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="AP"),
            Text(
              extent={{-98,-22},{-4,-34}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="VP"),
            Text(
              extent={{-98,-52},{-4,-64}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="Clamp"),
            Text(
              extent={{-98,-80},{-4,-92}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Left,
              textString="Hct"),
            Text(
              extent={{4,90},{98,78}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="RAP"),
            Text(
              extent={{4,54},{98,42}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="RBF"),
            Text(
              extent={{4,24},{98,12}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="RPF"),
            Text(
              extent={{4,-20},{98,-32}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.None,
              horizontalAlignment=TextAlignment.Right,
              textString="TotRenC")}),
                                   Diagram(coordinateSystem(preserveAspectRatio=false)));
    end RenalPerfusion;

    model MyogenicReflex
      Physiolibrary.Types.RealIO.PressureInput RAP "Renal artery pressure"
        annotation (Placement(transformation(extent={{-122,-2},{-90,30}}),
            iconTransformation(extent={{-126,-12},{-100,14}})));
      Physiolibrary.Types.RealIO.FractionOutput AffMyo
        "Myogenic effect (fraction relative to normal)" annotation (Placement(
            transformation(extent={{70,20},{90,40}}),   iconTransformation(extent={{
                100,-10},{120,10}})));
      Modelica.Blocks.Math.Feedback feedback
        annotation (Placement(transformation(extent={{-72,4},{-52,24}})));

      Physiolibrary.Blocks.Factors.Spline spline(data=[-30,1.5,0; 0,1,-0.02; 80,0.5,
            0], Xscale=1/133.3224)
        annotation (Placement(transformation(extent={{16,30},{52,66}})));
      Physiolibrary.Blocks.Math.Integrator int(y_start=100)
        annotation (Placement(transformation(extent={{58,-2},{78,18}})));
      Physiolibrary.Types.Constants.FractionConst
                                    fraction(k(displayUnit="1") = 1)
        annotation (Placement(transformation(extent={{-44,82},{-36,90}})));
      Physiolibrary.Blocks.Math.Reciprocal rec
        annotation (Placement(transformation(extent={{-30,-28},{-16,-14}})));
      Physiolibrary.Types.Constants.TimeConst AffTau(k=14400)
        annotation (Placement(transformation(extent={{-50,-26},{-38,-14}})));
      Modelica.Blocks.Math.Product product
        annotation (Placement(transformation(extent={{24,-2},{44,18}})));
    equation
      connect(feedback.u1, RAP)
        annotation (Line(points={{-70,14},{-106,14}},
                                                    color={0,0,127}));
      connect(spline.y, AffMyo)
        annotation (Line(points={{34,40.8},{34,30},{80,30}}, color={0,0,127}));
      connect(int.y, feedback.u2) annotation (Line(points={{79,8},{90,8},{90,
              -36},{-62,-36},{-62,6}},
                              color={0,0,127}));
      connect(fraction.y, spline.yBase)
        annotation (Line(points={{-35,86},{34,86},{34,51.6}}, color={0,0,127}));
      connect(int.u, product.y)
        annotation (Line(points={{56,8},{45,8}}, color={0,0,127}));
      connect(AffTau.y, rec.u) annotation (Line(points={{-36.5,-20},{-34,-20},{
              -34,-21},{-31.4,-21}}, color={0,0,127}));
      connect(rec.y, product.u2) annotation (Line(points={{-15.3,-21},{8,-21},{
              8,2},{22,2}}, color={0,0,127}));
      connect(product.u1, feedback.y)
        annotation (Line(points={{22,14},{-53,14}}, color={0,0,127}));
      connect(spline.u, feedback.y) annotation (Line(points={{19.6,48},{2,48},{
              2,14},{-53,14}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
              Rectangle(
              extent={{-100,100},{100,-100}},
              lineColor={28,108,200},
              fillColor={255,255,0},
              fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
              preserveAspectRatio=false)));
    end MyogenicReflex;
  end Parts;

  package Test
    model Test_Glomerulal_Filtration
      Parts.Glomerular_Filtration glomerular_Filtration(GFR(start=2e-6))
        annotation (Placement(transformation(extent={{16,-4},{68,52}})));
      Physiolibrary.Types.Constants.HydraulicConductanceConst AffC(k=
            3.7290561345793e-9)
        annotation (Placement(transformation(extent={{-92,78},{-84,86}})));
      Physiolibrary.Types.Constants.HydraulicConductanceConst TubC(k=
            7.8131414150589e-10)
        annotation (Placement(transformation(extent={{-84,30},{-76,38}})));
      Physiolibrary.Types.Constants.MassConcentrationConst APr(k(displayUnit=
              "mg/l") = 70)
        annotation (Placement(transformation(extent={{-86,-18},{-78,-10}})));
      Physiolibrary.Types.Constants.HydraulicConductanceConst GKf(k=
            2.0001642022551e-9)
        annotation (Placement(transformation(extent={{-86,-36},{-78,-28}})));
      Physiolibrary.Types.Constants.PressureConst RAP(k=13285.575905905)
        annotation (Placement(transformation(extent={{-26,56},{-18,64}})));
      Physiolibrary.Types.Constants.VolumeFlowRateConst RBF(k=1.97e-5)
        annotation (Placement(transformation(extent={{-54,22},{-46,30}})));
      Physiolibrary.Types.Constants.VolumeFlowRateConst RPF(k=1.1035e-5)
        annotation (Placement(transformation(extent={{-26,12},{-18,20}})));
    equation
      connect(glomerular_Filtration.AffC, AffC.y) annotation (Line(points={{
              13.4,40.8},{-60,40.8},{-60,82},{-83,82}}, color={0,0,127}));
      connect(glomerular_Filtration.TubC, TubC.y) annotation (Line(points={{
              13.4,32.96},{-68,32.96},{-68,34},{-75,34}}, color={0,0,127}));
      connect(APr.y, glomerular_Filtration.APr) annotation (Line(points={{-77,
              -14},{-50,-14},{-50,7.2},{13.4,7.2}}, color={0,0,127}));
      connect(GKf.y, glomerular_Filtration.GKf) annotation (Line(points={{-77,
              -32},{-40,-32},{-40,-0.64},{13.4,-0.64}}, color={0,0,127}));
      connect(glomerular_Filtration.RAP, RAP.y) annotation (Line(points={{13.4,
              49.2},{-4,49.2},{-4,60},{-17,60}}, color={0,0,127}));
      connect(glomerular_Filtration.RBF, RBF.y) annotation (Line(points={{13.4,
              24},{-16,24},{-16,26},{-45,26}}, color={0,0,127}));
      connect(RPF.y, glomerular_Filtration.RPF) annotation (Line(points={{-17,
              16},{-2,16},{-2,15.6},{13.4,15.6}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end Test_Glomerulal_Filtration;

    model Test_Renal_Perfusion
      Physiolibrary.Types.Constants.HydraulicConductanceConst AffC(k=
            3.7290561345793e-9)
        annotation (Placement(transformation(extent={{-26,44},{-18,52}})));
      Physiolibrary.Types.Constants.HydraulicConductanceConst EffC(k=
            3.1377575922877e-9)
        annotation (Placement(transformation(extent={{-30,30},{-22,38}})));
      Physiolibrary.Types.Constants.HydraulicConductanceConst RenVenC(k=
            2.5002052528189e-8)
        annotation (Placement(transformation(extent={{-18,22},{-10,30}})));
      Physiolibrary.Types.Constants.PressureConst AP(k=13285.575905905)
        annotation (Placement(transformation(extent={{-46,10},{-38,18}})));
      Physiolibrary.Types.Constants.PressureConst VP(k=933.256711905)
        annotation (Placement(transformation(extent={{-28,-4},{-20,4}})));
      Physiolibrary.Types.Constants.PressureConst Clamp(k=0)
        annotation (Placement(transformation(extent={{-44,-30},{-36,-22}})));
      Physiolibrary.Types.Constants.FractionConst Hct(k=0.44)
        annotation (Placement(transformation(extent={{-14,-90},{-6,-82}})));
      Parts.RenalPerfusion renalPerfusion
        annotation (Placement(transformation(extent={{14,-6},{70,46}})));
    equation
      connect(renalPerfusion.AffC, AffC.y) annotation (Line(points={{11.2,42.36},
              {-17,42.36},{-17,48}}, color={0,0,127}));
      connect(renalPerfusion.EffC, EffC.y) annotation (Line(points={{11.2,34.56},
              {-5.4,34.56},{-5.4,34},{-21,34}}, color={0,0,127}));
      connect(renalPerfusion.RenVenC, RenVenC.y) annotation (Line(points={{11.2,
              27.28},{-9,27.28},{-9,26}}, color={0,0,127}));
      connect(AP.y, renalPerfusion.AP) annotation (Line(points={{-37,14},{-12,
              14},{-12,18.96},{11.2,18.96}}, color={0,0,127}));
      connect(renalPerfusion.VP, VP.y) annotation (Line(points={{11.2,12.2},{-6,
              12.2},{-6,0},{-19,0}}, color={0,0,127}));
      connect(Clamp.y, renalPerfusion.Clamp) annotation (Line(points={{-35,-26},
              {0,-26},{0,4.4},{11.2,4.4}}, color={0,0,127}));
      connect(renalPerfusion.Hct, Hct.y) annotation (Line(points={{11.2,-2.88},
              {4,-2.88},{4,-86},{-5,-86}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end Test_Renal_Perfusion;

    model Test_Renal_Glomer_and_Perfusion
      Physiolibrary.Types.Constants.HydraulicConductanceConst AffC(k=
            3.7290561345793e-9)
        annotation (Placement(transformation(extent={{-26,44},{-18,52}})));
      Physiolibrary.Types.Constants.HydraulicConductanceConst EffC(k=
            3.1377575922877e-9)
        annotation (Placement(transformation(extent={{-30,30},{-22,38}})));
      Physiolibrary.Types.Constants.HydraulicConductanceConst RenVenC(k=
            2.5002052528189e-8)
        annotation (Placement(transformation(extent={{-18,22},{-10,30}})));
      Physiolibrary.Types.Constants.PressureConst AP(k=13285.575905905)
        annotation (Placement(transformation(extent={{-46,10},{-38,18}})));
      Physiolibrary.Types.Constants.PressureConst VP(k=933.256711905)
        annotation (Placement(transformation(extent={{-28,-4},{-20,4}})));
      Physiolibrary.Types.Constants.PressureConst Clamp(k=0)
        annotation (Placement(transformation(extent={{-44,-30},{-36,-22}})));
      Physiolibrary.Types.Constants.FractionConst Hct(k=0.44)
        annotation (Placement(transformation(extent={{-14,-90},{-6,-82}})));
      Parts.RenalPerfusion renalPerfusion
        annotation (Placement(transformation(extent={{26,-24},{82,28}})));
      Parts.Glomerular_Filtration glomerular_Filtration
        annotation (Placement(transformation(extent={{14,52},{56,96}})));
      Physiolibrary.Types.Constants.HydraulicConductanceConst AffC1(k=
            3.7290561345793e-9)
        annotation (Placement(transformation(extent={{-18,86},{-10,94}})));
      Physiolibrary.Types.Constants.MassConcentrationConst APr(k(displayUnit=
              "mg/l") = 70)
        annotation (Placement(transformation(extent={{-66,60},{-58,68}})));
      Physiolibrary.Types.Constants.HydraulicConductanceConst GKf(k=
            2.0001642022551e-9)
        annotation (Placement(transformation(extent={{-52,52},{-44,60}})));
      Physiolibrary.Types.Constants.HydraulicConductanceConst TubC(k=
            7.8131414150589e-10)
        annotation (Placement(transformation(extent={{-34,74},{-26,82}})));
    equation
      connect(renalPerfusion.AffC, AffC.y) annotation (Line(points={{23.2,24.36},
              {-17,24.36},{-17,48}}, color={0,0,127}));
      connect(renalPerfusion.EffC, EffC.y) annotation (Line(points={{23.2,16.56},
              {-5.4,16.56},{-5.4,34},{-21,34}}, color={0,0,127}));
      connect(renalPerfusion.RenVenC, RenVenC.y) annotation (Line(points={{23.2,
              9.28},{-9,9.28},{-9,26}}, color={0,0,127}));
      connect(AP.y, renalPerfusion.AP) annotation (Line(points={{-37,14},{-12,
              14},{-12,0.96},{23.2,0.96}}, color={0,0,127}));
      connect(renalPerfusion.VP, VP.y) annotation (Line(points={{23.2,-5.8},{-6,
              -5.8},{-6,0},{-19,0}}, color={0,0,127}));
      connect(Clamp.y, renalPerfusion.Clamp) annotation (Line(points={{-35,-26},
              {0,-26},{0,-13.6},{23.2,-13.6}}, color={0,0,127}));
      connect(renalPerfusion.Hct, Hct.y) annotation (Line(points={{23.2,-20.88},
              {4,-20.88},{4,-86},{-5,-86}}, color={0,0,127}));
      connect(renalPerfusion.RAP, glomerular_Filtration.RAP) annotation (Line(
            points={{84.8,23.32},{88,23.32},{88,98},{4,98},{4,93.8},{11.9,93.8}},
            color={0,0,127}));
      connect(renalPerfusion.RBF, glomerular_Filtration.RBF) annotation (Line(
            points={{84.8,14.48},{98,14.48},{98,42},{-2,42},{-2,74},{11.9,74}},
            color={0,0,127}));
      connect(renalPerfusion.RPF, glomerular_Filtration.RPF) annotation (Line(
            points={{84.8,6.68},{96,6.68},{96,36},{4,36},{4,67.4},{11.9,67.4}},
            color={0,0,127}));
      connect(glomerular_Filtration.AffC, AffC1.y) annotation (Line(points={{
              11.9,87.2},{-4,87.2},{-4,90},{-9,90}}, color={0,0,127}));
      connect(glomerular_Filtration.TubC, TubC.y) annotation (Line(points={{
              11.9,81.04},{-12,81.04},{-12,78},{-25,78}}, color={0,0,127}));
      connect(glomerular_Filtration.APr, APr.y) annotation (Line(points={{11.9,
              60.8},{-38,60.8},{-38,64},{-57,64}}, color={0,0,127}));
      connect(glomerular_Filtration.GKf, GKf.y) annotation (Line(points={{11.9,
              54.64},{-15.05,54.64},{-15.05,56},{-43,56}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end Test_Renal_Glomer_and_Perfusion;
  end Test;
  annotation (uses(Physiolibrary(version="2.3.2-beta"), Modelica(version=
            "3.2.2")));
end ColemanNephron;

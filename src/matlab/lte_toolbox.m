cfg = lteTestModel('1.1','5MHz');
txWaveform = lteTestModelTool(cfg);
rxGrid = lteOFDMDemodulate(cfg,txWaveform);
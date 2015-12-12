cfg = lteTestModel('3.3','1.4MHz');
[timeDomainSig, txGrid, txInfo] = lteTestModelTool(cfg);
rxGrid = lteOFDMDemodulate(cfg,txWaveform);

plot(rxGrid)
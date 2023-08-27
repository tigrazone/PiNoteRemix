program pinote;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, printer4lazarus, dbflaz, uMain, uTabForm, uEditor, HistoryFiles,
  uQueryReload, uSymbForm, uGotoL, uHXTag, uSyntaxList,
  //MySEHighlighterFortran,
  uSynSchOpt, mysynhighlightercs, MySynHighlighterCobol,
  MySynHighlighterHaskell, MySynHighlighterRuby, MySynHighlighterX86Asm,
  MySEHighlighterZ80, MySEHighlighter68K, MySEHighlighter8051,
  MySEHighlighter18F,
  //MySynHighlighterTclTk, MySynHighlighterInno,
  //MySynHighlighterHC11, MySynHighlighterHP48,
  uSyntaxDefault, uThemesDefault,
  uPiNoteOptions, uGeneralOpt, uQueryEditedFiles, MySEPrinterType,
  MySEPrinterInfo, MySEPrinterMargins, MySEPrinterHeaderFooter, MySEPrint,
  MySEPrintPreview, uPrintPreview, MySePrintPreview2, uBaseConverter,
  uSetExtTools, uExtTools, uExtTOut, uVTA, uInsNumbering, uSearchIntoFile,
  uSIFResult, uRTFSynExport, uMD5Sign, uMD5SignFile, uMyCRC, uCRC32Sign,
  uCRC32SignFile, uRun, uInfo, uSynHighlighterLua, uSynHighlighterProlog,
  uSynHighlighterVhdl, uSynHighlighterD, MySEHighlighterPIC32MXAsm,
  MySEHighlighterST6, MySEHighlighterST7, MySEHighlighterADA,
  MySEHighlighterActionScript, MySEHighlighterFreeBasic, MySEHighlighterVerilog,
  MySEHighlighterGO, MySEHighlighterTMS9900, umysynhighlighterpo,
  MySEHighlighterCMake, uManageTabs, MySEHighlighterGroovy, MySEHighlighterRust,
  MySEHighlighterAwk, MySEHighlighterHaxe, uSummary, uSHA256Sign, uSHA256,
  uSHA256SignFile, uBanner, uCreateBanner, MySEHighlighterFSharp,
  MySEHighlighterR, MySEHighlighterV, MySEHighlighterMatlab,
  MySEHighlighterEmpty, uMultiPaste, uPiRuler, MySEHighlighterSwift,
  MySEHighlighterDart, MySEHighlighterAutoIt, MySEHighlighterErlang,
  MySEHighlighterProtoBuf, MySEHighlighterKotlin;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.


program SGC_demo;

uses
  Forms,
  SGC_DemoUnit in 'SGC_DemoUnit.pas' {Form11},
  StringGridCheker in '..\StringGridCheker.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm11, Form11);
  Application.Run;
end.

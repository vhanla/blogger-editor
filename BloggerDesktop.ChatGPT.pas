unit BloggerDesktop.ChatGPT;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JvComponentBase,
  JvDockControlForm, Vcl.StdCtrls, HGM.Controls.Chat, Vcl.ExtCtrls, JvDockTree,
  JvDockVIDStyle, JvDockVSNetStyle;

type
  TFrame1 = class(TFrame)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    GroupBox2: TGroupBox;
    Memo2: TMemo;
    GroupBox4: TGroupBox;
    hChat2: ThChat;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.

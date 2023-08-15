unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  uWVWinControl, uWVWindowParent, Vcl.Menus,
  uWVBrowserBase, uWVBrowser, uWVLoader, uWVCoreWebView2Args, uWVTypeLibrary,
  VirtualTrees, VirtualExplorerTree, ES.BaseControls, ES.Images, pngimage, jpeg, gifimg,
  rkPathViewer, rkSmartPath, DropSource, DragDropFile, Vcl.StdCtrls,
  HGM.Controls.Chat, JvDockTree, JvDockControlForm, JvDockDelphiStyle,
  JvComponentBase, BloggerDesktop.ChatGPT, JvDockVIDStyle, JvDockVSNetStyle,
  MPCommonObjects, EasyListview, VirtualExplorerEasyListview, MPCommonUtilities, DragDrop,
  JvAppEvent, Vcl.Mask;

type
  TfrmMain = class(TForm)
    pnlContainr: TPanel;
    pnlTools: TPanel;
    pcTools: TPageControl;
    tsPictures: TTabSheet;
    WVBrowser1: TWVBrowser;
    WVWindowParent1: TWVWindowParent;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Timer1: TTimer;
    Panel1: TPanel;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    EsImage1: TEsImage;
    rkSmartPath1: TrkSmartPath;
    PopupMenu1: TPopupMenu;
    Copypath1: TMenuItem;
    DropFileSource1: TDropFileSource;
    Frame11: TFrame1;
    tsOpenAI: TTabSheet;
    VirtualMultiPathExplorerEasyListview1: TVirtualMultiPathExplorerEasyListview;
    JvAppEvents1: TJvAppEvents;
    TabSheet1: TTabSheet;
    lbedBlogsPath: TLabeledEdit;
    CheckBox1: TCheckBox;
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure WVBrowser1AfterCreated(Sender: TObject);
    procedure EsImage1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WVBrowser1DOMContentLoaded(Sender: TObject;
      const aWebView: ICoreWebView2;
      const aArgs: ICoreWebView2DOMContentLoadedEventArgs);
    procedure rkSmartPath1PathChanged(Sender: TObject);
    procedure VirtualMultiPathExplorerEasyListview1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VirtualMultiPathExplorerEasyListview1ItemDblClick(
      Sender: TCustomEasyListview; Button: TCommonMouseButton; MousePos: TPoint;
      HitInfo: TEasyHitInfoItem);
    procedure VirtualMultiPathExplorerEasyListview1ItemClick(
      Sender: TCustomEasyListview; Item: TEasyItem; KeyStates: TCommonKeyStates;
      HitInfo: TEasyItemHitTestInfoSet);
    procedure WVBrowser1WebResourceResponseReceived(Sender: TObject;
      const aWebView: ICoreWebView2;
      const aArgs: ICoreWebView2WebResourceResponseReceivedEventArgs);
    procedure WVBrowser1NavigationStarting(Sender: TObject;
      const aWebView: ICoreWebView2;
      const aArgs: ICoreWebView2NavigationStartingEventArgs);
    procedure WVBrowser1NavigationCompleted(Sender: TObject;
      const aWebView: ICoreWebView2;
      const aArgs: ICoreWebView2NavigationCompletedEventArgs);
    procedure JvAppEvents1Activate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure WVBrowser1DocumentTitleChanged(Sender: TObject);
    procedure WVBrowser1WebMessageReceived(Sender: TObject;
      const aWebView: ICoreWebView2;
      const aArgs: ICoreWebView2WebMessageReceivedEventArgs);
  private
    { Private declarations }
    FGetHeaders: Boolean;
    FSelectedFile: string;
    procedure UpdateList(APath: string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

function RtlGetVersion(var RTL_OSVERSIONINFOEXW): LONG; stdcall;
  external 'ntdll.dll' Name 'RtlGetVersion';

implementation

uses
  Winapi.DwmApi, MPShellUtilities, Winapi.ShlObj, Winapi.ShellAPI, Winapi.ActiveX,
  uWVCoreWebView2WindowFeatures, uWVTypes,
  uWVCoreWebView2WebResourceResponseView, uWVCoreWebView2HttpResponseHeaders,
  uWVCoreWebView2HttpHeadersCollectionIterator,
  uWVCoreWebView2ProcessInfoCollection, uWVCoreWebView2ProcessInfo,
  uWVCoreWebView2Delegates;

{$R *.dfm}

function isWindows11:Boolean;
var
  winver: RTL_OSVERSIONINFOEXW;
begin
  Result := False;
  if ((RtlGetVersion(winver) = 0) and (winver.dwMajorVersion>=10) and (winver.dwBuildNumber > 22000))  then
    Result := True;
end;


procedure TfrmMain.Button1Click(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
  try
    Options := [fdoPickFolders];
    if Execute then
    begin
      lbedBlogsPath.Text := FileName;
    end;

  finally
    Free;
  end;
end;

procedure TfrmMain.EsImage1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  if DragDetectPlus(TWinControl(Sender)) then
  begin
    DropFileSource1.Files.Clear;

    if FileExists(FSelectedFile) then
    begin
      DropFileSource1.Files.Add(FSelectedFile);
      DropFileSource1.Execute();
    end;

  end;

end;

procedure TfrmMain.FormCreate(Sender: TObject);
const
  WCA_CLIENTRENDERING_POLICY = 16;
  WCA_ACCENT_POLICY = 19;
  DWMWCP_DEFAULT    = 0; // Let the system decide whether or not to round window corners
  DWMWCP_DONOTROUND = 1; // Never round window corners
  DWMWCP_ROUND      = 2; // Round the corners if appropriate
  DWMWCP_ROUNDSMALL = 3; // Round the corners if appropriate, with a small radius

  DWMWA_WINDOW_CORNER_PREFERENCE = 33; // [set] WINDOW_CORNER_PREFERENCE, Controls the policy that rounds top-level window corners
begin
  FGetHeaders := True;

  if isWindows11  then
  begin
    // this trick brings back shadowing to VCL styled windows
    var DWM_WINDOW_CORNER_PREFERENCE: Cardinal;
    DWM_WINDOW_CORNER_PREFERENCE := DWMWCP_ROUND;
     DwmSetWindowAttribute(Handle, DWMWA_WINDOW_CORNER_PREFERENCE, @DWM_WINDOW_CORNER_PREFERENCE, sizeof(DWM_WINDOW_CORNER_PREFERENCE));

  end;

  UpdateList(rkSmartPath1.Path);
end;

procedure TfrmMain.JvAppEvents1Activate(Sender: TObject);
begin
  Winapi.Windows.SetFocus(WVWindowParent1.ChildWindowHandle);
end;

procedure TfrmMain.rkSmartPath1PathChanged(Sender: TObject);
begin
  VirtualMultiPathExplorerEasyListview1.RootFolderCustomPath := rkSmartPath1.Path;
  UpdateList(rkSmartPath1.Path);
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;

  if GlobalWebView2Loader.Initialized then
  begin
    WVBrowser1.DevToolsEnabled := True;
    WVBrowser1.CreateBrowser(WVWindowParent1.Handle)
  end
  else
    Timer1.Enabled := True;
end;

procedure TfrmMain.UpdateList(APath: string);
var
  pidlList: TCommonPIDLList;
  PIDL: PItemIDList;
  I: Integer;
  SearchRec: TSearchRec;
  SearchResult: Integer;
  FilePath: string;
begin
  if not DirectoryExists(APath) then Exit;

  VirtualMultiPathExplorerEasyListview1.BeginUpdate;
  try
    VirtualMultiPathExplorerEasyListview1.Clear;
//    statusBar.Panels[0].Text := 'Found: ' + numResults.ToString;
    SearchResult := FindFirst(IncludeTrailingPathDelimiter(APath) + '*', faAnyFile, SearchRec);
    try
      while SearchResult = 0 do
      begin
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          FilePath := IncludeTrailingPathDelimiter(APath) + SearchRec.Name;
          PIDL := PathToPIDL(FilePath);
          VirtualMultiPathExplorerEasyListview1.AddCustomItem(nil, TNameSpace.Create(PIDL, nil), True);
        end;

        SearchResult := FindNext(SearchRec);
      end;
    finally
      FindClose(SearchRec);
    end;
  finally
    VirtualMultiPathExplorerEasyListview1.EndUpdate;
  end;
end;

procedure TfrmMain.VirtualMultiPathExplorerEasyListview1ItemClick(
  Sender: TCustomEasyListview; Item: TEasyItem; KeyStates: TCommonKeyStates;
  HitInfo: TEasyItemHitTestInfoSet);
begin
  try
    var fpath := VirtualMultiPathExplorerEasyListview1.SelectedPath.ToLower;
    var fext := ExtractFileExt(fpath);
    if fext.Contains('.png') or fext.Contains('.jpg') or fext.Contains('gif') then
    begin
      EsImage1.Picture.LoadFromFile(fpath);
      FSelectedFile := fPath;
    end;
  except
    EsImage1.Picture.Assign(nil);
  end;
end;

procedure TfrmMain.VirtualMultiPathExplorerEasyListview1ItemDblClick(
  Sender: TCustomEasyListview; Button: TCommonMouseButton; MousePos: TPoint;
  HitInfo: TEasyHitInfoItem);
var
  lFile: string;
begin
  lFile := VirtualMultiPathExplorerEasyListview1.SelectedPath;
  if DirectoryExists(lFile) then
  begin
    rkSmartPath1.Path := lFile;
  end;
end;

procedure TfrmMain.VirtualMultiPathExplorerEasyListview1MouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  lFile: string;
begin
  if DragDetectPlus(TWinControl(Sender)) then
  begin
    DropFileSource1.Files.Clear;

    lFile := VirtualMultiPathExplorerEasyListview1.SelectedPath;
    if FileExists(lFile) then
    begin
      try
//        var fpath := VirtualExplorerListview1.SelectedPath.ToLower;
        var fext := ExtractFileExt(lFile);
        if fext.Contains('.png') or fext.Contains('.jpg') or fext.Contains('gif') then
        begin
          DropFileSource1.Files.Add(lFile);
          DropFileSource1.Execute();
        end;
      except

      end;
    end;


  end;

end;

procedure TfrmMain.WVBrowser1AfterCreated(Sender: TObject);
begin
  WVWindowParent1.UpdateSize;

  WVBrowser1.Navigate('https://blogger.com');

end;

procedure TfrmMain.WVBrowser1DocumentTitleChanged(Sender: TObject);
begin
  Caption := PChar('Blogger Desktop 1.0 - ' + WVBrowser1.CoreWebView2.Source);
  WVBrowser1.ExecuteScript('window.chrome.webview.postMessage(document.querySelectorAll(''div[role="presentation"]>a'')[document.querySelectorAll(''div[role="presentation"]>a'').length-1].href)');
end;

procedure TfrmMain.WVBrowser1DOMContentLoaded(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2DOMContentLoadedEventArgs);
begin
  WVBrowser1.ExecuteScript('( ' +
  '  function(){ ' +
  '    var style = document.createElement(''STYLE''); ' +
  '    style.type = ''text/css''; ' +
  '    style.innerHTML = ''@charset "utf-8";html{    background: #2a2c3c !important;' +
  ' }html * { color: #bbb !important; border-width: 0 !important;  border-color: #2' +
  'a2c3c !important; background: rgba(75,81,103,.1) !important; }html a, html a * { text-decorati' +
  'on: underline !important; ;  color: #5c8599 !important; }html a:visited, html a:' +
  'visited *, html a:active, html a:active * { color: #525f66 !important; }html a:h' +
  'over, html a:hover * { color: #cef !important; background: #023 !important; } ht' +
  'ml input, html select, html button, html textarea { border: 1px solid #5c5a46 !i' +
  'mportant; border-top-color: #43485D !important; border-bottom-color: #43485D !im' +
  'portant;  background: #4b5167 !important; }html input[type=button], html input[t' +
  'ype=submit], html input[type=reset], html button { border-top-color: #43485D !im' +
  'portant; border-bottom-color: #43485D !important; }html input:focus, html select' +
  ':focus, html option:focus, html button:focus, html textarea:focus { color: #fff ' +
  '!important; border-color: #43485D !important; outline: 2px solid #43485D !import' +
  'ant;  background: #4b5167 !important; }html input[type=button]:focus, html input' +
  '[type=submit]:focus, html input[type=reset]:focus, html button:focus { border-co' +
  'lor: #43485D !important; }html input[type=button]:hover, html input[type=submit]' +
  ':hover, html input[type=reset]:hover, html button:hover { background: #0781E0 !i' +
  'mportant; border-color: #0781E0 !important; } html input[type=radio] { border-wi' +
  'dth: 0 !important;  border-color: #333 !important; background: none !important; ' +
  '} html, html body { scrollbar-base-color: #4d4c40 !important; scrollbar-face-col' +
  'or: #5c5b3e !important; scrollbar-shadow-color: #5c5b3e !important; scrollbar-hi' +
  'ghlight-color: #5c5b3e !important; scrollbar-dlight-color: #5c5b3e !important; s' +
  'crollbar-darkshadow-color: #474531 !important; scrollbar-track-color: #4d4c40 !i' +
  'mportant; scrollbar-arrow-color: #000 !important; scrollbar-3dlight-color: #7a79' +
  '67 !important; }@media all and (-webkit-min-device-pixel-ratio:0) { html body * ' +
  '{ -webkit-transition: color 1s ease-in, background-color 2s ease-out !important;' +
  ' } html a, html textarea, html input, html select { -webkit-transition: color .4' +
  's ease-in, background-color .4s ease-out !important; } html input:focus, html se' +
  'lect:focus, html option:focus, html button:focus, html textarea:focus { outline-' +
  'style: outset !important; } } .editable{background-color: #9197AE!important;}+' +
  'body::-webkit-scrollbar-track' +
                '{' +
                '-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);' +
                'background-color: #343648;' +
                '}' +
                'body::-webkit-scrollbar' +
                '{' +
                'width: 12px;' +
                'background-color: #F5F5F5;' +
                '}' +
                'body::-webkit-scrollbar-thumb' +
                '{' +
                'border-radius: 10px;' +
                '-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);' +
                'background-color: #555;' +
                '}''; ' +
  '    document.getElementsByTagName(''HEAD'')[0].appendChild(style); ' +
  '  })() ');

  WVBrowser1.ExecuteScript('// Get all iframes on the page ' +
  'var iframes = document.querySelectorAll(''iframe''); ' +
  ' ' +
  '// Iterate over each iframe ' +
  'for (var i = 0; i < iframes.length; i++) { ' +
  '  var iframe = iframes[i]; ' +
  ' ' +
  '  // Check if iframe is loaded ' +
  '  if (iframe.contentDocument && iframe.contentDocument.readyState === ''complete''' +
  ') { ' +
  '    // Create a <style> element ' +
  '    var style = iframe.contentDocument.createElement(''style''); ' +
  '    style.innerHTML = ` ' +
  '      body::-webkit-scrollbar-track { ' +
  '        -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3)!important; ' +
  '        background-color: #343648!important; ' +
  '      } ' +
  '      body::-webkit-scrollbar { ' +
  '        width: 12px!important; ' +
  '        background-color: #F5F5F5!important; ' +
  '      } ' +
  '      body::-webkit-scrollbar-thumb { ' +
  '        border-radius: 10px!important; ' +
  '        -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3)!important; ' +
  '        background-color: #555!important; ' +
  '      } ' +
  '    `; ' +
  ' ' +
  '    // Append the <style> element to the iframe''s document ' +
  '    iframe.contentDocument.head.appendChild(style); ' +
  '  } ' +
  '  else { ' +
  '    // If the iframe is not loaded, you may need to wait for the ''load'' event be' +
  'fore injecting the styles ' +
  '    iframe.addEventListener(''load'', function() { ' +
  '      var style = this.contentDocument.createElement(''style''); ' +
  '      style.innerHTML = ` ' +
  '        // Scrollbar styles ' +
  '      `; ' +
  '      this.contentDocument.head.appendChild(style); ' +
  '    }); ' +
  '  } ' +
  '} ');
end;

procedure TfrmMain.WVBrowser1NavigationCompleted(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2NavigationCompletedEventArgs);
var
  tmp: TCoreWebView2NavigationCompletedEventArgs;
  titl: pwidechar;
  sett: ICoreWebView2Settings;
  url: PWideChar;
begin
  Winapi.Windows.SetFocus(WVWindowParent1.ChildWindowHandle);
  tmp := TCoreWebView2NavigationCompletedEventArgs.Create(aArgs);
  try
    if tmp.HttpStatusCode = 200 then
    begin
//      if aWebView.Get_DocumentTitle(titl) = S_OK then
//      begin
//        Caption := PChar('Blogger Desktop 1.0 - ' + titl);
//        CoTaskMemFree(titl);
//      end;

      if aWebView.Get_Source(url) = S_OK then
      begin
        Caption := PChar('Blogger Desktop 1.0 - ' + url);
        CoTaskMemFree(url);
      end;

    end;
  finally
    tmp.Free;
  end;
end;

procedure TfrmMain.WVBrowser1NavigationStarting(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2NavigationStartingEventArgs);
begin
  FGetHeaders := True;
end;

procedure TfrmMain.WVBrowser1WebMessageReceived(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2WebMessageReceivedEventArgs);
var
  tmp: TCoreWebView2WebMessageReceivedEventArgs;
  url: string;
begin
  tmp := TCoreWebView2WebMessageReceivedEventArgs.Create(aArgs);
  try
    url := tmp.WebMessageAsString;
//    if url.StartsWith('http') then
    begin
      lbedBlogsPath.Text := url;
    end;

  finally
    tmp.Free;
  end;
end;

procedure TfrmMain.WVBrowser1WebResourceResponseReceived(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2WebResourceResponseReceivedEventArgs);
var
  TempArgs     : TCoreWebView2WebResourceResponseReceivedEventArgs;
  TempResponse : TCoreWebView2WebResourceResponseView;
  TempHeaders  : TCoreWebView2HttpResponseHeaders;
  TempIterator : TCoreWebView2HttpHeadersCollectionIterator;
  TempName     : wvstring;
  TempValue    : wvstring;
  TempHandler  : ICoreWebView2WebResourceResponseViewGetContentCompletedHandler;
  url: PWideChar;
begin
  if FGetHeaders then
  try
    FGetHeaders := False;
    TempArgs := TCoreWebView2WebResourceResponseReceivedEventArgs.Create(aArgs);
    TempResponse := TCoreWebView2WebResourceResponseView.Create(TempArgs.Response);
    TempHandler := TCoreWebView2WebResourceResponseViewGetContentCompletedHandler.Create(WVBrowser1);
    TempHeaders := TCoreWebView2HttpResponseHeaders.Create(TempResponse.Headers);
    TempIterator := TCoreWebView2HttpHeadersCollectionIterator.Create(TempHeaders.Iterator);

//    TempHeaders.AppendHeader('Content-Security-Policy', 'script-src ''self'' https://');

    TempResponse.GetContent(TempHandler);
    while TempIterator.HasCurrentHeader do
    begin
      if TempIterator.GetCurrentHeader(TempName, TempValue) then
      begin

      end;
      TempIterator.MoveNext;
    end;

    TempHeaders.AppendHeader('Content-Security-Policy', '');

  finally
    FreeAndNil(TempIterator);
    FreeAndNil(TempHeaders);
    FreeAndNil(TempResponse);
    FreeAndNil(TempArgs);
    TempHandler := nil;
  end;
end;

initialization
  GlobalWebView2Loader := TWVLoader.Create(nil);
  GlobalWebView2Loader.UserDataFolder := ExtractFilePath(ParamStr(0)) + '\CustomCache';
  GlobalWebView2Loader.StartWebView2;


end.

unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  uWVWinControl, uWVWindowParent, Vcl.Menus,
  uWVBrowserBase, uWVBrowser, uWVLoader, uWVCoreWebView2Args, uWVTypeLibrary,
  VirtualTrees, VirtualExplorerTree, ES.BaseControls, ES.Images, pngimage, jpeg, gifimg, dwsTurboJPEG, LibTurboJPEG, dwsJPEGEncoderOptions,
  rkPathViewer, rkSmartPath, DropSource, DragDropFile, Vcl.StdCtrls,
  HGM.Controls.Chat, JvDockTree, JvDockControlForm, JvDockDelphiStyle,
  JvComponentBase, BloggerDesktop.ChatGPT, JvDockVIDStyle, JvDockVSNetStyle,
  MPCommonObjects, EasyListview, VirtualExplorerEasyListview, MPCommonUtilities, DragDrop,
  JvAppEvent, Vcl.Mask, JvAppStorage, JvAppIniStorage, System.Actions,
  Vcl.ActnList, Vcl.StdActns, Vcl.ExtDlgs, Vcl.Grids, Vcl.ValEdit;

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
    Timer1: TTimer;
    pnlClipwatcher: TPanel;
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
    Settings: TJvAppIniFileStorage;
    btnSaveSettings: TButton;
    ActionList1: TActionList;
    EditPaste1: TEditPaste;
    btnSaveClipJPG: TButton;
    btnSaveClipPNG: TButton;
    SavePictureDialog1: TSavePictureDialog;
    pnlSources: TPanel;
    ValueListEditor1: TValueListEditor;
    pnlNewURL: TPanel;
    lbeNewURL: TLabeledEdit;
    btnPasteURL: TButton;
    btnDiscarPic: TButton;
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
    procedure btnSaveSettingsClick(Sender: TObject);
    procedure EditPaste1Execute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClipJPGClick(Sender: TObject);
    procedure btnSaveClipPNGClick(Sender: TObject);
    procedure btnPasteURLClick(Sender: TObject);
    procedure btnDiscarPicClick(Sender: TObject);
  private
    { Private declarations }
    FGetHeaders: Boolean;
    FSelectedFile: string;
    FCurrentURL: string;
    // Settings
    FBlogsPath: string;
    FBlogDomain: string;

    procedure UpdateList(APath: string);

    procedure GetClipboard(var Msg: TMessage); message WM_DRAWCLIPBOARD;
    procedure ChangeCBChain(var Msg: TMessage); message WM_CHANGECBCHAIN;
  public
    { Public declarations }
    property BlogsPath: string read FBlogsPath;
    property BlogDomain: string read FBlogDomain;
  end;

var
  frmMain: TfrmMain;
  ClipNext: THandle;

function RtlGetVersion(var RTL_OSVERSIONINFOEXW): LONG; stdcall;
  external 'ntdll.dll' Name 'RtlGetVersion';

implementation

uses
  Winapi.DwmApi, MPShellUtilities, Winapi.ShlObj, Winapi.ShellAPI, Winapi.ActiveX,
  uWVCoreWebView2WindowFeatures, uWVTypes, Clipbrd, System.JSON,
  uWVCoreWebView2WebResourceResponseView, uWVCoreWebView2HttpResponseHeaders,
  uWVCoreWebView2HttpHeadersCollectionIterator,
  uWVCoreWebView2ProcessInfoCollection, uWVCoreWebView2ProcessInfo,
  uWVCoreWebView2Delegates, helpers, DarkModeApi;

{$R *.dfm}

function isWindows11:Boolean;
var
  winver: RTL_OSVERSIONINFOEXW;
begin
  Result := False;
  if ((RtlGetVersion(winver) = 0) and (winver.dwMajorVersion>=10) and (winver.dwBuildNumber > 22000))  then
    Result := True;
end;


procedure TfrmMain.btnDiscarPicClick(Sender: TObject);
begin
  pnlClipwatcher.Hide;
  EsImage1.Picture.Assign(nil);
end;

procedure TfrmMain.btnPasteURLClick(Sender: TObject);
var
  newURL: string;
  newTitle: string;
begin
  newURL := Trim(lbeNewURL.Text);

  if newURL.StartsWith('http') or newURL.StartsWith('HTTP') then
  begin
    if ValueListEditor1.Strings.IndexOfName(EncodeURL(newURL)) <> -1 then
    begin
      ShowMessage('Already in the list');
      Exit;
    end;

    if MessageDlg('Get the Title from the URL page (HEAD)?', TMsgDlgType.mtConfirmation, mbYesNo, 0) = mrYes then
    begin
      newTitle := GetURLTitle(newURL, ValueListEditor1);
    end
    else
    if InputQuery('Custom Title', 'Input a title for this URL', newTitle) then
    begin

    end;

    if not newTitle.IsEmpty then
    begin
      ValueListEditor1.InsertRow(EncodeURL(newURL), newTitle, False);
    end;
  end
  else
    raise Exception.Create('not valid URL');
end;

procedure TfrmMain.btnSaveClipJPGClick(Sender: TObject);
var
  outbuf: Pointer;
  outSize: Cardinal;
  fs: TFileStream;
  bmp: TBitmap;
begin
  with SavePictureDialog1 do
  begin
    InitialDir := rkSmartPath1.Path;
    Filter := 'JPEG|*.jpg';
    if Execute then
    begin
      if ExtractFileExt(LowerCase(FileName)) <> '.jpg' then
        FileName := FileName + '.jpg';
//      EsImage1.Picture.SaveToFile(FileName);
      pnlClipwatcher.Visible := False;

      bmp := TBitmap.Create;
      try
        bmp.PixelFormat := pf24bit;
        bmp.Width := EsImage1.Picture.Width;
        bmp.Height := EsImage1.Picture.Height;
        bmp.Canvas.Draw(0, 0, EsImage1.Picture.Graphic);
//        bmp.Assign(EsImage1.Picture.Bitmap);

        var format := TJPF.TJPF_UNKNOWN;
        case bmp.PixelFormat of
          pfDevice: format := TJPF.TJPF_RGBX;
          pf1bit: ;
          pf4bit: ;
          pf8bit: ;
          pf15bit: ;
          pf16bit: ;
          pf24bit: format := TJPF.TJPF_BGR;
          pf32bit: format := TJPF.TJPF_BGRA;
          pfCustom: ;
        end;
        if format <> TJPF.TJPF_UNKNOWN then
        begin
          var jpeg := TJ.InitCompress;
          try
            outbuf := nil;
            outSize := 0;
            var pitch := 0;
            if bmp.Height > 1 then
              pitch := IntPtr(bmp.ScanLine[1]) - IntPtr(bmp.ScanLine[0]);
            if pitch > 0 then
            begin
              if TJ.Compress2(jpeg, bmp.ScanLine[0], bmp.Width, pitch, bmp.Height, format,
                              @outbuf, @outsize, TJSAMP_420, 80, TJFLAG_PROGRESSIVE) <> 0 then
                RaiseLastTurboJPEGError(jpeg);
            end
            else
            begin
              if TJ.Compress2(jpeg, bmp.ScanLine[bmp.Height - 1], bmp.Width, -pitch, bmp.Height, format,
                              @outbuf, @outsize, TJSAMP_420, 80, TJFLAG_PROGRESSIVE or TJFLAG_BOTTOMUP) <> 0 then
              RaiseLastTurboJPEGError(jpeg);
            end;
            try
              //
              fs := TFileStream.Create(FileName, fmCreate);
              try
                fs.WriteBuffer(outbuf^, outsize);
              finally
                fs.Free;
              end;
            finally
              TJ.Free(outBuf);
            end;

          finally
            TJ.Destroy(jpeg);
          end;
        end;
      finally
        bmp.Free;
      end;

      // refresh the list
      rkSmartPath1PathChanged(Sender);
    end;
  end;
end;

procedure TfrmMain.btnSaveClipPNGClick(Sender: TObject);
begin
  with SavePictureDialog1 do
  begin
    InitialDir := rkSmartPath1.Path;
    Filter := 'PNG|*.png';
    if Execute then
    begin
      var png := TPngImage.Create;
      try
        png.Assign(EsImage1.Picture);
        if ExtractFileExt(LowerCase(FileName)) <> '.png' then
          FileName := FileName + '.png';
        png.SaveToFile(FileName);
        pnlClipwatcher.Visible := False;
      finally
        png.Free;
      end;
      // refresh the list
      rkSmartPath1PathChanged(Sender);
    end;
  end;
end;

procedure TfrmMain.btnSaveSettingsClick(Sender: TObject);
begin
  Settings.WriteString('blogspath', lbedBlogsPath.Text);
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

procedure TfrmMain.ChangeCBChain(var Msg: TMessage);
var
  remove, next: THandle;
begin
  remove := Msg.WParam;
  next := Msg.LParam;

  with Msg do
  begin
    if ClipNext = remove then
      ClipNext := next
    else if ClipNext <> 0 then
      SendMessage(ClipNext, WM_CHANGECBCHAIN, remove, next);
  end;
end;

procedure TfrmMain.EditPaste1Execute(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_BITMAP) then
  begin
    EsImage1.Picture.Assign(Clipboard);
    pnlClipwatcher.Visible := True;
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
  if IsDarkMode then
    AllowDarkModeForWindow(Handle, True);

  FGetHeaders := True;

  if isWindows11  then
  begin
    // this trick brings back shadowing to VCL styled windows
    var DWM_WINDOW_CORNER_PREFERENCE: Cardinal;
    DWM_WINDOW_CORNER_PREFERENCE := DWMWCP_ROUND;
     DwmSetWindowAttribute(Handle, DWMWA_WINDOW_CORNER_PREFERENCE, @DWM_WINDOW_CORNER_PREFERENCE, sizeof(DWM_WINDOW_CORNER_PREFERENCE));

  end;

  UpdateList(rkSmartPath1.Path);

  FBlogsPath := Settings.ReadString('blogspath', '');
  lbedBlogsPath.Text := BlogsPath;

  // Load Turbo-JPEG
  LoadTurboJPEG;
  // Let's watch the clipboard
  ClipNext := SetClipboardViewer(Handle);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  ChangeClipboardChain(Handle, ClipNext);
end;

procedure TfrmMain.GetClipboard(var Msg: TMessage);
const
  NOTEQUAL = '＝';
var
  tmpText: string;
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    try
      tmpText := Trim(Clipboard.AsText);
      //tmpText := StringReplace(tmpText, '=', NOTEQUAL, [rfReplaceAll]);
      if tmpText.StartsWith('http') and not tmpText.Contains(' ') then
      begin
//        if ValueListEditor1.Strings.IndexOfName(tmpText) = -1 then
//          ValueListEditor1.InsertRow(tmpText, '', False);
        lbeNewURL.Text := tmpText;
        pnlNewURL.Show;
      end;
    except

    end;
  end
  else if Clipboard.HasFormat(CF_BITMAP) then //or Clipboard.HasFormat(CF_PICTURE) then
  begin
    EsImage1.Picture.Assign(Clipboard);
    pnlClipwatcher.Visible := True;
  end;

  if ClipNext <> 0 then
    SendMessage(ClipNext, WM_DRAWCLIPBOARD, 0, 0);
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
      pnlClipwatcher.Hide;
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
  FCurrentURL := WVBrowser1.CoreWebView2.Source;
  Caption := PChar('Blogger Desktop 1.0 - ' + FCurrentURL);
  // Query for the blog publisher domain
WVBrowser1.ExecuteScript(
  'window.chrome.webview.postMessage(JSON.stringify({' +
  '"type": "blogURL",' +
  '"msg": document.querySelectorAll(''div[role="presentation"]>a'')[' +
  'document.querySelectorAll(''div[role="presentation"]>a'').length - 1].href' +
  '}));'
);

end;

procedure TfrmMain.WVBrowser1DOMContentLoaded(Sender: TObject;
  const aWebView: ICoreWebView2;
  const aArgs: ICoreWebView2DOMContentLoadedEventArgs);
begin
//  WVBrowser1.ExecuteScript('( ' +
//  '  function(){ ' +
//  '    var style = document.createElement(''STYLE''); ' +
//  '    style.type = ''text/css''; ' +
//  '    style.innerHTML = ''@charset "utf-8";html{    background: #2a2c3c !important;' +
//  ' }html * { color: #bbb !important; border-width: 0 !important;  border-color: #2' +
//  'a2c3c !important; background: rgba(75,81,103,.1) !important; }html a, html a * { text-decorati' +
//  'on: underline !important; ;  color: #5c8599 !important; }html a:visited, html a:' +
//  'visited *, html a:active, html a:active * { color: #525f66 !important; }html a:h' +
//  'over, html a:hover * { color: #cef !important; background: #023 !important; } ht' +
//  'ml input, html select, html button, html textarea { border: 1px solid #5c5a46 !i' +
//  'mportant; border-top-color: #43485D !important; border-bottom-color: #43485D !im' +
//  'portant;  background: #4b5167 !important; }html input[type=button], html input[t' +
//  'ype=submit], html input[type=reset], html button { border-top-color: #43485D !im' +
//  'portant; border-bottom-color: #43485D !important; }html input:focus, html select' +
//  ':focus, html option:focus, html button:focus, html textarea:focus { color: #fff ' +
//  '!important; border-color: #43485D !important; outline: 2px solid #43485D !import' +
//  'ant;  background: #4b5167 !important; }html input[type=button]:focus, html input' +
//  '[type=submit]:focus, html input[type=reset]:focus, html button:focus { border-co' +
//  'lor: #43485D !important; }html input[type=button]:hover, html input[type=submit]' +
//  ':hover, html input[type=reset]:hover, html button:hover { background: #0781E0 !i' +
//  'mportant; border-color: #0781E0 !important; } html input[type=radio] { border-wi' +
//  'dth: 0 !important;  border-color: #333 !important; background: none !important; ' +
//  '} html, html body { scrollbar-base-color: #4d4c40 !important; scrollbar-face-col' +
//  'or: #5c5b3e !important; scrollbar-shadow-color: #5c5b3e !important; scrollbar-hi' +
//  'ghlight-color: #5c5b3e !important; scrollbar-dlight-color: #5c5b3e !important; s' +
//  'crollbar-darkshadow-color: #474531 !important; scrollbar-track-color: #4d4c40 !i' +
//  'mportant; scrollbar-arrow-color: #000 !important; scrollbar-3dlight-color: #7a79' +
//  '67 !important; }@media all and (-webkit-min-device-pixel-ratio:0) { html body * ' +
//  '{ -webkit-transition: color 1s ease-in, background-color 2s ease-out !important;' +
//  ' } html a, html textarea, html input, html select { -webkit-transition: color .4' +
//  's ease-in, background-color .4s ease-out !important; } html input:focus, html se' +
//  'lect:focus, html option:focus, html button:focus, html textarea:focus { outline-' +
//  'style: outset !important; } } .editable{background-color: #9197AE!important;}+' +
//  'body::-webkit-scrollbar-track' +
//                '{' +
//                '-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3);' +
//                'background-color: #343648;' +
//                '}' +
//                'body::-webkit-scrollbar' +
//                '{' +
//                'width: 12px;' +
//                'background-color: #F5F5F5;' +
//                '}' +
//                'body::-webkit-scrollbar-thumb' +
//                '{' +
//                'border-radius: 10px;' +
//                '-webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);' +
//                'background-color: #555;' +
//                '}''; ' +
//  '    document.getElementsByTagName(''HEAD'')[0].appendChild(style); ' +
//  '  })() ');
//
//  WVBrowser1.ExecuteScript('// Get all iframes on the page ' +
//  'var iframes = document.querySelectorAll(''iframe''); ' +
//  ' ' +
//  '// Iterate over each iframe ' +
//  'for (var i = 0; i < iframes.length; i++) { ' +
//  '  var iframe = iframes[i]; ' +
//  ' ' +
//  '  // Check if iframe is loaded ' +
//  '  if (iframe.contentDocument && iframe.contentDocument.readyState === ''complete''' +
//  ') { ' +
//  '    // Create a <style> element ' +
//  '    var style = iframe.contentDocument.createElement(''style''); ' +
//  '    style.innerHTML = ` ' +
//  '      body::-webkit-scrollbar-track { ' +
//  '        -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3)!important; ' +
//  '        background-color: #343648!important; ' +
//  '      } ' +
//  '      body::-webkit-scrollbar { ' +
//  '        width: 12px!important; ' +
//  '        background-color: #F5F5F5!important; ' +
//  '      } ' +
//  '      body::-webkit-scrollbar-thumb { ' +
//  '        border-radius: 10px!important; ' +
//  '        -webkit-box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3)!important; ' +
//  '        background-color: #555!important; ' +
//  '      } ' +
//  '    `; ' +
//  ' ' +
//  '    // Append the <style> element to the iframe''s document ' +
//  '    iframe.contentDocument.head.appendChild(style); ' +
//  '  } ' +
//  '  else { ' +
//  '    // If the iframe is not loaded, you may need to wait for the ''load'' event be' +
//  'fore injecting the styles ' +
//  '    iframe.addEventListener(''load'', function() { ' +
//  '      var style = this.contentDocument.createElement(''style''); ' +
//  '      style.innerHTML = ` ' +
//  '        // Scrollbar styles ' +
//  '      `; ' +
//  '      this.contentDocument.head.appendChild(style); ' +
//  '    }); ' +
//  '  } ' +
//  '} ');
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
  url, finalPath: string;
  json: TJSONObject;
begin
  tmp := TCoreWebView2WebMessageReceivedEventArgs.Create(aArgs);
  try
    url := tmp.WebMessageAsString;
    finalPath := '';

    json := TJSONObject.Create;
    try
      if json.Parse(BytesOf(url), 0) > 0 then // valid json
      begin
        if json.Values['type'].Value = 'blogURL' then
        begin
          FBlogDomain := ExtractDomainFromURL(json.Values['msg'].Value);
          if DirectoryExists(BlogsPath) then
          begin
            if not DirectoryExists(IncludeTrailingPathDelimiter(BlogsPath) + BlogDomain) then
            begin
              CreateDir(IncludeTrailingPathDelimiter(BlogsPath) + BlogDomain);
            end;

            if FCurrentURL.Contains('/blog/post/edit/') then
            begin
              var fs := TStringList.Create;
              try
                fs.Delimiter := '/';
                fs.DelimitedText := FCurrentURL;
                finalPath := fs[fs.Count - 1];

                if not DirectoryExists(IncludeTrailingPathDelimiter(BlogsPath)+BlogDomain+'\'+finalPath) then
                  CreateDir(IncludeTrailingPathDelimiter(BlogsPath)+BlogDomain+'\'+finalPath);
              finally
                fs.Free;
              end;
            end;
            //
            if finalPath <> '' then
              rkSmartPath1.Path := IncludeTrailingPathDelimiter(BlogsPath) + BlogDomain + '\' + finalPath;
          end;
        end;
      end;

    finally
      json.Free;
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

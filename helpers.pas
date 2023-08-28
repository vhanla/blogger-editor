unit helpers;

interface

uses
  System.SysUtils, System.Threading, System.Classes, Vcl.ValEdit;

function ExtractDomainFromURL(const URL: string): string;
function GetURLTitle(const URL: string; var urlList: TValueListEditor): string;
function EncodeURL(const URL: string): string;
function DecodeURL(const URL: string): string;

implementation

uses
  Winapi.ActiveX, Winapi.msxml, Net.HttpClient, Win.ComObj, HtmlParserEx;

/// <summary>A simple URL extractor, not complete</summary>
/// <param name="URL">Long URL path e.g. https://www.domain.com/bunch/of/other/text?to=remove</param>
/// <remarks>Only for http:// or https:// urls with routes</remarks>
/// <returns>Only the domain, e.g. www.domain.com</returns>
function ExtractDomainFromURL(const URL: string): string;
var
  ProtocolPos, DomainStart, DomainEnd: Integer;
begin
  Result := '';

  ProtocolPos := Pos('://', URL);

  if ProtocolPos > 0 then
    DomainStart := ProtocolPos + 3
  else
    DomainStart := 1;

  DomainEnd := Pos('/', URL, DomainStart + 1);
  if DomainEnd = 0 then
    DomainEnd := Length(URL) + 1;

  Result := Copy(URL, DomainStart, DomainEnd - DomainStart);
end;

function GetURLTitle(const URL: string; var urlList: TValueListEditor): string;
type
  PValueListEditor = ^TValueListEditor;
var
  tmpRes: string;
  ls: PValueListEditor;
begin
  tmpRes := '';
  ls := @urlList;

  CoInitialize(nil);

  try
    TTask.Run(procedure
    var
      web: THTTPClient;
      res: IHTTPResponse;
      tmp: string;
      iRoot: IHtmlElement;
    begin
      web := THTTPClient.Create;

      try
        res := web.Get(URL);
        if res.StatusCode = 200 then
        begin
          tmp := '';
          iRoot := ParserHTML(res.ContentAsString());
          if (iRoot.ChildrenCount > 0) and (iRoot.Find('title').Count = 1) then
          begin
            TThread.Synchronize(nil,
            procedure
            begin
              tmpRes := iRoot.Find('title').Text;
              ls^.InsertRow(EncodeURL(URL), tmpRes, False);
            end);
          end;
        end;


      finally
        web.Free;
      end;

    end);


  finally
    CoUninitialize;
  end;

  Result := Trim(tmpRes);
end;

function EncodeURL(const URL: string): string;
var
  txt: string;
begin
  //if txt.Contains('＝') then //U+FF1D Looks like = but it isn't
  Result := StringReplace(URL, '=', '＝', [rfReplaceAll]);
end;

function DecodeURL(const URL: string): string;
begin
  Result := StringReplace(URL, '＝', '=', [rfReplaceAll]);
end;

end.

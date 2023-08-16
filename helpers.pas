unit helpers;

interface

uses
  System.SysUtils;

function ExtractDomainFromURL(const URL: string): string;


implementation

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

end.

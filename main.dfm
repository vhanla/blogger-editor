object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Blogger Desktop 1.0'
  ClientHeight = 765
  ClientWidth = 1385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu1
  OnCreate = FormCreate
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 770
    Top = 0
    Width = 5
    Height = 746
    Align = alRight
    ExplicitLeft = 682
    ExplicitTop = 27
    ExplicitHeight = 755
  end
  object pnlContainr: TPanel
    Left = 0
    Top = 0
    Width = 770
    Height = 746
    Align = alClient
    TabOrder = 0
    object WVWindowParent1: TWVWindowParent
      Left = 1
      Top = 1
      Width = 768
      Height = 744
      Align = alClient
      Color = clBackground
      TabOrder = 0
      Browser = WVBrowser1
    end
  end
  object pnlTools: TPanel
    Left = 775
    Top = 0
    Width = 610
    Height = 746
    Align = alRight
    TabOrder = 1
    object pcTools: TPageControl
      Left = 1
      Top = 1
      Width = 608
      Height = 744
      ActivePage = tsOpenAI
      Align = alClient
      TabOrder = 0
      object tsPictures: TTabSheet
        Caption = 'Pictures'
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 600
          Height = 41
          Align = alTop
          Caption = 'Panel1'
          TabOrder = 0
        end
        object Panel2: TPanel
          Left = 0
          Top = 519
          Width = 600
          Height = 195
          Align = alBottom
          Caption = 'Panel2'
          TabOrder = 1
          object ScrollBox1: TScrollBox
            Left = 1
            Top = 1
            Width = 598
            Height = 193
            Align = alClient
            TabOrder = 0
            object EsImage1: TEsImage
              Left = 0
              Top = 0
              Width = 594
              Height = 189
              Align = alClient
              DragMode = dmAutomatic
              Stretch = Fit
              OnMouseDown = EsImage1MouseDown
              ExplicitLeft = 32
              ExplicitTop = 8
              ExplicitWidth = 321
              ExplicitHeight = 178
            end
          end
        end
        object rkSmartPath1: TrkSmartPath
          Left = 0
          Top = 41
          Width = 600
          Height = 25
          Align = alTop
          BtnGreyGrad1 = 15921906
          BtnGreyGrad2 = 14935011
          BtnNormGrad1 = 16643818
          BtnNormGrad2 = 16046502
          BtnHotGrad1 = 16643818
          BtnHotGrad2 = 16441260
          BtnPenGray = 9408399
          BtnPenNorm = 11632444
          BtnPenShade1 = 9598820
          BtnPenShade2 = 15388572
          BtnPenArrow = clBlack
          ComputerAsDefault = True
          DirMustExist = True
          EmptyPathIcon = -1
          EmptyPathText = 'Este equipo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clHighlightText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          NewFolderName = 'NewFolder'
          ParentColor = False
          ParentBackground = False
          ParentFont = False
          Path = 'C:\Users\vhanl\Pictures\'
          SpecialFolders = [spDesktop, spDocuments]
          TabOrder = 2
          Transparent = True
          OnPathChanged = rkSmartPath1PathChanged
        end
        object VirtualMultiPathExplorerEasyListview1: TVirtualMultiPathExplorerEasyListview
          Left = 0
          Top = 66
          Width = 600
          Height = 453
          Align = alClient
          CellSizes.ReportThumb.Height = 112
          CellSizes.ReportThumb.Width = 94
          CompressedFile.Color = clRed
          CompressedFile.Font.Charset = DEFAULT_CHARSET
          CompressedFile.Font.Color = clWindowText
          CompressedFile.Font.Height = -12
          CompressedFile.Font.Name = 'Segoe UI'
          CompressedFile.Font.Style = []
          DefaultSortColumn = 0
          EditManager.Font.Charset = DEFAULT_CHARSET
          EditManager.Font.Color = clWindowText
          EditManager.Font.Height = -12
          EditManager.Font.Name = 'Segoe UI'
          EditManager.Font.Style = []
          EncryptedFile.Color = 32832
          EncryptedFile.Font.Charset = DEFAULT_CHARSET
          EncryptedFile.Font.Color = clWindowText
          EncryptedFile.Font.Height = -12
          EncryptedFile.Font.Name = 'Segoe UI'
          EncryptedFile.Font.Style = []
          FileSizeFormat = vfsfDefault
          Grouped = False
          GroupingColumn = 0
          Header.Height = 23
          PaintInfoGroup.MarginBottom.CaptionIndent = 4
          PaintInfoGroup.MarginTop.Visible = False
          RootFolder = rfMyPictures
          Sort.Algorithm = esaQuickSort
          Sort.AutoSort = True
          SortFolderFirstAlways = True
          TabOrder = 3
          ThumbsManager.StorageFilename = 'Thumbnails.album'
          View = elsThumbnail
          OnItemClick = VirtualMultiPathExplorerEasyListview1ItemClick
          OnItemDblClick = VirtualMultiPathExplorerEasyListview1ItemDblClick
          OnMouseDown = VirtualMultiPathExplorerEasyListview1MouseDown
        end
      end
      object tsOpenAI: TTabSheet
        Caption = 'tsOpenAI'
        ImageIndex = 1
        inline Frame11: TFrame1
          Left = 0
          Top = 0
          Width = 600
          Height = 714
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 600
          ExplicitHeight = 714
          inherited GroupBox1: TGroupBox
            Width = 600
            ExplicitWidth = 600
            inherited Memo1: TMemo
              Width = 596
              ExplicitWidth = 596
            end
          end
          inherited GroupBox2: TGroupBox
            Top = 530
            Width = 600
            ExplicitTop = 530
            ExplicitWidth = 600
            inherited Memo2: TMemo
              Width = 596
              ExplicitWidth = 596
            end
          end
          inherited GroupBox4: TGroupBox
            Width = 600
            Height = 254
            ExplicitWidth = 600
            ExplicitHeight = 254
            inherited hChat2: ThChat
              Width = 596
              Height = 235
              ExplicitWidth = 596
              ExplicitHeight = 235
            end
          end
          inherited Panel3: TPanel
            Top = 487
            Width = 600
            ExplicitTop = 487
            ExplicitWidth = 600
            DesignSize = (
              600
              43)
          end
        end
      end
      object TabSheet1: TTabSheet
        Caption = 'Settings'
        ImageIndex = 2
        object lbedBlogsPath: TLabeledEdit
          Left = 32
          Top = 48
          Width = 393
          Height = 23
          EditLabel.Width = 355
          EditLabel.Height = 15
          EditLabel.Caption = 
            'Blogger Posts Path (keep blogs files here, included temporary on' +
            'es)'
          TabOrder = 0
          Text = ''
        end
        object CheckBox1: TCheckBox
          Left = 32
          Top = 88
          Width = 417
          Height = 17
          Caption = 
            'Autodetect blogger site (url) and permalinks to save tree folder' +
            's'
          Checked = True
          Enabled = False
          State = cbChecked
          TabOrder = 1
        end
        object Button1: TButton
          Left = 431
          Top = 47
          Width = 75
          Height = 25
          Caption = '...'
          TabOrder = 2
          OnClick = Button1Click
        end
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 746
    Width = 1385
    Height = 19
    Panels = <>
  end
  object WVBrowser1: TWVBrowser
    TargetCompatibleBrowserVersion = '106.0.1370.28'
    AllowSingleSignOnUsingOSPrimaryAccount = False
    OnAfterCreated = WVBrowser1AfterCreated
    OnNavigationStarting = WVBrowser1NavigationStarting
    OnNavigationCompleted = WVBrowser1NavigationCompleted
    OnDocumentTitleChanged = WVBrowser1DocumentTitleChanged
    OnWebMessageReceived = WVBrowser1WebMessageReceived
    OnWebResourceResponseReceived = WVBrowser1WebResourceResponseReceived
    OnDOMContentLoaded = WVBrowser1DOMContentLoaded
    Left = 464
    Top = 312
  end
  object MainMenu1: TMainMenu
    Left = 312
    Top = 144
    object File1: TMenuItem
      Caption = '&File'
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 688
    Top = 400
  end
  object PopupMenu1: TPopupMenu
    Left = 584
    Top = 424
    object Copypath1: TMenuItem
      Caption = 'Copy path'
    end
  end
  object DropFileSource1: TDropFileSource
    DragTypes = [dtCopy]
    ShowImage = True
    Left = 672
    Top = 568
  end
  object JvAppEvents1: TJvAppEvents
    OnActivate = JvAppEvents1Activate
    Left = 688
    Top = 408
  end
  object OpenDialog1: TOpenDialog
    Left = 968
    Top = 296
  end
end

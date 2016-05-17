{ KOL MCK } // Do not remove this line!

procedure NewFormChat( var Result: PFormChat; AParent: PControl );
begin

  {$IFDEF KOLCLASSES}
  Result := PFormChat.Create;
  {$ELSE OBJECTS}
  New( Result, Create );
  {$ENDIF KOL CLASSES/OBJECTS}
  Result.Form := NewForm( AParent, 'Xtreme RAT' ).SetPosition( 716, 136 );
  Applet :=  Result.Form;
  Result.Form.Add2AutoFree( Result );
     Result.Form.SetUnicode(TRUE);
    Result.Form.ExStyle := Result.Form.ExStyle or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
    Result.Form.Visible := False;
    Result.Form.DoubleBuffered := True;
    Result.Form.Style := Result.Form.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
    Result.Form.SetClientSize( 492, 369 );
    Result.Form.Font.FontHeight := -11;
      Result.Form.OnClose := Result.KOLFormClose;
      Result.Form.OnShow := Result.KOLFormShow;

    Result.OpenSaveDialog1 := NewOpenSaveDialog( '', '', [ OSCreatePrompt, OSFileMustExist, OSHideReadonly, OSOverwritePrompt, OSPathMustExist ] );
  Result.Form.Add2AutoFree( Result.OpenSaveDialog1 );
    Result.GradientPanel1 := NewGradientPanel( Result.Form, $F9F9F9, $939393 ).SetAlign ( caClient );
   Result.GradientPanel1.SetUnicode(TRUE);
    Result.GradientPanel1.TabStop := FALSE;
    Result.GradientPanel1.HasBorder := TRUE;
      Result.Label1 := NewLabel( Result.GradientPanel1, 'Type your message here: ' ).SetPosition( 8, 265 ).AutoSize( TRUE );
   Result.Label1.SetUnicode(TRUE);
      Result.Label1.Transparent := True;
    Result.Label1.Color := TColor(clBtnFace);
      Result.Label2 := NewLabel( Result.GradientPanel1, '' ).SetPosition( -66, 314 ).SetSize( 553, 11 );
   Result.Label2.SetUnicode(TRUE);
    Result.Label2.Color := TColor($2B8C63);
      Result.Label3 := NewLabel( Result.GradientPanel1, 'Chat history: ' ).SetPosition( 8, 5 ).AutoSize( TRUE );
   Result.Label3.SetUnicode(TRUE);
      Result.Label3.Transparent := True;
    Result.Label3.Color := TColor(clBtnFace);
      Result.EditBox1 := NewEditBox( Result.GradientPanel1, [  ] ).SetPosition( 8, 282 ).SetSize( 470, 0 );
    {$IFNDEF UNICODE_CTRLS}Result.EditBox1.SetUnicode( TRUE );{$ENDIF}
      Result.EditBox1.Text := 'EditBox1';
      Result.Button1 := NewButton( Result.GradientPanel1, 'Save' ).SetPosition( 8, 333 ).SetSize( 0, 25 );
   Result.Button1.SetUnicode(TRUE);
      Result.Button2 := NewButton( Result.GradientPanel1, 'Send' ).SetPosition( 333, 333 ).SetSize( 0, 25 );
   Result.Button2.SetUnicode(TRUE);
      Result.Button3 := NewButton( Result.GradientPanel1, 'Close' ).SetPosition( 413, 333 ).SetSize( 0, 25 );
   Result.Button3.SetUnicode(TRUE);
      Result.Memo1 := NewEditBox( Result.GradientPanel1, [ eoMultiline, eoReadonly ] ).SetPosition( 8, 24 ).SetSize( 470, 232 );
    {$IFNDEF UNICODE_CTRLS}Result.Memo1.SetUnicode( TRUE );{$ENDIF}
      Result.Memo1.DoubleBuffered := True;
      Result.Memo1.Text := 'Memo1'+#13+#10;
      Result.OpenSaveDialog1.WndOwner := Result.Form.GetWindowHandle;
    Result.Label1.Anchor(FALSE, FALSE, FALSE, TRUE);
    Result.EditBox1.Color := TColor(clWindow);
      Result.EditBox1.OnEnter := Result.EditBox1Enter;
      Result.EditBox1.OnLeave := Result.EditBox1Leave;
      Result.EditBox1.OnKeyChar := Result.EditBox1KeyChar;
    Result.EditBox1.Anchor(TRUE, FALSE, TRUE, TRUE);
    Result.Label2.Anchor(FALSE, FALSE, TRUE, TRUE);
      Result.Button1.OnClick := Result.Button1Click;
    Result.Button1.Anchor(TRUE, FALSE, FALSE, TRUE);
      Result.Button2.OnClick := Result.Button2Click;
    Result.Button2.Anchor(FALSE, FALSE, TRUE, TRUE);
    Result.Memo1.Color := TColor(clWindow);
    Result.Memo1.Anchor(TRUE, TRUE, TRUE, TRUE);
      Result.Button3.OnClick := Result.Button3Click;
    Result.Button3.Anchor(FALSE, FALSE, TRUE, TRUE);
    Result.Form.CenterOnParent.CanResize := False;
    Result.Form.Perform( WM_INITMENU, 0, 0 );
    Result.Form.Icon := THandle(-1);

end;


Os passwords funcionaram com a versão 6.02 do firefox, mas o login veio com um caractere a mais

1. Instalar o Virtual Tree View no delphi 2010 e copiar a pasta para: $(BDS)\Componentes\VST
3. Instalar o componente KOL Unicode no delphi 7. Mas pode-se instalar no delphi 2010 usando o arquivo "MirrorKOLPackageD12.dpk"
   Faça a instalação normal do KOL e depois pegue os arquivos da versão Unicode e substitua
      Para usar esses componentes, após instalados deve-se criar projetos da seginte forma:
      1- Abra o delphi 7 e vá em: File | New | Others...
      2- Selecione a opção "wizard". Lá haverá uma paleta do KOL.
      3- Fiz umas modifcações e só pode-se usar como UNICODE, ou seja, não use "ansi" nos Projetos.
4. Abra o arquivo "Componentes XtremeRAT.rar" e copie os dados para a pasta "$(BDS)\Componentes\"
   Instalar o componente TMS no delphi 2010.
   Ir até a opção Tools no delphi 2010 | Options | Environment Options | Delphi Options | Library - Win32 | e adicionar na Library Path
		$(BDS)\Source\Indy\indy10\System 
		$(BDS)\Source\Indy\indy10\Core 
		$(BDS)\Source\Indy\indy10\Protocols
		$(BDS)\Componentes\TMS	
5. Instalar o componente AlphaControls.7.26 e após a instalação copiar os arquivos para a pasta $(BDS)\Componentes\AlphaControls\D2010 e então
   Ir até a opção Tools no delphi 2010 | Options | Environment Options | Delphi Options | Library - Win32 | e adicionar na Library Path
		$(BDS)\Componentes\AlphaControls\D2010	
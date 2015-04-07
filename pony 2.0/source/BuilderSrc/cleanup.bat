@echo off
if exist *.bak @del /Q *.bak
if exist *.exe.log @del /Q *.exe.log
if exist *.~* @del /Q *.~*
if exist *.dcu @del /Q *.dcu
if exist *.ddp @del /Q *.ddp
if exist *.upx @del /Q *.upx
if exist *.mpt @del /Q *.mpt
if exist *.mps @del /Q *.mps
if exist *.obj @del /Q *.obj

@del /Q /S ResourceUtils\*.~*
@del /Q /S ResourceUtils\*.dcu

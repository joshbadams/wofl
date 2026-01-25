@echo off

rmdir /s /q Build
mkdir Build\Neuro\Binaries
mkdir Build\Neuro\Neuro\Resources
mkdir Build\Engine\Rendering\Resources

xcopy *.* Build\Neuro\Binaries\
xcopy /s ..\Neuro\Resources\*.* Build\Neuro\Neuro\Resources\
xcopy /s ..\..\Engine\Rendering\Resources\*.* Build\ENgine\Rendering\Resources\

copy neurocrk.bat Build


set GEN_CLIENT=dotnet .\Tools\Luban.ClientServer\Luban.ClientServer.dll

%GEN_CLIENT% -j cfg --^
 -d .\Source\__root.xml ^
 --input_data_dir .\Source\Modules ^
 --output_data_dir .\Output ^
 --output_code_dir .\Gen ^
 --gen_types code_cs_unity_bin,code_lua_bin,data_bin ^
 -s all

set BIN_DST=..\Assets\LubanGen\Bin
set CS_DST=..\Assets\LubanGen\Code
set LUA_DST=..\Lua\config\Types.lua

move .\Gen\Types.lua %LUA_DST%
xcopy /Y /E .\Output %BIN_DST%
xcopy /Y /E .\Gen %CS_DST%

pause
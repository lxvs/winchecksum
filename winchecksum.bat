@echo off
setlocal enableextensions disabledelayedexpansion
call:init
if %1. == . (goto help)
:parseargs
if %1. == . (goto endparseargs)
if defined stopparsing (
    set "files=%files%%~1|"
    shift /1
    goto parseargs
)
if "%~1" == "/?" (goto help)
if "%~1" == "-?" (goto help)
if "%~1" == "--help" (goto help)
if "%~1" == "--version" (goto version)
if "%~1" == "-a" (
    if %2. == . (
        call:err "error: `%~1' requires a value"
        goto end
    )
    set "_a=%~2"
    shift /1
    shift /1
    goto parseargs
)
if "%~1" == "--algorithm" (
    if %2. == . (
        call:err "error: `%~1' requires a value"
        goto end
    )
    set "_a=%~2"
    shift /1
    shift /1
    goto parseargs
)
if "%~1" == "--full-path" (
    set _no_full_path=
    shift /1
    goto parseargs
)
if "%~1" == "--no-full-path" (
    set _no_full_path=1
    shift /1
    goto parseargs
)
if "%~1" == "-c" (
    set _c=1
    set _copy_with_filename=
    set _copy_with_path=
    shift /1
    goto parseargs
)
if "%~1" == "--copy" (
    set _c=1
    set _copy_with_filename=
    set _copy_with_path=
    shift /1
    goto parseargs
)
if "%~1" == "--copy-with-filename" (
    set _c=
    set _copy_with_filename=1
    set _copy_with_path=
    shift /1
    goto parseargs
)
if "%~1" == "--copy-with-path" (
    set _c=
    set _copy_with_filename=
    set _copy_with_path=1
    shift /1
    goto parseargs
)
if "%~1" == "--no-copy" (
    set _c=
    set _copy_with_filename=
    set _copy_with_path=
    shift /1
    goto parseargs
)
if "%~1" == "-p" (
    set _p=1
    shift /1
    goto parseargs
)
if "%~1" == "--pause" (
    set _p=1
    shift /1
    goto parseargs
)
if "%~1" == "-n" (
    set _p=
    shift /1
    goto parseargs
)
if "%~1" == "--no-pause" (
    set _p=
    shift /1
    goto parseargs
)
if "%~1" == "-q" (
    set _q=1
    shift /1
    goto parseargs
)
if "%~1" == "--quiet" (
    set _q=1
    shift /1
    goto parseargs
)
if "%~1" == "--silent" (
    set _q=1
    shift /1
    goto parseargs
)
if "%~1" == "-l" (
    set _u=
    shift /1
    goto parseargs
)
if "%~1" == "--lowercase" (
    set _u=
    shift /1
    goto parseargs
)
if "%~1" == "--no-uppercase" (
    set _u=
    shift /1
    goto parseargs
)
if "%~1" == "-u" (
    set _u=1
    shift /1
    goto parseargs
)
if "%~1" == "--uppercase" (
    set _u=1
    shift /1
    goto parseargs
)
if "%~1" == "--no-lowercase" (
    set _u=1
    shift /1
    goto parseargs
)
if "%~1" == "-f" (
    set _f=1
    shift /1
    goto parseargs
)
if "%~1" == "--file" (
    set _f=1
    shift /1
    goto parseargs
)
if "%~1" == "--no-file" (
    set _f=
    shift /1
    goto parseargs
)
if "%~1" == "--overwrite" (
    set _overwrite=1
    shift /1
    goto parseargs
)
if "%~1" == "--no-overwrite" (
    set _overwrite=
    shift /1
    goto parseargs
)
if "%~1" == "--md2" (
    set _a=md2
    shift /1
    goto parseargs
)
if "%~1" == "--md4" (
    set _a=md4
    shift /1
    goto parseargs
)
if "%~1" == "--md5" (
    set _a=md5
    shift /1
    goto parseargs
)
if "%~1" == "--sha1" (
    set _a=sha1
    shift /1
    goto parseargs
)
if "%~1" == "--sha256" (
    set _a=sha256
    shift /1
    goto parseargs
)
if "%~1" == "--sha384" (
    set _a=sha384
    shift /1
    goto parseargs
)
if "%~1" == "--sha512" (
    set _a=sha512
    shift /1
    goto parseargs
)
if "%~1" == "--" (
    set stopparsing=1
    shift /1
    goto parseargs
)
if "%~1" == "--goto-copythingsloop" (
    set "tobecopied=%~2"
    goto copythingsloop
)
set "arg=%~1"
set "argpre=%arg:~0,1%"
if "%argpre%" == "-" (
    call:err "error: invalid argument `%arg%'" "Try `winchecksum --help' for more information."
    goto end
)
set "files=%files%%~1|"
shift /1
goto parseargs
:endparseargs

call:validatealgorithms || goto end
call:validatefiles || goto end
call:doit || goto end
call:copythings "%~dpnx0" || goto end
goto end

if defined _a (echo _a: %_a%)
if defined _no_full_path (echo _no_full_path)
if defined _c (echo _c)
if defined _copy_with_filename (echo _copy_with_filename)
if defined _copy_with_path (echo _copy_with_path)
if defined _p (echo _p)
if defined _q (echo _q)
if defined _u (echo _u)
if defined _f (echo _f)
if defined _overwrite (echo _overwrite)

:displayfiles
set "dfiles=%files%"
:displayfiles_loop
if defined dfiles (
    for /f "tokens=1* delims=|" %%a in ("%dfiles%") do (
        echo file: `%%~a'
        echo   directory: `%%~dpa'
        echo   name: `%%~nxa'
        set "dfiles=%%~b"
    )
)
if defined dfiles (goto displayfiles_loop)

goto end

:init
set version=0.1.0
set ec=0
set stopparsing=
set files=
set _a=
set _no_full_path=
set _c=
set _copy_with_filename=
set _copy_with_path=
set _p=
set _q=
set _u=
set _f=
set _overwrite=
set firstfile=1
set tobecopied=
exit /b
::init

:validatealgorithms
if not defined _a ((set _a=SHA256) & (exit /b 0))
if /i "%_a%" == "md2" ((set _a=MD2) & (exit /b 0))
if /i "%_a%" == "md4" ((set _a=MD4) & (exit /b 0))
if /i "%_a%" == "md5" ((set _a=MD5) & (exit /b 0))
if /i "%_a%" == "sha1" ((set _a=SHA1) & (exit /b 0))
if /i "%_a%" == "sha256" ((set _a=SHA256) & (exit /b 0))
if /i "%_a%" == "sha384" ((set _a=SHA384) & (exit /b 0))
if /i "%_a%" == "sha512" ((set _a=SHA512) & (exit /b 0))
call:err "error: invalid algorithm `%_a%'"
exit /b 1
::validatealgorithms

:validatefiles
set "vfiles=%files%"
:validatefilesloop
if defined vfiles (
    for /f "tokens=1* delims=|" %%a in ("%vfiles%") do (
        if not exist "%%~a" (
            call:err "error: file `%%~a' does not exist"
            exit /b 1
        )
        if exist "%%~a\" (
            call:err "error: `%%~a' is a directory"
            exit /b 1
        )
        if %%~z1 == 0 (
            call:err "error: file `%%~a' is empty"
            exit /b 1
        )
        set "vfiles=%%~b"
    )
)
if defined vfiles (goto validatefilesloop)
exit /b 0
::validatefiles

:doit
if defined files (
    for /f "tokens=1* delims=|" %%a in ("%files%") do (
        call:sayfilename "%%~dpa" "%%~nxa"
        call:calculate "%%~dpa" "%%~nxa" "%_a%"
        set "files=%%~b"
    )
)
if defined files (goto doit)
exit /b 0
::doit

:sayfilename
set "dir=%~1"
set "basename=%~2"
if not defined firstfile (
    call:newline
    if defined _copy_with_filename (set "tobecopied=%tobecopied%<>|")
    if defined _copy_with_path (set "tobecopied=%tobecopied%<>|")
)
set firstfile=
if defined _no_full_path (
    call:say "%basename%"
) else (
    call:say "%dir%%basename%"
)
if defined _copy_with_filename (set "tobecopied=%tobecopied%%basename%|")
if defined _copy_with_path (set "tobecopied=%tobecopied%%dir%%basename%|")
exit /b
::sayfilename

:calculate
set "dir=%~1"
set "basename=%~2"
set "algor=%~3"
set "file=%dir%%basename%"
set result=
for /f "skip=1 delims=" %%i in ('certutil -hashfile "%file%" %algor%') do (
    if not defined result (set "result=%%~i")
)
if /i "%result:~0,8%" NEQ "certutil" (goto calculate_skipcertutilerror)
set "result=%result:~10%"
call:err "error: %result%"
exit /b 1
:calculate_skipcertutilerror
if not defined _u (goto calculate_skipuppercase)
set upper=
for /f "skip=2 delims=" %%i in ('tree "\%result%"') do (
    if not defined upper (set "upper=%%~i")
)
set "result=%upper:~3%"
:calculate_skipuppercase
call:say "%algor%: %result%"
if defined _c (set "tobecopied=%tobecopied%%result%|")
if defined _copy_with_filename (set "tobecopied=%tobecopied%%algor%: %result%|")
if defined _copy_with_path (set "tobecopied=%tobecopied%%algor%: %result%|")
set "fname=%dir%\%basename%.%algor%"
if defined _f (
    if exist "%fname%" (
        if exist "%fname%\" (
            call:err "error: `%fname%' is a directory"
            exit /b 1
        )
        if not defined _overwrite (
            call:err "error: file `%fname%' already exists"
            exit /b 1
        )
    )
    cmd /c "(echo %basename%) & (echo %algor%: %result%)" >"%fname%"
)
exit /b 0
::calculate

:copythings
if defined tobecopied ((call %1 --goto-copythingsloop "%tobecopied%") | clip)
exit /b 0
::copythings

:copythingsloop
if not defined tobecopied (exit /b 0)
for /f "tokens=1* delims=|" %%a in ("%tobecopied%") do (
    if "%%~a" == "<>" (
        echo;
    ) else (
        echo %%~a
    )
    set "tobecopied=%%~b"
)
goto copythingsloop

:help
call:version
@echo;
@echo usage: winchecksum [OPTIONS...] [--] FILE...
@echo    or: winchecksum --version
@echo    or: winchecksum --help
@echo;
@echo options:
@echo     -a, --algorithm         Specify algorithm: MD2, MD4, MD5, SHA1, SHA256,
@echo                               SHA384, SHA512; default is SHA256
@echo     --full-path             Display full file path; this is default
@echo     --no-full-path          Display filename, instead of full path
@echo     -c, --copy              Copy checksum value
@echo     --copy-with-filename    Copy filename, algorithm and checksum value
@echo     --copy-with-path        Copy file path, algorithm and checksum value
@echo     --no-copy               Do not copy anything
@echo     -n, --no-pause          Exit after calculating checksum; this is default
@echo     -p, --pause             Pause after calculating checksum
@echo     -q, --quiet, --silent   Suppress all output; implies `--no-pause'
@echo     -l, --lowercase         Use lower case output; this is default
@echo     -u, --uppercase         Use UPPER CASE output
@echo     -f, --file              Write filename, algorithm and checksum value to file
@echo                               `[FILENAME].[ALGORITHM]'; error if this file
@echo                               exists, unless `--overwrite' is specified
@echo     --no-overwrite          Do not overwrite existing file when `--file' is
@echo                               specified; this is default
@echo     --overwrite             Overwrite existing file when `--file' is specified
@echo     --md2                   equivalent to `--algorithm md2'
@echo     --md4                   equivalent to `--algorithm md4'
@echo     --md5                   equivalent to `--algorithm md5'
@echo     --sha1                  equivalent to `--algorithm sha1'
@echo     --sha256                equivalent to `--algorithm sha256'
@echo     --sha384                equivalent to `--algorithm sha384'
@echo     --sha512                equivalent to `--algorithm sha512'
@echo     --                      Stop argument parsing, only file paths after this
exit /b
::help

:version
@echo winchecksum %version%
@echo https://github.com/lxvs/winchecksum
exit /b
::version

:say
if defined _q (exit /b)
:say_loop
if "%~1" == "" (
    if %1. == . (exit /b)
    shift /1
    goto say_loop
)
set "say_content=%~1"
set "say_content=%say_content:&=^&%"
echo %say_content%
shift /1
goto say_loop
::say

:newline
if not defined _q (echo;)
exit /b
::newline

:err
set ec=1
if defined _q (exit /b)
:err_loop
if "%~1" == "" (
    if %1. == . (exit /b)
    shift /1
    goto err_loop
)
>&2 echo %~1
shift /1
goto err_loop
::err

:end
if defined _p (
    if not defined _q (echo Press any key to exit)
    pause >nul
)
exit /b %ec%

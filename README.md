gtat-stats-fs
=============

Version: 1.0

Filterscript to upload stats to http://gtat.org

## How to install

1. Put the `gtat-stats-fs.amx` in your `filterscripts` folder.
2. add gtat-stats-fs to your `filterscripts=` line in the `server.cfg`

    filterscripts=gtat-stats-fs

3. Create a `scriptfiles/gtat-stats-fs.ini` with the contents:

    host=api.gtat.org
    key=testkey

`testkey` should be the key, given by dracoblue from <http://gtat.org>

## Compile on samp scripts on Linux

### Install Wine

    $ sudo apt-get install wine

### Install Winetricks

    $ wget http://winetricks.org/winetricks
    $ chmod +x winetricks 
    $ ./winetricks --unattended vcrun2005

### Download SAMP Server for Windows

    $ mkdir samp03e
    $ cd samp03e
    $ wget http://files.sa-mp.com/samp03e_svr_R2_win32.zip
    $ unzip samp03e_svr_R2_win32.zip

### Test compiling

    $ cd filterscripts
    $ wine ../pawno/pawncc.exe base.pwn

Expected output:    

    Pawn compiler 3.2.3664          Copyright (c) 1997-2006, ITB CompuPhase

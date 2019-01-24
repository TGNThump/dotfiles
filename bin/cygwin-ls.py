#!/bin/python

import os, sys

preload = 1
for arg in sys.argv[1:]:
    if "--all" == arg or "--almost-all" == arg:
        preload = 0
    elif arg.startswith("-") and ("a" in arg or "A" in arg):
        preload = 0
    elif "--" == arg:
        break

if 1 == preload:
    dllname = "cygwin_ls_readdir.dll"
    progdir = os.path.dirname(sys.argv[0])
    dllpath = os.path.join(progdir, dllname)
    if not os.path.exists(dllpath):
        os.spawnl(os.P_WAIT, "/bin/bash", "/bin/bash", os.path.join(progdir, "../src", os.path.splitext(dllname)[0] + ".c"), "-o", dllpath)
    os.putenv("LD_PRELOAD", dllpath)
os.execv("/bin/ls", ["/bin/ls"] + sys.argv[1:])
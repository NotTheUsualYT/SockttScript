# Sockttscript
# (C) 2021, Sockttsoft inc
import sys
import re


def interpret():
    asmfiledata = []
    asmfiletext = []
    isBootable = False
    includeFunc = False

    if not sys.argv[1]:
        sys.stderr.write("Error: No input file")
    else:
        try:
            with open(sys.argv[1], "r") as f:
                for line in f:
                    if line.startswith("str"):
                        strname = line[4:].partition(" ")[0]
                        strdata = re.findall('(?:")([^"]*)(?:")', line)
                        if len(strdata) > 1:
                            sys.stderr.write("Error: more than 1 string")

                        asmfiledata.append("{}: db \"{}\", 10, 13, 0".format(strname, strdata[0]))
                    elif line.startswith("print"):
                        strname = line[6:].partition("\n")[0]
                        asmfiletext.append("mov si, {}".format(strname))
                        asmfiletext.append("call print")
                    elif line.startswith("clearscreen"):
                        asmfiletext.append("call clearscreen")
                    elif line.startswith("bluescreen"):
                        asmfiletext.append("call clearscreen")
                        asmfiletext.append("call bluescreen")
                    elif line.startswith("readKernel"):
                        asmfiletext.append("call readkernel")
                    elif line.startswith("jump"):
                        asmfiletext.append("jmp {}".format(line[5:].partition(" ")[0]))
                    elif line.startswith("BOOTABLE"):
                        isBootable = True
                    elif line.startswith("INCLUDEFUNC"):
                        includeFunc = True


                    else:
                        sys.stderr.write("Error: unknown command: {}".format(line))

                print(asmfiletext)
                print(asmfiledata)

        except FileNotFoundError:
            sys.stderr.write("Error: No such file")

    asmfilename = sys.argv[1].partition(".")[0] + ".asm"
    with open(asmfilename, "w") as f:
        if isBootable:
            f.write("[org 0x7C00]\n")
        else:
            f.write("[org 0x7E00]\n")
        for line in asmfiletext:
            f.write(line)
            f.write("\n")

        f.write("jmp $\n")
        if includeFunc:
            f.write('%include "func.asm"\n')

        for line in asmfiledata:
            f.write(line)
            f.write("\n")
        if isBootable:
            f.write("times 510-($-$$) db 0\ndw 0xAA55")
        else:
            f.write("times 512-($-$$) db 0")


interpret()

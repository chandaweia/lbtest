#!/usr/bin/python3
import os
ULatency=1

def readfile(filename):
    f = open(filename)
    line = f.readline()
    while line:
        if line.startswith("Running "):
            print(line)
        else:
            print(line)
        line = f.readline()
    f.close()
if __name__ == "__main__":
    readfile("./wrk5/wrk_01_w_20210329181422.txt")

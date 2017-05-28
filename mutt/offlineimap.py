#! /usr/bin/env python2
from subprocess import check_output

def get_user():
    return check_output("gpg -dq ~/.offlineimap/user.gpg", shell=True).strip("\n")
def get_pass():
    return check_output("gpg -dq ~/.offlineimap/passwd.gpg", shell=True).strip("\n")
def a_get_host():
    return check_output("gpg -dq ~/.offlineimap/a/host.gpg", shell=True).strip("\n")
def a_get_user():
    return check_output("gpg -dq ~/.offlineimap/a/user.gpg", shell=True).strip("\n")
def a_get_pass():
    return check_output("gpg -dq ~/.offlineimap/a/passwd.gpg", shell=True).strip("\n")


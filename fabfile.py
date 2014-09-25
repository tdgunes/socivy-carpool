__author__ = 'tdgunes'

import os

from fabric.api import local, run, cd, env


env.hosts = ['ubuntu@carpool.socivy.com']

def commit():
    """
    git add -p && git commit
    :return:
    """
    local("git add -p && git commit")


def push():
    """
    Git push
    :return:
    """
    local("git push")


def prepare_deploy():
    """
    Do it before deploying
    :return:
    """
    commit()
    push()


def uname():
    run("uname -a")


def deploy():
    """
    After committing, trigger server to stop services and git pull and restart
    :return:
    """
    raw_input("Please be sure that you have called 'prepare_deploy'")
    code_dir = "/var/www/socivy-carpool"
    with cd(code_dir):
        run("git pull")
        run("echo \"On commit:\"")
        run("git rev-list HEAD --count")
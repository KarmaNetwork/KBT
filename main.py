#!/usr/bin/env python
import click
import git
import cinit
import cbuild

@click.group()
def karma():
    pass

@click.command()
@click.option('--lib/--bin', default=True)
def init(lib):
    '''Initialize the current folder as the project.'''
    cinit.command(lib)
karma.add_command(init)

@click.command()
def run():
    '''Compile and run project.'''
    print('run')
karma.add_command(run)

@click.command()
def build():
    '''Only compile project code.'''
    cbuild.command()
karma.add_command(build)

@click.command()
def upload():
    '''Run or upload binary file.'''
    print('upload')
karma.add_command(upload)



if __name__ == '__main__':
    karma()

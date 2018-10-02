#!/usr/bin/env python3

from distutils import sysconfig
from distutils.version import LooseVersion
from json import loads
from os.path import join as pjoin
from os import walk
from subprocess import PIPE, run


def get_distutils_packages():
    """
    Returns a set containing distutils packages.
    """
    distutils_packages = set()
    std_lib = sysconfig.get_python_lib(standard_lib=True)
    for top, dirs, files in walk(std_lib):
        for nm in files:
            if nm != '__init__.py' and nm[-3:] == '.py':
                package = pjoin(
                    top, nm
                    )[len(std_lib) + 1:-3].replace('\\', '.')
                distutils_packages.add(package.split('/')[0])

    return distutils_packages


def get_package_versions():
    """
    Retrieve a list of outdated packages from pip. Calls:

        pip list [--outdated|--uptodate] --format=json [--not-required]
    """

    cmd = 'pip list --outdated --format=json'
    cmd_response = run(cmd, shell=True, stdout=PIPE)

    if cmd_response:
        pip_packages = loads(cmd_response.stdout)
        return pip_packages


def sort_packages(packages):
    """
    Sort packages into major/minor/unknown.
    """
    sorted_packages = {
        'major': [],
        'minor': [],
        'unknown': [],
    }

    for package in packages:
        # No version info
        if 'latest_version' not in package or 'version' not in package:
            sorted_packages['unknown'].append(package)

        try:
            latest = LooseVersion(package['latest_version'])
            current = LooseVersion(package['version'])
        except ValueError:
            # Unable to parse the version into anything useful
            sorted_packages['unknown'].append(package)

        # If the current version is larger than the latest
        # (e.g. a pre-release is installed) put it into the unknown section.
        # Technically its 'unchanged' but I guess its better to have
        # pre-releases stand out more.
        if current > latest:
            sorted_packages['unknown'].append(package)

        # Major upgrade (first version number)
        if latest.version[0] > current.version[0]:
            sorted_packages['major'].append(package)

        # Everything else is a minor update
        sorted_packages['minor'].append(package)

    return sorted_packages


def upgrade_packages(major=True, minor=True):
    """
    Upgrade packages.

    Packages of stdlib are not upgraded because it can break
    Linux programs which depends of it.
    """

    print('· Getting packages...')
    package_versions = get_package_versions()

    if package_versions:
        sorted_packages = sort_packages(package_versions)
        distutils_packages = get_distutils_packages()

        packages_to_upgrade = set()

        total_upgrades = 0

        if major:
            print('- - - Checking major updates - - -')
            for package in sorted_packages['major']:
                package_name = package['name']
                if package_name not in distutils_packages:
                    packages_to_upgrade.add(package_name)
                    total_upgrades += 1
                    print(f'{package_name} will be upgraded.')

        if minor:
            print('- - - Checking minor updates - - -')
            for package in sorted_packages['minor']:
                package_name = package['name']
                if package_name not in distutils_packages:
                    packages_to_upgrade.add(package_name)
                    total_upgrades += 1
                    print(f'{package_name} will be upgraded.')

        print('- - - Upgrading packages - - -')
        for package in packages_to_upgrade:
            run(f'sudo -H pip install -U {package}', shell=True)

    else:
        print('Packages could not be obtained.')


if __name__ == '__main__':
    upgrade_packages()

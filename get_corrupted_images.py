#!/usr/bin/env python3

from concurrent.futures import ProcessPoolExecutor
from multiprocessing import cpu_count
from os import walk
from os.path import join as pjoin
from subprocess import Popen, PIPE

verbose = False


def check_image_with_imagemagick(file_path):
    proc = Popen(['identify', '-verbose', file_path], stdout=PIPE, stderr=PIPE)
    out, err = proc.communicate()
    exitcode = proc.returncode
    return exitcode, out, err


def is_image_corrupted(file_path, verbose=verbose):
    exitcode, output, error = check_image_with_imagemagick(file_path)

    corrupted = False

    if exitcode != 0 or error != b'':
        corrupted = True
    else:
        corrupted = False

    if verbose:
        print(f'File: {file_path}, Corrupted: {corrupted}')

    return file_path, corrupted


def get_files_to_check(folder_to_check, file_extensions_list):
    files_to_check = []

    for file_extension in file_extensions_list:
        for directory, subdirectories, files, in walk(folder_to_check):
            for file in files:
                if file.lower().endswith(f'.{file_extension}'):
                    # We append file path to files_to_check.
                    files_to_check.append(pjoin(directory, file))

    return files_to_check


def check_images_on_pool(list_of_files_to_check, max_workers):
    with ProcessPoolExecutor(max_workers=max_workers) as executor:
        return executor.map(
            is_image_corrupted,
            list_of_files_to_check,
            timeout=60
            )


def get_corrupted_images(
    folder_to_check,
    file_extensions_list,
    max_workers=cpu_count()
        ):

    files_to_check = get_files_to_check(folder_to_check, file_extensions_list)

    checked_image_list = list(
        check_images_on_pool(
            files_to_check,
            max_workers
            )
        )

    corrupted_images = list(
        filter(
            lambda checked_image_list: checked_image_list[1],
            checked_image_list
            )
        )

    corrupted_images = [x[0] for x in corrupted_images]

    return corrupted_images

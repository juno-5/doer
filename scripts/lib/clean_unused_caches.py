#!/usr/bin/env python3
import argparse
import os
import shutil
import sys

DOER_PATH = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
sys.path.append(DOER_PATH)
from scripts.lib import clean_emoji_cache
from scripts.lib.doer_tools import parse_cache_script_args


def main(args: argparse.Namespace) -> None:
    os.chdir(DOER_PATH)
    shutil.rmtree("/srv/zulip-venv-cache", ignore_errors=True)  # Replaced as of 10.0
    shutil.rmtree("/srv/zulip-npm-cache", ignore_errors=True)  # Replaced as of 7.0
    clean_emoji_cache.main(args)


if __name__ == "__main__":
    args = parse_cache_script_args("This script cleans unused Doer caches.")
    main(args)

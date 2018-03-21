#!/usr/bin/env python

import logging
import re
import sys
import time
import urllib2

version_re = re.compile(r"version: (\d+)")


def get_version(url):
    resp = urllib2.urlopen(url)
    body = resp.read()
    resp.close()
    m = version_re.match(body.strip())
    if m:
        return int(m.group(1))
    return -1


def detect_version_change(url, run_seconds=300):
    end_time = time.time() + run_seconds
    cur_version = get_version(url)
    logging.info("will run for %d seconds" % run_seconds)
    logging.info("start version: %s" % cur_version)
    start_time = time.time()
    flapping_start_time = None
    req_count = 0
    while time.time() < end_time:
        time.sleep(.05)
        new_version = get_version(url)
        req_count += 1
        if new_version > cur_version:
            elapsed = time.time() - start_time
            if not flapping_start_time:
                logging.info("new version: %d   seconds: %.1f" % (new_version, elapsed))
        elif new_version < cur_version:
            if not flapping_start_time:
                logging.info("flapping back to version: %d" % new_version)
            flapping_start_time = time.time()
        else:
            if flapping_start_time and time.time()-flapping_start_time > 5:
                logging.info("flapping done - fully deployed version: %d" % new_version)
                flapping_start_time = None
        cur_version = new_version
    logging.info("finished - total requests: %d" % req_count)


def main(url):
    logging.basicConfig(format='%(asctime)s %(levelname)-8s %(message)s',
                        level=logging.INFO,
                        datefmt='%Y-%m-%d %H:%M:%S')
    detect_version_change(url)


if __name__ == "__main__":
    main(sys.argv[1])

#!/usr/bin/python3.8
import argparse

from os import environ
from sclib import SoundcloudAPI, Track, Playlist

api = SoundcloudAPI()

parser = argparse.ArgumentParser(
    prog="sc-download", 
    description="Download track from soundcloud.", add_help=True
)

parser.add_argument("link", help="Soundcloud target link", type=str)

parser.add_argument(
    "-t", "--target", dest="target", nargs="?", 
    default=f"/home/{environ['USER']}/download/",
    help="Target download path",
)


def download(link: str, target: str):
    track = api.resolve(link)
    filename = f"{target}{track.artist} - {track.title}.mp3"
    with open(filename, "wb+") as fp:
        track.write_mp3_to(fp)


if __name__ == "__main__":
    args = parser.parse_args()
    download(args.link, args.target)
    print("Done")

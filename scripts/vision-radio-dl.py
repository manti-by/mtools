#!/usr/bin/python3
import argparse
import logging
import os
import requests

from datetime import datetime
from xml.etree import ElementTree

RSS_LINK = "https://feeds.castos.com/9n6dg"

logging.basicConfig(level=logging.INFO, format="%(levelname)s %(asctime)s %(message)s")
logger = logging.getLogger(__name__)

parser = argparse.ArgumentParser(
    prog="vision-radio-dl", 
    description="Download tracks from VISION radio.", add_help=True
)

parser.add_argument(
    "-t", "--target", nargs="?", default=os.getcwd(),
    help="Target download path (default to current directory)",
)
parser.add_argument(
    "-l", "--limit", nargs="?", type=int, default=5,
    help="Podcasts count to download",
)
parser.add_argument(
    "-o", "--overwrite", type=bool, default=False,
    help="Overwrite existing files",
)


def prepare_data() -> list[dict]:
    response = requests.get(RSS_LINK)
    xml = ElementTree.fromstring(response.content)
    return [
        {
            "link": item.find("./enclosure").attrib["url"],
            "filename": item.find("./link").text.split("/")[-1],
            "pub_date": datetime.strptime(item.find("./pubDate").text, "%a, %d %b %Y %H:%M:%S %z"),
        }
        for item in xml.findall("./channel/item")
    ]


def download(target: str, limit: int, overwrite: bool = False):
    podcasts = prepare_data()
    for podcast in sorted(podcasts, key=lambda x: x["pub_date"], reverse=True)[:limit]:
        target_file_name = f"{target}/{podcast['filename']}.mp3"
        if os.path.exists(target_file_name) and not overwrite:
            logger.warning(f"Podcast {podcast['filename']} already exists")
            continue

        response = requests.get(podcast["link"])
        if not response.ok:
            logger.error(f"Failed to download a file {podcast['filename']} - {response.reason}")
            continue

        with open(f"{target}/{podcast['filename']}.mp3", "wb") as f:
            f.write(response.content)
            logger.info(f"Podcast {podcast['filename']} successfully downloaded")


if __name__ == "__main__":
    args = parser.parse_args()
    download(args.target, args.limit, args.overwrite)

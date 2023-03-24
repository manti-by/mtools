#!/usr/bin/python3
import argparse
import logging
import os
import requests

from datetime import datetime
from xml.etree import ElementTree

RSS_LINK = "https://feeds.castos.com/9n6dg"

logging.basicConfig(level=logging.INFO)
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


def prepare_data() -> list[dict]:
    response = requests.get(RSS_LINK)
    xml = ElementTree.fromstring(response.content)
    return [
        {
            "link": item.find("./enclosure").attrib["url"],
            "filename": item.find("./enclosure").attrib["url"].split("/")[-1],
            "pub_date": datetime.strptime(item.find("./pubDate").text, "%a, %d %b %Y %H:%M:%S %z"),
        }
        for item in xml.findall("./channel/item")
    ]


def download(target: str, limit: int):
    podcasts = prepare_data()
    for podcast in sorted(podcasts, key=lambda x: x["pub_date"], reverse=True)[:limit]:
        response = requests.get(podcast["link"])
        if not response.ok:
            logger.error(f"Failed to download a file {podcast['filename']} - {response.reason}")
            continue
        with open(f"{target}/{podcast['filename']}", "wb") as f:
            f.write(response.content)
            logger.info(f"Podcast {podcast['filename']} successfully downloaded")


if __name__ == "__main__":
    args = parser.parse_args()
    download(args.target, args.limit)

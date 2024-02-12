#!/usr/bin/python3
from datetime import datetime

import logging
import pytz

from elasticsearch import Elasticsearch
from pySMART import Device

ES_INDEX = "smartctl"
DEVICES = ("/dev/sdb", "/dev/sdc", "/dev/sdd")

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

client = Elasticsearch("http://localhost:9200")


def check_info(device_name: str, check_attributes: dict):
    result = client.search(index=ES_INDEX, body={"query": {"term": {"device": device_name}}})
    try:
        attributes = result["hits"]["hits"][0]["_source"]["attributes"]
    except (AttributeError, IndexError):
        logger.info(f"Error getting SMART data for {device_name}")
        return
    for key, value in attributes.items():
        if check_attributes.get(key) != value:
            logger.warning(f"Previous {key} value {value} is different to {check_attributes.get(key)}")


if __name__ == "__main__":
    logger.info(f"Read SMART data for {len(DEVICES)} devices")
    for device in DEVICES:
        dev = Device(device)
        document = {
            "device": device,
            "attributes": {
                attr.name: attr.value
                for attr in dev.attributes
                if attr is not None
            },
            "created_at": datetime.now(tz=pytz.UTC).isoformat()
        }
        document_id = f"{device}-{document['created_at']}"
        check_info(device, document["attributes"])
        client.index(index=ES_INDEX, id=document_id, document=document)
    logger.info("SMART data is saved to Elasticsearch")

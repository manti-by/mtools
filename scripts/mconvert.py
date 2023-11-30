#!/usr/bin/python3
import math
import os
import argparse
import logging
import subprocess

from concurrent import futures
from functools import reduce
from itertools import chain
from typing import Iterable
from pathlib import Path

BASE_DIR = Path(os.getcwd())

DEFAULT_VIDEO_TARGETS = ["flac", "mp3", "gif", "h264", "h264-cuda", "h265"]

FORMAT_MAP = {
    "avif": ["jpg"],
    "png": ["jpg"],
    "webp": ["jpg"],
    "jpg": ["webp"],
    "flac": ["mp3", "ogg"],
    "3gp": DEFAULT_VIDEO_TARGETS,
    "avi": DEFAULT_VIDEO_TARGETS,
    "m4a": DEFAULT_VIDEO_TARGETS,
    "mp4": DEFAULT_VIDEO_TARGETS,
    "mpg": DEFAULT_VIDEO_TARGETS,
    "mkv": DEFAULT_VIDEO_TARGETS,
    "wma": DEFAULT_VIDEO_TARGETS,
    "mts": DEFAULT_VIDEO_TARGETS,
    "mov": DEFAULT_VIDEO_TARGETS,
}

SOURCE_FORMAT_CHOICES = list(FORMAT_MAP.keys())
TARGET_FORMAT_CHOICES = list(set(reduce(lambda x, y: x + y, FORMAT_MAP.values())))

SCALE_720P = "scale='min(1280,iw)':'min(720,ih)'"

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

parser = argparse.ArgumentParser(
    prog="mconvert", description="Convert media file format.", add_help=True
)

parser.add_argument("source_format", help="Source format", type=str, choices=SOURCE_FORMAT_CHOICES)
parser.add_argument("target_format", help="Target format", type=str, choices=TARGET_FORMAT_CHOICES)

parser.add_argument(
    "-b:v", "--bitrate_video", dest="bitrate_video", default="3500k", help="Target video bitrate"
)
parser.add_argument(
    "-b:a", "--bitrate_audio", dest="bitrate_audio", default="128k", help="Target audio bitrate"
)
parser.add_argument(
    "-c", "--enable_cuda", dest="enable_cuda", type=bool, default=False, help="Enable CUDA support"
)


def get_file_list(extension: str) -> Iterable:
    return chain(BASE_DIR.glob(f"*.{extension.upper()}"), BASE_DIR.glob(f"*.{extension.lower()}"))


def run_commands(command_list: list):
    for command in command_list:
        logger.info(f"Call command {' '.join(map(str, command))}")
        subprocess.run(command)


if __name__ == "__main__":
    commands = []
    args = parser.parse_args()
    os.makedirs(BASE_DIR / args.target_format, exist_ok=True)
    for original_name in get_file_list(args.source_format):
        ext = "mkv" if args.target_format in ("h264", "h264-cuda", "h265") else args.target_format
        target_name = original_name.parent / args.target_format / f"{original_name.stem}.{ext}"
        if args.target_format == "h264":
            if not args.enable_cuda:
                commands.append([
                    "ffmpeg", "-y", "-i", original_name,
                    "-vf", SCALE_720P,
                    "-c:v", "libx264", "-b:v", args.bitrate_video,
                    "-profile:v", "high", "-preset", "slow", "-crf", "22"
                    "-c:a", "libfdk_aac", "-b:a", args.bitrate_audio, "-cutoff", "18000", target_name
                ])
            else:
                commands.append([
                    "ffmpeg", "-y", "-vsync", "0", "-hwaccel", "cuda", "-i", original_name,
                    "-vf", SCALE_720P,
                    "-c:v", "h264_nvenc", "-pix_fmt", "yuv420p", "-b:v", args.bitrate_video,
                    "-profile:v", "high", "-preset", "slow", "-crf", "22",
                    "-c:a", "libfdk_aac", "-b:a", args.bitrate_audio, "-cutoff", "18000", target_name
                ])
        elif args.target_format == "h265":
            commands.append([
                "ffmpeg", "-y", "-i", original_name,
                "-vf", SCALE_720P,
                "-c:v", "libx265", "-b:v", args.bitrate_video, "-level", "4.1",
                "-profile:v", "high", "-preset", "slow", "-crf", "22",
                "-c:a", "libfdk_aac", "-b:a", args.bitrate_audio, "-cutoff", "18000", target_name
            ])
        elif args.target_format == "flac":
            commands.append([
                "ffmpeg", "-y", "-i", original_name, "-f", "flac", "-r:a", "48000", target_name
            ])
        elif args.target_format == "mp3":
            commands.append([
                "ffmpeg", "-y", "-i", original_name, "-b:a", args.bitrate_audio, "-r:a", "44100", target_name
            ])
        elif args.target_format == "gif":
            commands.append([
                "ffmpeg", "-y", "-i", original_name, "-gifflags", "+transdiff", target_name
            ])
        else:
            commands.append([
                "ffmpeg", "-y", "-i", original_name, target_name
            ])

    num_processes = math.floor(os.cpu_count() * 0.75)
    chunk_size = len(commands) // num_processes + 1
    command_chunks = [commands[i: i + chunk_size] for i in range(len(commands))[::chunk_size]]
    with futures.ProcessPoolExecutor(max_workers=num_processes - 1) as executor:
        processes = []
        for i in range(len(command_chunks)):
            processes.append(
                executor.submit(run_commands, command_chunks[i])
            )

    for _ in futures.as_completed(processes):
        """Wait while all processes will be completed"""
    logger.info("All processes are completed")

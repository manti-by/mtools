#!/usr/bin/python3
import os
import argparse
import dropbox


CHUNK_SIZE = 4 * 1024 * 1024
AUTH_TOKEN = os.environ('AUTH_TOKEN')


parser = argparse.ArgumentParser(
    prog='python3 dropbox.py',
    description='Dropbox file management app.',
    add_help=True
)

parser.add_argument('-u', '--upload',
                    dest='upload', nargs='?',
                    help='Upload file to dropbox')


if __name__ == '__main__':
    if args.upload:
        file_path = args.upload
        dest_path = '/Apps/m2server/{}'.format(os.path.basename(file_path))

        print('Uploading file {}'.format(file_path))
        f = open(file_path, 'rb')
        file_size = os.path.getsize(file_path)

        dbx = dropbox.Dropbox(AUTH_TOKEN)
        if file_size <= CHUNK_SIZE:
            dbx.files_upload(f, dest_path)
        else:
            session = dbx.files_upload_session_start(f.read(CHUNK_SIZE))
            cursor = dropbox.files.UploadSessionCursor(session_id=session.session_id,
                                                       offset=f.tell())
            commit = dropbox.files.CommitInfo(path=dest_path)
            while f.tell() < file_size:
                if ((file_size - f.tell()) <= CHUNK_SIZE):
                    dbx.files_upload_session_finish(f.read(CHUNK_SIZE), 
                                                    cursor, commit)
                else:
                    dbx.files_upload_session_append(f.read(CHUNK_SIZE), 
                                                    cursor.session_id, cursor.offset)
                    cursor.offset = f.tell()
                print('.', end='')
        print('Done')
    else:
        parser.print_help()


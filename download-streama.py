#!/usr/bin/env python
import requests
import json

json_url = 'https://api.github.com/repos/streamaserver/streama/releases'

def get_download_link (url):
    raw = requests.get(url).content
    releases = json.loads(raw)

    for release in releases:
        if release['prerelease'] == False:
            url = release['assets'][0]['browser_download_url']
            name = url.split('/')[-1]
            return url, name


def download_file (url, name):
    r = requests.get(url, stream=True)
    if r.status_code == 200:
        with open(name, 'wb') as f:
            for chunk in r:
                f.write(chunk)


if __name__ == "__main__":
    url, name = get_download_link(json_url)
    download_file(url, name)

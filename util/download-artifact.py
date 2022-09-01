import argparse
from github import Github
import requests
from pathlib import Path   
import os
import sys

organization='OA-WCVP'

def main():
    # Read repo, version tag, and artifact name from command line
    parser = argparse.ArgumentParser()
    parser.add_argument("repo", type=str)
    args = parser.parse_args()

    # Create a Github instance, using an access token:
    access_token = os.getenv('GITHUB_TOKEN')
    if access_token is None:
        print('Environment variable {} containing a valid GitHub personal access token is required'.format('GITHUB_TOKEN'))
        sys.exit(-1)
    g = Github(access_token)
    repo = g.get_repo('{org}/{repo}'.format(org=organization,repo=args.repo))
    release = repo.get_latest_release()
    for asset in release.get_assets():
        # Initiate a session
        headers = {'Authorization': 'token ' + access_token,
            'Accept': 'application/octet-stream'}
        session = requests.Session()
        response = session.get(asset.url, stream = True, headers=headers)
        dest = Path() / "downloads" / asset.name
        with open(dest, 'wb') as f:
            for chunk in response.iter_content(1024*1024): 
                f.write(chunk)

if __name__ == '__main__':
    main()

    
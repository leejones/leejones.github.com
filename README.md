# leejones.github.com — Blog workflow

This is my humble website powered by Jekyll and hosted on GitHub Pages.

## Add a new post

1. Create a Markdown file in the `_posts/` directory.
2. Name the file using this pattern:
   ```
   YYYY-MM-DD-your-post-title.md
   ```
   - Use lowercase and hyphens for the title portion.
3. Add YAML front matter at the top of the file. Minimal example:
   ```
   ---
   title: "My Post Title"
   date: 2026-02-15 10:00:00 -0600
   layout: post
   excerpt: "One-sentence summary for listings." # optional
   ---
   ```
4. Write your post in Markdown below the front matter.
5. Commit and push the file to the repository. GitHub Pages will rebuild the site and publish the post.

Notes:
- Images: put images in `images/` (or `assets/images/`) and reference them with `{{ '/images/your.png' | relative_url }}` or a relative path.
- Excerpts: Jekyll auto-generates excerpts from the start of the post. Provide an explicit `excerpt` in front matter to override.
- Tags: Tags are not currently supported.  Jekyll supports tags but GitHub Pages does not.  Specifically, the jekyll-archives plugin generates pages for each tag with a list of posts at build time, but GitHub pages doesn't support this plugin.  One way to support tags would be a build time script that generates the pages with jekyll-archives or something else.

## Preview locally

Prerequisites:
- Docker installed (and optionally Docker Compose).

Quick start (build & run a container):

1. Build the image (run from the repo root):
   ```
   docker build -t leejones-jekyll .
   ```
2. Run the image, mounting the repo so changes are visible to the server:
   ```
   docker run --rm -it -p 4000:4000 -v "$(pwd)":/srv/jekyll -w /srv/jekyll leejones-jekyll
   ```
3. Open your browser at:
   ```
   http://127.0.0.1:4000
   ```

Using Docker Compose (easier):

1. Build and start:
   ```
   docker-compose up --build
   ```
2. The site will be available at `http://127.0.0.1:4000`. Stop with `docker-compose down`.

Notes for Docker users:
- The Docker image/compose mounts your working directory into the container, so edits on the host will trigger Jekyll rebuilds inside the container.
- If you see file permission issues when writing generated files from the container, run compose with your UID/GID:
  ```
  UID=$(id -u) GID=$(id -g) docker-compose up --build
  ```
  (The provided `docker-compose.yml` supports passing `UID`/`GID` via environment.)
- To include drafts when using Docker, append `--drafts` to the serve command:
  - Direct run: `docker run ... leejones-jekyll bundle exec jekyll serve --drafts --host 0.0.0.0`
  - Compose: `docker-compose run jekyll bundle exec jekyll serve --drafts --host 0.0.0.0`

## Conventions & tips

- Post permalinks follow the pattern set in `_config.yml`. Adjust there if you want a different URL structure.
- Keep front matter dates accurate; Jekyll orders posts by `date`.
- For compatibility with GitHub Pages, prefer plugins supported by Pages (the `Gemfile` uses the `github-pages` gem).

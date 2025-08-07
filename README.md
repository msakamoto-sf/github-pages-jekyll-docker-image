# github-pages-jekyll-docker-image
custom jekyll docker image for github-pages

1. build docker image
    ```
    $ docker build -t github-pages-jekyll .
    ```
2. run docker container, get version
    ```
    $ docker run --rm -it github-pages-jekyll ruby -v
    ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-linux-gnu]

    $ docker run --rm -it github-pages-jekyll gem -v
    3.3.15

    $ docker run --rm -it github-pages-jekyll bundler -v
    Bundler version 2.6.9

    $ docker run --rm -it github-pages-jekyll jekyll -v
    jekyll 3.10.0
    ```
3. initialize jekyll directory structure to `./dest/`
    ```
    $ docker run --rm -it -u `id -u`:`id -g` -v $PWD:/src -w /src github-pages-jekyll jekyll new --skip-bundle /src/dest
    ```
4. rewrite `./dest/Gemfile` dependencies
   1. comment out line starting `gem "jekyll"`
   2. edit line starting `# gem "github-pages"` to (check latest from [here](https://pages.github.com/versions/) and [there](https://rubygems.org/gems/github-pages)):
        ```
        gem "github-pages", "~> GITHUB-PAGES-VERSION", group: :jekyll_plugins
        ```
5. set bundle install path to `./dest/vendor/bundle`
    ```
    $ docker run --rm -it -u `id -u`:`id -g` -v $PWD:/src -w /src/dest github-pages-jekyll bundle config set path 'vendor/bundle'
    $ docker run --rm -it -u `id -u`:`id -g` -v $PWD:/src -w /src/dest github-pages-jekyll bundle binstubs --path=vendor/bin
    ```
    - `./dest/.bundle/config` will be generated with `BUNDLE_PATH`
    - refs: [bundlerで非推奨になった --path --binstubs #Rails - Qiita](https://qiita.com/devzooiiooz/items/8babd82f780f01812f9d)
6. bundle install to `./dest/vendor/bundle`
    ```
    $ docker run --rm -it -u `id -u`:`id -g` -v $PWD:/src -w /src/dest github-pages-jekyll bundle install
    ```
7. customize `./dest/_config.yml`
8. build -> generated to `./dest/_site/` (default output directory)
    ```
    $ docker run --rm -it -u `id -u`:`id -g` -v $PWD:/src -w /src/dest github-pages-jekyll bundle exec jekyll build
    ```

extra: [clean build cache](https://docs.docker.com/reference/cli/docker/builder/prune/)

```
$ docker builder prune
```

reference:

- https://jekyllrb.com/
- https://hub.docker.com/_/debian/tags
- [Jekyll を使用して GitHub Pages サイトを作成する - GitHub Docs](https://docs.github.com/ja/pages/setting-up-a-github-pages-site-with-jekyll/creating-a-github-pages-site-with-jekyll)
- [Jekyll を使用して GitHub Pages サイトをローカルでテストする - GitHub Docs](https://docs.github.com/ja/pages/setting-up-a-github-pages-site-with-jekyll/testing-your-github-pages-site-locally-with-jekyll)
- https://pages.github.com/versions/
- https://rubygems.org/gems/github-pages

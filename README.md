# BYD Wiki

This resource provides reference materials and research from enthusiasts of the BYD Apps & OTA Telegram channel, primarily for BYD electric vehicles and hybrids produced for the Chinese market

Read: https://byd-wiki.github.io


## Local Development

Based on [Hextra](https://imfing.github.io/hextra/) template for [Hugo](https://gohugo.io): https://github.com/imfing/hextra

Pre-requisites: [Hugo](https://gohugo.io/getting-started/installing/), [Go](https://golang.org/doc/install) and [Git](https://git-scm.com)

```shell
# Clone the repo
git clone https://github.com/imfing/hextra-starter-template.git

# Change directory
cd hextra-starter-template

# Start the server
hugo mod tidy
hugo server --logLevel debug --disableFastRender -p 1313
```

### Update theme

```shell
hugo mod get -u
hugo mod tidy
```

See [Update modules](https://gohugo.io/hugo-modules/use-modules/#update-modules) for more details.

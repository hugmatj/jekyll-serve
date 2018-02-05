#!/bin/bash
set -e

#cd /site


if [ "$JEKYLL_NEW" = true ]; then
  echo "NOTE: making new jekyll site!"
  jekyll new .
fi

COMMAND="bundle exec jekyll serve --force_polling  -H 0.0.0.0  -P 4000 --watch"
DRAFTS=" --drafts"
INCREMENTAL=" --incremental"

if [ "$DRAFTS" = true ] || [ "$INCREMENTAL" = true ]; then
  if [ "$DRAFTS" = true ] && [ "$INCREMENTAL" = true ]; then
    bundle install
    ${COMMAND}${DRAFTS}${INCREMENTAL}
  fi
  elif [ "$DRAFTS" = true ] && [ -v "$INCREMENTAL" == false ]; then
    bundle install
    ${COMMAND}${DRAFTS}
  elif [ "$INCREMENTAL" = true ] && [ -v "$DRAFTS" == false ]; then
    bundle install
    ${COMMAND}${INCREMENTAL}
fi

if [ ! -f Gemfile ]; then
  echo "NOTE: hmm, I don't see a Gemfile so I don't think there's a jekyll site here"
  echo "Either you didn't mount a volume, or you mounted it incorrectly."
  echo "be sure you're in your jekyll site root and use something like this to launch"
  echo ""
  echo "docker run -p 80:4000 -v \$(pwd):/site bretfisher/jekyll-serve"
  echo ""
  echo "NOTE: To create a new site, add '-e JEKYLL_NEW=true' to the above command"
  exit 1
fi

bundle install

exec "$@"

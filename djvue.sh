#!/bin/bash

# Create root directory for the project.
echo "Creating Django+Vue.js project '$1'..."
mkdir $1
cd $1
git init --initial-branch=main

# Configure gitignore
py_gitignore_src="https://raw.githubusercontent.com/github/gitignore/main/Python.gitignore"
nodejs_gitignore_src="https://raw.githubusercontent.com/github/gitignore/main/Node.gitignore"
py_gitignore=$(curl -s $py_gitignore_src)
nodejs_gitignore=$(curl -s $nodejs_gitignore_src)
touch .gitignore

echo "# Other's:" >> .gitignore
echo ".helix" >> .gitignore
echo ".vscode" >> .gitignore
echo '' >> .gitignore

echo "# Python's:" >> .gitignore
echo -e "$py_gitignore" >> .gitignore
echo '' >> .gitignore

echo "# JavaScript's:" >> .gitignore
echo -e "$nodejs_gitignore" >> .gitignore

echo "#$1" > README.md

# Configure CHANGELOG
cat > CHANGELOG.md << EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - $(date +'%Y-%m-%d')

### Added

- Initial scaffolded files and directories.
EOF

touch Dockerfile
mkdir .helix
touch .helix/languages.toml

# Scaffold backend with Django.
mkdir backend
cd backend
echo "# $1 Backend" > README.md
python3 -m venv .venv
source .venv/bin/activate
python3 -m pip install poetry
poetry init --name="$1-backend" --no-interaction
poetry add --group=dev python-lsp-server
poetry add Django
django-admin startproject backend
cd ..
echo "Backend scaffolding successfully made."

# Scaffold frontend with Vue.
npm init vue@latest frontend
cd frontend
npm install
echo "# $1 Frontend" > README.md
echo "Installing CSS utilities...\n"
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
cd src
index_css="index.css"
echo "Writing TailwindCSS directives to $index_css..."
echo "@tailwind base;" >> $index_css
echo "@tailwind components;" >> $index_css
echo "@tailwind utilities;" >> $index_css
echo "Importing $index_css into main.js..."
sed -i '1s/^/import ".\/index.css";\n/' ./main.js
cd ../..
echo "Frontend scaffolding successfully made."

echo "All done."


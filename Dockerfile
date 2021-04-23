FROM python:3.8-buster

# Documentation static site generator & deployment tool
RUN pip install mkdocs>=1.1.2

# Add custom theme if not inside a theme_dir
# (https://github.com/mkdocs/mkdocs/wiki/MkDocs-Themes)
RUN pip install mkdocs-material>=5.4.0

COPY doc.zih.tu-dresden.de/ /src/

WORKDIR /src/doc.zih.tu-dresden.de
RUN mkdocs build

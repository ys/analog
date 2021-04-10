# 🎞 Analog

[![build](https://github.com/ys/analog/actions/workflows/ci.yml/badge.svg)](https://github.com/ys/analog/actions/workflows/ci.yml)

This project is a set of utilities helping me getting organized with scans.

Part of it might look like a rebuilt of a catalog. 
Goal is to not have to rely on lightroom all the time. 

## Current Commands

```
$ analog
Commands:
  analog catalog:build                                 # Build symlinks to rolls per camera and per film
  analog exif:read [ROLL_NUMBER]                       # Read Exif from Roll
  analog exif:write [ROLL_NUMBER]                      # Write Exif from Roll
  analog offline:build [ROLL_NUMBER]                   # Create an offline HTML contact sheet per folder
  analog photos:rename [ROLL_NUMBER]                   # Rename roll pictures based on information
  analog rolls:details [ROLL_NUMBER]                   # See Roll details
  analog rolls:overview [YEAR]                         # See all
  analog rolls:rename [ROLL_NUMBER]                    # Rename roll based on information
  analog rolls:stats [YEAR]                            # See some stats
```

All the commands taking a `[ROLL_NUMBER]` also accept `--all` to be run on every roll

## Config

Create a `~/.analog` file with 

```
path: /path/to/scans 
```

Where `/path/to/scans` has the `cameras.yml` and `films.yml` and  a yearly structure

## Folders Structures

```
Photos/
Photos/raws/2021/20210101-... # This one goes developed in Lightroom or is already developed. 
Photos/scans/2021/20210101-...
Photos/scans/2021/20210101-.../index.md
🔗 Cameras/Leica M6/2021/20210101-.../
🔗 Films/Kodak - Portra 400/2021/20210101-...
```

## Frontmatter index files

```
---
camera: leica-m6
film: portra-400
format: 135
scanned_at: 2020-11-30
exported: true
lab: mori-film
roll_number: 20x17
themes:
- cars
- beach
- surf
- personal
---
# My summer vacation
Roll story
```


- Frontmatter format is YAML.
- Mandatory keys: 
	- camera
	- film
- Allowed keys:
	- lenses/lens if only one
	- themes
	- iso

Folder structure is built based on the information we have in the files here. 
Camera and Film might become slugs from 2 files

- [cameras.yml](config/cameras.yml)
- [films.yml](config/films.yml)

those would be lists of cameras slugs and information

If we are not using negativelabpro, we might also push exif information to the files in the format


## Inpsiration

- Frontmatter and index.md files come from my use of Hugo/Jekyll. 
- Exif data comes from me wanting something organized without touching anything

## Ideas
- Tag folders with https://brettterpstra.com/2017/08/22/tagging-files-from-the-command-line/

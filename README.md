# 🎞 Analog

This project is a set of utilities helping me getting organized with scans.

Part of it might look like a rebuilt of a catalog. Goal is to not have to rely on lightroom all the time. 

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
lens: summilux-35
film: portra-400
rollnumber: 78 # Number in the negatives folder (real life)
boxspeed: 400
shotspeeds: [100, 200, 400]
subjects:
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
	- subjects
	- boxspeed (might go into film definition files)
	- shotspeeds

Folder structure is built based on the information we have in the files here. 
Camera and Film might become slugs from 2 files

- cameras.yaml
- films.yaml

those would be lists of cameras slugs and information

If we are not using negativelabpro, we might also push exif information to the files in the format

### cameras.yaml

```
leica-m6:
  name: Leica M6
  lenses:
  - name: Summilux 35mm...
    slug: summilux-35
olympus-xa:
  name: Olympus XA
  lens: 35mm 2.8 # Fixed lense
```

### films.yaml

```
portra-400:
  name: Portra 400
  producer: Kodak
```

## Generated - Per roll
- Contact sheet PDF or jpeg, maybe with roll information and the "story"

## Inpsiration
- Frontmatter and index.md files come from my use of Hugo. 
- Exif data comes from me wanting something organized without touching anything

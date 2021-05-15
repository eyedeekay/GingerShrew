# ~~GingerShrew~~ To-Be-Renamed Unbranded Browser Framework

GingerShrew is a de-branded Firefox-ESR variant which uses IceCat as a base.
While it is in fact a complete Firefox-like browser, it is not intended to be
used in such a way, instead it is intended to be used similarly to Electron
in that it can be embedded in an application as a way of creating
HTML+Javascript desktop UI's on top of a complete Firefox browser,
specifically configured to avoid telemetry and meet other basic privacy needs
in advance.

This project has a limited remaining lifespan. It's being replaced by:
[unbrander](https://github.com/eyedeekay/unbrander) which is a Go library
and a collection of presets for unbranding software in a flexible way, which
can be imported directly into a file used by `go generate`.

## Why the name ~~GingerShrew~~?

 1. ~~It's intended for use in a system we're calling Rhizome, but it is not~~
 ~~dependent on the presence of the rest of Rhizome's tooling, so it goes in~~
 ~~a different repository, with a different name.~~
 2. ~~Ginger is a spicy(hence the relationship to "Fire") tasting rhizome, and a~~
 ~~shrew is a burrowing(I2P builds tunnels) rodent that does not get enough~~
 ~~credit.~~
 3. ~~It's intended to be used in *other people's projects* under their own~~
 ~~names. So I picked a memorable name I didn't think anyone else would ever~~
 ~~want.~~
 4. ~~Apparently, moz.build file lists need to be alphabetical, and GingerShrew~~
 ~~is pretty close to IceCat alphabetically. Close enough that editing moz.build~~
 ~~files can be done pretty much automatically.~~

All that said, it's pretty much 100% identical to IceCat, except for
rebranding, at this time. In the future more patches may be added as they
become desirable.

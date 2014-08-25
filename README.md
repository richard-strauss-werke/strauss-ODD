strauss-ODD
===========

ODD and ODD-related files for TEI / MEI encoding at the Kritische Ausgabe der Werke von Richard Strauss

The schemata generated from these ODDs target a partially form-based editing of TEI code in oXygen's Author Mode. 
In order to make documents created on this basis fully TEI conformant, they have be transformed 
by the accompagnying XSLT scripts (which are generated from the ODDs as well). 
 
Folders
-----

- `build` - the target folder for schemata, expanded ODDs, XSLT stylesheets.

- `dependencies` - contains MEI files included when building the schemata

- `src` - ODD source folder 

- `xslt` - the xslt directory contains scripts to generate transformation sheets from production TEI files to publishable versions 

Build instructions
------------------

The root folder contains an ANT build script (`build.xml`) with multiple build targets. In order to build schemata, 
transformation sheets, etc. with this script, make sure to have 

- ANT, 
- Saxon, and
- the TEI-C stylesheets (available on GitHub)

installed. Make a copy of the file `build.default.properties`, name it `build.properties` 
and adjust the setting in that file to your system. You can find the available build targets in the `build.xml`. 
In order to build an Relax-NG schema based on the correspondence ODD, open a command line window in the root folder of
this repository and type (Windows):

```
REM (set lib according to your system)
set lib="C:\Program Files\Oxygen XML Editor 16\lib"
ant -lib %lib%/resolver.jar -lib %lib%/saxon9ee.jar rng -Dname=correspondence
```


Acknowledgements
----------------

The ODDs include and build on specifications by the TEI consortium, Raffaele Viglianti (https://github.com/TEI-Music-SIG/tei-mei/), and 
Peter Stadler / Anna Maria Komprecht (https://github.com/Edirom/WeGA-ODD).

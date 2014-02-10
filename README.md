strauss-ODD
===========

ODD and ODD-related files for TEI / MEI encoding at the Kritische Ausgabe der Werke von Richard Strauss

The schemata generated with this ODD target a form-based editing of TEI code in oXygen's Author Mode. In order to make these documents fully TEI conformant, they have to be transformed by an XSLT script. 
 
Files
-----

The ODD file (see below for build instructions with ant):

- `src/rswa.MAIN.odd.xml`

Low-level edits of various TEI components:

- `src/rswa.edits.classes.att.xml`
- `src/rswa.edits.datatypes.xml`
- `src/rswa.edits.elements.xml`
- `src/rswa.edits.macros.xml`

TEI extensions:

- `src/rswa.extension.tasks.xml`
- `src/rswa.extension.MEI.xml`
- `src/rswa.extension.xinclude.xml`

A copy of [Raffaele Viglianti's modified version of the MEI ODD](https://github.com/TEI-Music-SIG/tei-mei/):

- `src/mei-source.xml`


Build instructions
------------------

Required to follow these instructions: 
- 1. ANT, 
- 2. an installation of the oXygen XML editor, which contains the TEI build scripts and the necessary JAR files (if you don't use oXygen, you can get the JARs and the TEI stylesheets separately).

Note: To ensure that the TEI script `odd2odd.xsl` can find the file `src/mei-source.xml`, either replace the source attributes in the file src/rswa.extension.MEI.xml by absolute paths, or, alternatively, copy `mei-source.xml` to `odd2odd.xsl`'s folder (for example, `C:/Program Files/Oxygen XML Editor 15/frameworks/tei/xml/tei/stylesheet/odds`; don't delete the copy in your odd folder.

```
ant -f %buildfile% 
-lib %lib%/resolver.jar 
-lib %lib%/saxon9ee.jar 
-Dverbose=true 
-DdefaultSource=%defaultSource% 
-DinputFile=%inputFile% 
-Dlang=%lang% 
-DoutputFile=%outputFile% 
-DselectedSchema=%selectedSchema%
```

Example values:
- %buildfile% - `"C:\Program Files\Oxygen XML Editor 15\frameworks\tei\xml\tei\stylesheet\relaxng\build-to.xml"`
- %lib% -  "C:\Program Files\Oxygen XML Editor 15\lib"`
- %defaultSource% - `"\Program Files\Oxygen XML Editor 15\frameworks\tei\xml\tei\odd\p5subset.xml"`
- %inputFile% - `"C:\test\rswa.MAIN.odd.xml"`
- %lang% - `de`
- %outputFile% - `"C:\test\persons.rng"`
- %selectedSchema% - `schema.persons` (for a list of possible schemata, see the file `rswa.MAIN.odd.xml`.

It should also be possible to build a schema by applying a transformation scenario to the ODD in oXygen. In this case, add selectedSchema to the transformation settings.


Credits
-------

Based on the TEI P5 specifications at http://www.tei-c.org/release/xml/tei/odd/p5subset.xml, this ODD integrates Raffaele Viglianti's prefixed version of the MEI's "mei-source.xml" [tei-mei](https://github.com/TEI-Music-SIG/tei-mei/), the TEI-C's [XInclude ODD](http://www.tei-c.org/release/xml/tei/custom/odd/tei_xinclude.odd), and draws on specifications in Peter Stadler's [Carl-Maria-von-Weber-Gesamtausgabe ODDs](https://github.com/Edirom/WeGA-ODD).
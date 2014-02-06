strauss-ODD
===========

ODD and ODD-related files for TEI / MEI encoding at the Kritische Ausgabe der Werke von Richard Strauss

The schemata generated with this ODD target a form-based editing of TEI code in oXygen's Author Mode. In order to make these documents fully TEI conformant, they have to be transformed by an XSLT script. 
 
Files
-----

`src/rswa.MAIN.odd.xml
the odd file. See below for build instructions with ant. 

`src/rswa.edits.classes.att.xml`
`src/rswa.edits.datatypes.xml`
`src/rswa.edits.elements.xml`
`src/rswa.edits.macros.xml`
these files contain low-level edits of various TEI components 

`src/rswa.extension.tasks.xml` 
`src/rswa.extension.MEI.xml`
`src/rswa.extension.xinclude.xml`
TEI extensions

`src/mei-source.xml`
this file is a copy of Raffaele Viglianti's modified version of the MEI ODD, see [https://github.com/TEI-Music-SIG/tei-mei/blob/master/mei-source.xml]

Build instructions
------------------

Prerequisites to follow these instructions (which are only one of several ways of generating a schema from the odd): 
1) ant 
2) an installation of the oXygen XML editor, which contains the TEI build scripts and the necessary jar files

`ant -f %buildfile% -lib %lib%/resolver.jar -lib %lib%/saxon9ee.jar -Dverbose=true -DdefaultSource=%defaultSource% -DinputFile=%inputFile% -Dlang=%lang% -DoutputFile=%outputFile% -DselectedSchema=%selectedSchema%`

Example parameter values:
%buildfile% - "C:\Program Files\Oxygen XML Editor 15\frameworks\tei\xml\tei\stylesheet\relaxng\build-to.xml"
%lib% - "C:\Program Files\Oxygen XML Editor 15\lib"
%defaultSource% - "\Program Files\Oxygen XML Editor 15\frameworks\tei\xml\tei\odd\p5subset.xml"
%inputFile% - "C:\test\rswa.MAIN.odd.xml"
%lang% - de
%outputFile% - "C:\test\persons.rng"
%selectedSchema% - schema.persons (for a list of possible schemata, see the file `rswa.MAIN.odd.xml`.

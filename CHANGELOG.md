## 3.3.1

* Support reading 'page_width' from analysis_options.yaml to control formatter page width.

## 3.3.0

* add 'root-package', Specify which package should be treated as the root project (by package name) for workspace

## 3.2.3

* add 'use-key-name', Whether to use keyName style (packages/{package}/...) for asset paths.

## 3.1.0

* ignore: eol_at_end_of_file for preview file

## 3.0.9

* ignore: dangling_library_doc_comments for preview file

## 3.0.8

* It will not clean 'assets tag' in yaml if there are not assets.

## 3.0.7

* add 'package-ignore', the regular to ignore some packages.

## 3.0.6

* add 'g-suffix', whether the generated file is end with .g

## 3.0.5

* add 'class-prefix', Whether use package name as prefix for the name of const Class

## 3.0.4

* Support image preview

## 3.0.3

* Add '--package' command

## 3.0.2

* Add ignore_for_file: constant_identifier_names for generated file

## 3.0.1

* Fix null safety error
  
## 3.0.0

* Null safety
  
## 2.3.0

* Add '--folder-array' command

## 2.2.0

* Add '--const-array' command
  
## 2.1.2

* Fix --no-watch not working
  
## 2.1.1

* Fix '# assets start' position

## 2.1.0

* Add '--const-ignore' command

## 2.0.9

* Take care of empty assets

## 2.0.8

* Format yaml

## 2.0.7

* Fix indent in yaml

## 2.0.6

* Delete consts file and clean yaml when assets are empty

## 2.0.5

* Add license into yaml
* Fix yaml error
* Sort assets

## 2.0.4

* Remove resolution image assets from yaml

## 2.0.3

* Fix generate resolution image assets's consts

## 2.0.2

* Fix generate file when assets is empty
* Fix error on windows

## 2.0.0

* Support watch
* Support generate consts

## 1.1.1

* Handle yaml has no assets node

## 1.0.0

* Initial version, created by Stagehand

# Jekyll Dictionaries Plugin

[![Continuous Integration](https://github.com/hinkoulabs/jekyll-dictionaries/actions/workflows/ruby.yml/badge.svg)](https://github.com/hinkoulabs/jekyll-dictionaries/actions/workflows/ruby.yml) [![Gem Version](https://badge.fury.io/rb/jekyll-dictionaries.svg)](https://badge.fury.io/rb/jekyll-dictionaries)


Welcome to the Jekyll Dictionaries Plugin project! This open-source project allows you to create and share JSON dictionaries that can be accessed via a public API for language learning in mobile applications.

## Table of Contents

- [Intro](#intro)
- [Installation](#installation)
- [Dictionaries Structure](#dictionaries-structure)
- [Dictionary Types](#dictionary-types)
    - [1. Single Translation Dictionary](#1-single-translation-dictionary)
    - [2. Multiple Translations Dictionary](#2-multiple-translations-dictionary)
- [Object Properties](#object-properties)
    - [1. Dictionary Object](#1-dictionary-object)
    - [2. Collection Object](#2-collection-object)
    - [3. Folder Object](#3-folder-object)
- [Dictionary Types Examples](#dictionary-types-examples)
    - [1. Single Translation Dictionary Example](#1-single-translation-dictionary-example)
    - [2. Multiple Translations Dictionary Example](#2-multiple-translations-dictionary-example)
- [Push New Version Commands](#push-new-version-commands)
- [License](#license)

## Intro

The plugin will automatically generate dictionary and dictionary api pages for all dictionaries located into folder `_data/dictionaries` of jekyll project.

## Installation

1. Add this line to your site's Gemfile:

```ruby
gem 'jekyll-dictionaries'
```

2. Include `dictionary/head.html` into default layout to add custom styles of the plugin (the plugin styles are added as inline css styles and it might be updated if it's needed):

```html
<head>
  ...
   {% include dictionaries/head.html %}
</head>
```

3. Include `dictionaries/list.html` into index page to show a list of available dictionaries:

```html
  {% include dictionaries/list.html %}
```

4. (OPTIONAL) Also it's possible to change layout and permalink of dictionary pages on site's `_config.yml`:

```yml
dictionaries:
  pages:
    dictionary:
      layout: dictionary
      permalink: dictionaries/:name
    dictionary_api:
      layout: dictionary_api
      permalink: api/dictionaries/:name.json
```

## Dictionaries Structure

The dictionaries in this project have a specific structure that consists of the following components:

### Root Directory

The root directory for dictionaries is `_data/dictionaries`. It contains JSON files that start with an underscore `_` as well as folders that have names similar to the files but without the underscore. These folders act as containers for dictionary collections and can be nested.

### Collection Files

1. **Any JSON File**: Any JSON file within a folder is detected as a collection file. A collection file is a JSON object that can be used to set translations.

2. **"_metadata.json" (Optional)**: This file can be added inside nested folders to set folder details for the API. If this file is missing, the folder name will be used as the container name for the dictionaries in the API response. For example, if there is a folder named "greetings," and a developer wants to use a specific name for the folder in the API, they can add the file "_metadata.json" into the folder with data `{"name": "Greetings"}`. As a result, the plugin will generate an API where the folder name will be "Greetings."

## Dictionary Types

This project supports two types of dictionaries:

### 1. Single Translation Dictionary

A "single translation" dictionary is used to generate a dictionary for a selected learning language, with translations available in any other languages. The JSON structure for a "single translation" dictionary and its collections is as follows:

**_data/dictionaries/_single_dictionary.json:**

```json
{
    "version": "1.0.0",
    "name": "Simple",
    "translationType": "single",
    "learning": "es"
}
```

In this example, the learning language is set on the dictionary data with the "learning" field (using ISO 639-1 language codes).

**_data/dictionaries/single_dictionary/greetings.json:**

```json
{
    "name": "Greetings",
    "type": "collection",
    "data": [
        {"learning":"¡Hola!", "primary":"Hello!"},
        {"learning":"¡Buenos días!", "primary":"Good morning!", "notes": {"learning": "por la mañana", "primary": "at morning"}}
    ]
}
```

The collection contains an array property "data" with word translations. In this case, the learning language is specified for each translation entry, while the "primary" field represents the translation in the target language. Additionally, you can include "notes" related to learning and translations.

### 2. Multiple Translations Dictionary

A "multiple translation" dictionary is used to generate a dictionary with multiple translations available simultaneously. The JSON structure for a "multiple translation" dictionary and its collections is as follows:

**_data/dictionaries/_multiple_dictionary.json:**

```json
{
    "version": "1.0.0",
    "name": "Simple",
    "translationType": "multiple",
    "learning": "es",
    "translations":  ["en", "ru"]
}

```

In this example, the learning language is set on the dictionary data with the "learning" field (using ISO 639-1 language codes). Multiple translation types are specified in the "translations" property (using ISO 639-1 language codes).

**_data/dictionaries/multiple_dictionary/greetings.json:**

```json
{
    "name": "Greetings",
    "type": "collection",
    "data": [
        {"learning":"¡Hola!", "en":"Hello!", "ru": "Привет!"},
        {"learning":"¡Buenos días!", "en":"Good morning!", "ru":"Доброе утро!",  "notes": {"learning": "por la mañana", "en": "at morning", "ru": "говорят по утрам"}}
    ]
}
```

The collection contains an array property "data" with word translations. Each translation entry includes the learning language and multiple translations specified in the "translations" property. Additionally, you can include "notes" related to learning and translations for each entry.

## Object Properties

### 1. Dictionary Object

The dictionary object is a JSON object with the following properties:

| Property         | Type     | Description                              |
|------------------|----------|------------------------------------------|
| `name`           | string   | The name of the dictionary. (Required)   |
| `translationType`| string   | The type of translation ("single" or "multiple"). (Required) |
| `learning`       | string   | The learning language code, related to ISO 639-1 language codes. (Required) [ISO 639-1 Language Codes](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) |
| `version`        | string   | The version of the dictionary. (Optional) |
| `translations`   | array    | An array of ISO 639-1 language codes (required if `translationType` is "multiple"). |

### 2. Collection Object

The collection object is a JSON object with the following properties based on the `translationType` of the dictionary:

#### If `translationType` is "single":

| Property    | Type     | Description                              |
|-------------|----------|------------------------------------------|
| `type`      | string   | The type of the collection ("folder"). (Required) |
| `learning`  | string   | The learning word or phrase. (Required)  |
| `primary`   | string   | The primary translation. (Required)      |
| `notes`     | object   | Additional notes related to learning and translation (Optional). - `learning`: Additional notes related to the learning word/phrase (string). - `primary`: Additional notes related to the primary translation (string). |

#### If `translationType` is "multiple":

| Property    | Type     | Description                              |
|-------------|----------|------------------------------------------|
| `type`      | string   | The type of the collection ("folder"). (Required) |
| `learning`  | string   | The learning word or phrase. (Required)  |
| Properties for each translations of related dictionary | string | Properties for each translations of related dictionary, all of which are required. |
| `notes`     | object   | Additional notes related to learning and translations (Optional). - `learning`: Additional notes related to the learning word/phrase (string). - Properties for each translation type: Additional notes related to each translation type (string). |

### 3. Folder Object

The `_metadata.json` file is used to set the folder name on the API response and contains the following property:

| Property    | Type     | Description                              |
|-------------|----------|------------------------------------------|
| `name`      | string   | The name to be used as the folder name in the API response. (Optional, if missing, the folder name will be used.) |

## Dictionary Types Examples

### 1. Single Translation Dictionary Example

#### Folder Structure

```bash
_data/dictionaries/_single.json
_data/dictionaries/single/greetings.json
_data/dictionaries/single/unit1/numbers.json
```

**_data/dictionaries/_single.json:**

```json
{
    "version": "1.0.0",
    "name": "Basic (One Language)",
    "translationType": "single",
    "learning": "es"
}
```

**_data/dictionaries/single/greetings.json:**

```json
{
    "name": "Greetings",
    "type": "collection",
    "data": [
        {"learning":"¡Hola!", "primary":"Hello!"}
    ]
}
```

**_data/dictionaries/single/unit1/numbers.json:**

```json
{
    "type": "collection",
    "data": [
        {
            "primary": "one",
            "learning": "uno"
        },
        {
            "primary": "two",
            "learning": "dos"
        },
        {
            "primary": "three",
            "learning": "tres"
        },
        {
            "primary": "four",
            "learning": "cuatro"
        },
        {
            "primary": "five",
            "learning": "cinco"
        },
        {
            "primary": "six",
            "elearnings": "seis"
        },
        {
            "primary": "seven",
            "learning": "siete"
        },
        {
            "primary": "eight",
            "learning": "ocho"
        },
        {
            "primary": "nine",
            "learning": "nueve"
        },
        {
            "primary": "ten",
            "learning": "diez"
        }
    ]
}
```

The plugin will generate JSON API **/api/dictionaries/single.json**

```json
{"docUrl":"http://example.org/dictionaries/single","version":"1.0.0","name":"Basic (One Language)","translationType":"single","learning":"es","data":[{"name":"Greetings","type":"collection","data":[{"learning":"¡Hola!","primary":"Hello!"}]},{"type":"folder","name":"unit1","data":[{"name":"numbers","type":"collection","data":[{"primary":"one","learning":"uno"},{"primary":"two","learning":"dos"},{"primary":"three","learning":"tres"},{"primary":"four","learning":"cuatro"},{"primary":"five","learning":"cinco"},{"primary":"six","elearnings":"seis"},{"primary":"seven","learning":"siete"},{"primary":"eight","learning":"ocho"},{"primary":"nine","learning":"nueve"},{"primary":"ten","learning":"diez"}]}]}]}
```

### 2. Multiple Translations Dictionary Example

#### Folder Structure

```bash
_data/dictionaries/_multiple.json
_data/dictionaries/multiple/greetings.json
_data/dictionaries/multiple/unit1/_metadata.json
_data/dictionaries/multiple/unit1/numbers.json
```

**_data/dictionaries/_multiple.json:**

```json
{
    "version": "1.0.0",
    "name": "Basic (Multiple Languages)",
    "translationType": "multiple",
    "learning": "es",
    "translations": [
        "en", "ru", "de", "fr", "pt"
    ]
}
```

**_data/dictionaries/multiple/greetings.json:**

```json
{
    "name": "Greetings",
    "type": "collection",
    "data": [
        {"learning":"¡Hola!", "en":"Hello!", "ru":"Привет!", "de":"Hallo!", "fr":"Bonjour!", "pt":"Olá!"}
    ]
}
```

**_data/dictionaries/multiple/un1/_metadata.json:**

```json
{
    "name": "Unit 1"
}
```

**_data/dictionaries/multiple/un1/numbers.json:**

```json
{
    "type": "collection",
    "data": [
        {
            "learning": "uno",
            "en": "one",
            "ru": "один",
            "de": "eins",
            "fr": "un",
            "pt": "um"
        },
        {
            "learning": "dos",
            "en": "two",
            "ru": "два",
            "de": "zwei",
            "fr": "deux",
            "pt": "dois"
        },
        {
            "learning": "tres",
            "en": "three",
            "ru": "три",
            "de": "drei",
            "fr": "trois",
            "pt": "três"
        },
        {
            "learning": "cuatro",
            "en": "four",
            "ru": "четыре",
            "de": "vier",
            "fr": "quatre",
            "pt": "quatro"
        },
        {
            "learning": "cinco",
            "en": "five",
            "ru": "пять",
            "de": "fünf",
            "fr": "cinq",
            "pt": "cinco"
        },
        {
            "learning": "seis",
            "en": "six",
            "ru": "шесть",
            "de": "sechs",
            "fr": "six",
            "pt": "seis"
        },
        {
            "learning": "siete",
            "en": "seven",
            "ru": "семь",
            "de": "sieben",
            "fr": "sept",
            "pt": "sete"
        },
        {
            "learning": "ocho",
            "en": "eight",
            "ru": "восемь",
            "de": "acht",
            "fr": "huit",
            "pt": "oito"
        },
        {
            "learning": "nueve",
            "en": "nine",
            "ru": "девять",
            "de": "neun",
            "fr": "neuf",
            "pt": "nove"
        },
        {
            "learning": "diez",
            "en": "ten",
            "ru": "десять",
            "de": "zehn",
            "fr": "dix",
            "pt": "dez"
        }
    ]
}
```

The plugin will generate JSON API **/api/dictionaries/multiple.json**

```json
{"docUrl":"http://example.org/dictionaries/multiple","version":"1.0.0","name":"Basic (Multiple Languages)","translationType":"multiple","learning":"es","translations":["en","ru","de","fr","pt"],"data":[{"name":"Greetings","type":"collection","data":[{"learning":"¡Hola!","en":"Hello!","ru":"Привет!","de":"Hallo!","fr":"Bonjour!","pt":"Olá!"}]},{"type":"folder","name":"Unit 1","data":[{"name":"numbers","type":"collection","data":[{"learning":"uno","en":"one","ru":"один","de":"eins","fr":"un","pt":"um"},{"learning":"dos","en":"two","ru":"два","de":"zwei","fr":"deux","pt":"dois"},{"learning":"tres","en":"three","ru":"три","de":"drei","fr":"trois","pt":"três"},{"learning":"cuatro","en":"four","ru":"четыре","de":"vier","fr":"quatre","pt":"quatro"},{"learning":"cinco","en":"five","ru":"пять","de":"fünf","fr":"cinq","pt":"cinco"},{"learning":"seis","en":"six","ru":"шесть","de":"sechs","fr":"six","pt":"seis"},{"learning":"siete","en":"seven","ru":"семь","de":"sieben","fr":"sept","pt":"sete"},{"learning":"ocho","en":"eight","ru":"восемь","de":"acht","fr":"huit","pt":"oito"},{"learning":"nueve","en":"nine","ru":"девять","de":"neun","fr":"neuf","pt":"nove"},{"learning":"diez","en":"ten","ru":"десять","de":"zehn","fr":"dix","pt":"dez"}]}]}]}
```

As you can see collection `greetings` and folder `un1` have names that are defined by property `name`.

## Push New Version Commands

```bash
 gem bump
 gem build jekyll-dictionaries.gemspec
 gem push jekyll-dictionaries-*.gem
```

## License

This project is licensed under the MIT License.

# Data pipelines for LaVitrine

The artsdata-planet-lavitrine pipeline transforms data in the Artsdata data model into the LaVitrine data model.

The LaVitrine data model differs from the Artsdata data model mainly in the properties of **Event Series** and **Offer**. 

Event Series
===============
In Event Series (schema:EventSeries class), the offers, attendance mode and event status properties are moved to the sub-event (schema:subEvent property) instead of being in the Event Series.

The Artsdata data model supports this when the data is available.  However, in a majority of cases, the data is not available on the source website. When the data is not available, the Artsdata fallback is to assume that each sub-event inherits the offers, attendance mode and event status from the Event Series. 


Questions
------------

1. Should the output pipeline for LaVitrine make the assumption that if the source website only has  offers, attendance mode and event status properties in the Event Series, then it should be copied into each of the subEvents? --> **YES**
2. Should an Event with only a single date have a single sub-event added and have the offers, attendance mode and event status properties moved inside to make the model? Then the top level events could be renamed "Spectacle" and the sub-events "Représentation" like in [Référentiel des métadonnées descriptives du spectacle](https://docs.google.com/document/d/1o1wtOwpQEMOoELC2TiI3eacNYwgbJeL1yAADix4a--0/edit) ? --> **NO**

Offer
=======
In an Offer (Offer class) there are several properties, such as availablity, which are option and are often not available from the source website.

Questions
------------
1. Can availability, priceCurrency and validFrom be optional?
2. Can the url be an aggregate offer url? For example, when a **buy button** url is needed for the UI of an application, and there is no url in the offer, the Artsdata aggregate buy url for the event (class AggregateOffer) can be copied into the offer url for all offers on all dates? 

- offers
  ```
  {
    "type": "Offer",
    "availability": "InStock",
    "price": "69.00",
    "priceCurrency": "CAD",
    "url": "https://am.ticketmaster.com/grandtheatre/fr-ca/ism/TDEyMzE0MDI%3D",
    "validFrom": {
      "type": "xsd:dateTime",
      "@value": "2022-12-09T14:50:00+00:00"
    }
  }
  ```


# Grand Theatre de Québec
https://grandtheatre.qc.ca

## Input pipeline

This website is crawled by an agent on the Artsdata Huginn platform.

It also has a taxonomy [gtq-event-type-mapping.ttl](https://github.com/culturecreates/artsdata-lavitrine/blob/main/gtq-event-type-mapping.ttl) to map strings from the original website to Artsdata event types.

See https://github.com/culturecreates/artsdata-planet-gtq for details.

### Compare event images between original website and Artsdata
https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca

https://grandtheatre.qc.ca/programmation/


## Output pipeline

Realtime [5 events JSON](http://api.artsdata.ca/query.json?limit=5&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca) | [all JSON](http://api.artsdata.ca/query.json?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca) | [JSON-LD all events](http://api.artsdata.ca/query.jsonld?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca) 

[![Dump GTQ JSON to S3 Production](https://github.com/culturecreates/artsdata-lavitrine-planet/actions/workflows/dump-gtq.yml/badge.svg?event=workflow_dispatch)](https://github.com/culturecreates/artsdata-lavitrine-planet/actions/workflows/dump-gtq.yml)

Data dump [all artifacts](https://api.artsdata.ca/databus/artifact?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fhuginn%2Fgrandtheatre-qc-ca-dump) | [latest artifact](https://api.artsdata.ca/databus/artifact/latest?artifact=http%3A%2F%2Fkg.artsdata.ca%2Fdatabus%2Fculture-creates%2Fhuginn%2Fgrandtheatre-qc-ca-dump) 


# Place des Arts
https://placedesarts.com

## Input Pipeline

Footlight Console
https://console.footlight.io/events?seedurl=placedesarts-com



### Compare event images between Artsdata and website
https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com

https://placedesarts.com/fr/evenements

## Output Pipeline

Realtime [5 events JSON](http://api.artsdata.ca/query.json?limit=5&frame=event_footlight&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com) | [JSON](http://api.artsdata.ca/query.json?limit=300&frame=event_footlight&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com) | [JSON-LD](http://api.artsdata.ca/query.jsonld?limit=300&frame=event_footlight&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com) 

Note: Using frame=event_footlight


# dialog graph of websites

List of graphs http://kg.artsdata.ca/resource/dia-logGraphs

**Question**: should these be loaded indivudally or all together?

## Output Pipeline

Realtime [chasse-galerie-ca JSON](http://api.artsdata.ca/query.json?limit=5&frame=event_footlight&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/footlight/chasse-galerie-ca) 



# Website pipelines for loading into LaVitrine

Each website is loaded into Artsdata.ca and has an input pipeline and output pipline.  The input pipeline transforms the original website data into the Artsdata data model. The output pipeline transforms Artsdata data model into the LaVitrine data model.

The LaVitrine data model differs from the Artsdata data model as follows:
- offers are in the subEvents of event series
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

The Artsdata data model supports this when available, but in a majority of cases, the offer is at the EventSeries level with an aggregate buy url for all subevents.

**Question**:Should the output pipeline for LaVitrine make the assumption that if the source website only has an aggregate offer then it should be copied into each of the subEvents, along with eventStatus and attendanceMode?


# Grand Theatre de Québec
https://grandtheatre.qc.ca

## Input pipeline

This website is crawled by an agent on the Artsdata Huginn platform.

It also has a taxonomy [gtq-event-type-mapping.ttl](https://github.com/culturecreates/artsdata-lavitrine/blob/main/gtq-event-type-mapping.ttl) to map strings from the original website to Artsdata event types.

Link to Huggin 

Yes. Here is the summary of the GTQ pipeline.

Overview of [Huginn](https://huginn-staging.herokuapp.com/scenarios/26/diagram) agents
1. Crawl events listed on https://grandtheatre.qc.ca/programmation/
2. Extract JSON-LD from each webpage
3. Transform with the following SPARQLs
  'remove-blanks',
  'fix-schemaorg-https-objects',
  'fix-wikidata-uri',
  'add-artsdata-uri-using-wikidata-bridge',
  'fix-schemaorg-date-datatype',
  'create-eventseries',
  'copy-subevent-data-to-eventseries',
  'fix-isni',
  'add-artsdata-uri-using-isni-bridge',
  'collapse_duplicate_contact_point_blanknodes'
4. Load graph into Artsdata using Artsdata Databus API


### Compare event images between original website and Artsdata
https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca

https://grandtheatre.qc.ca/programmation/


## Output pipeline

Realtime [5 events JSON](http://api.artsdata.ca/query.json?limit=5&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca) | [all JSON](http://api.artsdata.ca/query.json?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca) | [JSON-LD all events](http://api.artsdata.ca/query.jsonld?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca) 

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

## Output Pipeline

Realtime [5 events JSON](http://api.artsdata.ca/query.json?limit=5&frame=event_footlight&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/resource/dia-logGraphs) 



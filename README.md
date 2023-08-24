# Website pipelines for loading into LaVitrine

Each website is loaded into Artsdata.ca and has an input pipeline and output pipline.  The input pipeline transforms the original website data into the Artsdata data model. The output pipeline transforms Artsdata data model into the LaVitrine data model.


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

Download [JSON-LD](http://api.artsdata.ca/query.jsonld?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca) or 
[JSON](http://api.artsdata.ca/query.json?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/huginn/derived-grandtheatre-qc-ca)



# Place des Arts
https://placedesarts.com

## Input Pipeline

Footlight Console
https://console.footlight.io/events?seedurl=placedesarts-com



### Compare event images between Artsdata and website
https://api.artsdata.ca/events?source=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com

https://placedesarts.com/fr/evenements

## Output Pipeline

Download [JSON-LD](http://api.artsdata.ca/query.jsonld?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com) 
or [JSON](http://api.artsdata.ca/query.json?limit=300&frame=lavitrine/events3&sparql=lavitrine/events3&graph=http://kg.artsdata.ca/culture-creates/footlight/placedesarts-com)



#!/usr/bin/env ruby

require 'sparql/client'
require 'rdf'
require 'shacl'
require 'rdf/turtle'

require 'linkeddata'
require 'json/ld'

class ArtsdataPipeline
  attr_accessor :sparql_client, :graph, :framed_json, :report, :adid
  def initialize
    @sparql_client = SPARQL::Client.new("http://db.artsdata.ca/repositories/artsdata")
    @graph = RDF::Graph.new
    @adid = []
  end

  # loads triples from a file or SPARQL endpoint
  # parameter :file - path to local file
  # parameter :sparql, :limit, :graph
  def load(**args)
    return  @graph = @graph << RDF::Graph.load(args[:file]) if args[:file]

    if args[:graph]
      sparql = File.read(args[:sparql]).gsub("graph_placeholder",args[:graph])
    else
      sparql = File.read(args[:sparql])
    end
    if args[:limit]
      previous_count = 0
      i = 0
      loop do
        sparql_str = sparql.sub("limit 10 offset 0", "limit #{args[:limit]} offset #{i * args[:limit]}")
        puts "Loading #{args[:limit]} events from offset #{i * args[:limit]}"
        result = sparql_client.query(sparql_str)
        begin
          puts "Loaded #{result.count} triples"
        rescue
          puts "Skipping events #{i * args[:limit]} to #{i * args[:limit] + args[:limit]} due to error counting results. One reason could be a schema:description starting with 'VERSION' which triggers specific behaviors."
          i += 1
          next 
        end
        add_to_graph(result)
        if @graph.count == previous_count || i > 40
          puts "Done loading."
          puts @adid.inspect
          break
        end
        
        puts "Graph has #{@graph.count} triples"
        previous_count = @graph.count
        i += 1
      end
    else
      result = sparql_client.query(sparql)
      add_to_graph(result)
    end

    # dereference Arstdata IDs
    if @adid.count > 0
      uri_list = ""
      @adid.each { |uri| uri_list += " <#{uri}> " }
      sparql = File.read("./sparql/expand_artsdata_uris.sparql").gsub("<uri_list_placeholder>", uri_list)
      result = sparql_client.query(sparql)
      add_to_graph(result)
    end

    # load additionalTypes
    sparql = File.read("./sparql/load_additional_types.sparql").gsub("graph_placeholder", args[:graph])
    result = sparql_client.query(sparql)
    add_to_graph(result)
    
  end


  def transform(sparql)
    @graph = @graph.query(SPARQL.parse(File.read(sparql), update: true))
  end

  def frame(frame_list)
    frame_list = [frame_list] unless frame_list.is_a?(Array)
    @framed_json = {"@context" => {}, "@graph" => []}
    options = {:omitGraph => false}
    frame_list.each do |frame|
      frame = JSON.parse(File.read(frame))
      input = JSON.parse(@graph.dump(:jsonld))
      framed_json = JSON::LD::API.frame(input, frame, **options)
      @framed_json["@context"] =  @framed_json["@context"].merge(framed_json["@context"])
      @framed_json["@graph"] += Array(framed_json["@graph"])
    end
    
  end

  def graph_empty?
    @graph.empty?
  end

  def dump(file)
    if @framed_json
      File.write(file, @framed_json.to_json)
    elsif @graph
      File.write(file, @graph.dump(:jsonld))
    end
  end

  def validate(*args)
    shapes_graph = RDF::Graph.new
    args.each do |filename|
      shapes_graph << RDF::Graph.load(filename)
    end
    shacl = SHACL.get_shapes(shapes_graph)
    if @framed_json
      puts "Validating framed JSON-LD..."
      @report = shacl.execute(RDF::Graph.new.from_jsonld(@framed_json.to_json))
    elsif @graph
      @report = shacl.execute(@graph)  
    end
    puts "Conforms: #{@report.conform?}"
  end

  def report_artsdata_ids(file)
    @missing_artsdata_ids = @graph.query(SPARQL.parse(File.read("./sparql/select_missing_artsdata_ids.sparql")))
    missing_list  = @missing_artsdata_ids.map { |solution| solution.uri.value}.join("\n")
    File.write(file, missing_list)
  end

  def report(file)
    File.write(file, @report)
  end

  private

  def add_to_graph(result)
    result.each_statement do |statement|
       # check if ADID and add to list for second step dereference
      @adid << statement.object.value if statement.object.uri? && statement.object.value.start_with?("http://kg.artsdata.ca/resource/") && !statement.predicate.value.include?("sameAs")
      @adid.uniq!
      @graph << statement 
    end
  end
end
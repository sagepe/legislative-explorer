# frozen_string_literal: true

require_relative '../sparql'

CountryStruct = SelfAwareStruct.new(:me, :population, :executive, :head, :office, :legislature)

module Query
  class CountryInfo
    def initialize(id:)
      @id = id
    end

    def data
      h = Sparql.new(sparql).results.first
      CountryStruct.new(*h.values_at(:country, :population, :executive, :head, :office, :legislature))
    end

    private

    attr_reader :id

    def sparql
      @sparql ||= <<~SPARQL
        SELECT ?country ?countryLabel ?population ?executive ?executiveLabel ?legislature ?legislatureLabel ?head ?headLabel ?office ?officeLabel WHERE
        {
          BIND(wd:#{id} AS ?country)
          OPTIONAL { ?country wdt:P1082 ?population }.
          OPTIONAL { ?country wdt:P194 ?legislature }.
          OPTIONAL { ?country wdt:P208 ?executive }.
          OPTIONAL { ?country wdt:P6 ?head }.
          OPTIONAL { ?country wdt:P1313 ?office }.
          SERVICE wikibase:label { bd:serviceParam wikibase:language "en". }
        }
      SPARQL
    end
  end
end

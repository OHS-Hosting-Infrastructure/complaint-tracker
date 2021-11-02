require "api_delegator"

class Grantee
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def hses_link
    links[:html]
  end

  def centers
    grants.sum(&:centers)
  end

  def complaints_per_fy
    # each grant has an object with recent fiscal years as keys and total complaint count as values
    # this method merges those objects together, adding up values for like keys to create a total count per fiscal year
    grants.map(&:complaints_per_fiscal_year).each_with_object({}) do |count, obj|
      obj.merge!(count) { |k, v1, v2| v1 + v2 }
    end.sort.reverse.to_h
  end

  def name
    attributes[:granteeName]
  end

  def region
    grants.first&.region
  end

  def complaints
    relationships[:issues][:data].map do |complaint_data|
      Complaint.new(complaint_data)
    end
  end

  def formatted_grant_ids
    grants.map(&:id).join(", ")
  end

  private

  def grants
    @grants ||= data[:attributes][:grants]
      .map { |grant| Grant.new(grant) }
  end

  def attributes
    data[:attributes]
  end

  def data
    @data ||= ApiDelegator.use("hses", "grantee", {id: id}).request.data
  end

  def links
    data[:links] || {}
  end

  def relationships
    data[:relationships] || {issues: {data: []}}
  end
end

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
    current_grant&.centers
  end

  def complaints_per_fy
    grants.map(&:complaints_per_fiscal_year).each_with_object({}) do |count, obj|
      obj.merge!(count) { |k, v1, v2| v1 + v2 }
    end.sort.reverse.to_h
  end

  def current_grant
    grants.first
  end

  def name
    attributes[:granteeName]
  end

  def region
    current_grant&.region
  end

  def complaints
    relationships[:issues][:data].map do |complaint_data|
      Complaint.new(complaint_data)
    end
  end

  private

  def grants
    @grants ||= data[:attributes][:grants]
      .map { |grant| Grant.new(grant) }
      .sort_by(&:start_date)
      .reverse
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

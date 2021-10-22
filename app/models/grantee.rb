require "api_delegator"

class Grantee
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def hses_link
    links[:html]
  end

  def centers_total
    attributes[:numberOfCenters]
  end

  def complaints_per_fy
    attributes[:totalComplaintsFiscalYear]
  end

  def name
    attributes[:name]
  end

  def region
    attributes[:region]
  end

  private

  def attributes
    grantee_data[:attributes]
  end

  def grantee_data
    @grantee_data ||= ApiDelegator.use("hses", "grantee", {id: id}).request.data
  end

  def links
    grantee_data[:links] || {}
  end
end

require "api_delegator"

class MonitoringReview
  attr_accessor :access_token, :id

  def initialize(id, access_token)
    @id = id
    @access_token = access_token
    @errors = []
  end

  def start_date
    get_api_data_field :attributes, :reviewStartDate
  end

  def valid?
    review_data.error.nil?
  end

  private

  def api
    ApiDelegator.use("monitoring", "review", id: id, access_token: access_token)
  end

  def get_api_data_field(*path)
    review_data.data.dig(*path)
  end

  def review_data
    @review_data ||= api.request
  end
end
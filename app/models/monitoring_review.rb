require "api_delegator"

class MonitoringReview
  include ActiveModel::Validations

  attr_accessor :access_token, :id

  def initialize(id, access_token)
    @id = id
    @access_token = access_token
  end

  def start_date
    get_api_data_field :attributes, :reviewStartDate
  end

  private

  def api
    ApiDelegator.use("monitoring", "review", id: id, access_token: access_token)
  end

  # TODO maybe abstract this out
  def get_api_data_field(*path)
    if valid?
      review_data.data.dig(*path)
    else
      # TODO override this if using custom monitoring error messages
      fail Api::Error.new(review_data.code, review_data.body)
    end
  end

  def review_data
    @review_data ||= api.request
  end
end

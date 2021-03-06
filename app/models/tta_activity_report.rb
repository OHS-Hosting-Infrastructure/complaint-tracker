require "api_delegator"

class TtaActivityReport
  include ActiveModel::Validations
  validate :check_display_id_format
  validate :api_call_succeeded

  attr_accessor :access_token, :display_id

  def initialize(display_id, access_token)
    @display_id = display_id
    @access_token = access_token
  end

  def id
    get_api_data_field :id
  end

  def start_date
    get_api_data_field :attributes, :startDate
  end

  def ttahub_url
    get_api_data_field :links, :html
  end

  def topics
    get_api_data_field :attributes, :topics
  end

  def author_name
    get_api_data_field :attributes, :author, :name
  end

  def api_error_message
    errors.full_messages.join(" ") unless valid?
  end

  private

  def api_call_succeeded
    return unless errors.blank?
    errors.add(:base, tta_link_error_message) if activity_data.failed?
  end

  def get_api_data_field(*path)
    if valid?
      activity_data.data.dig(*path)
    else
      fail Api::ErrorTta.new(activity_data.code, activity_data.body)
    end
  end

  def activity_data
    @activity_data ||= api.request
  end

  def api
    ApiDelegator.use("tta", "activity_report", display_id: display_id, access_token: access_token)
  end

  def check_display_id_format
    # TODO: There are legacy display IDs in the system that may have a different format.
    # If a user is attemping to use a legacy display ID, this may not work. Please update to ensure all
    # possible display IDs will pass through correctly. (And/or fix on TTAHub Api side.)
    unless display_id.match?(/^R\d{2}-AR-/)
      errors.add(:base, "This doesn't look like a TTA Activity Report Display ID. Please double check the format.")
    end
  end

  def tta_link_error_message
    case activity_data.code
    when 403
      "You do not have permission to access this activity report."
    when 404
      "This number doesn't match any existing activity reports. Please double-check the number."
    else
      "We're unable to look up reports in TTA Smart Hub right now. Please try again later."
    end
  end
end

require "ffaker"

module FfakerWrapper
  STATUS = {
    0 => "Open",
    1 => "Closed",
    2 => "Recommended for closure",
    3 => "Recommended to be reopened",
    4 => "Reopened"
  }

  ISSUE_TYPE = {
    1 => "Complaint",
    8 => "COVID-19 Concern"
  }

  PRIORITY = {
    0 => "Urgent",
    1 => "Routine",
    2 => "FYI"
  }

  REGARDING = [
    "Grantee",
    "State",
    "Region",
    "DRS"
  ]

  def date
    FFaker::Time.between(1.month.ago, 1.month.after).to_date
  end

  def date_string
    date.strftime("%F")
  end

  def datetime
    FFaker::Time.between(1.month.ago, 1.month.after).to_datetime
  end

  def datetime_string
    # format UTC date YYYY-MM-DDTHH:MM:SSZ
    datetime.strftime("%FT%TZ")
  end

  def grantee_name
    # these just sound cool for use as the grantee name :)
    FFaker::AddressUK.street_name
  end

  def grant_number
    # Note: actual grant numbers appear like 04CH011504
    random_int(99999).to_s
  end

  # returns a string because actual identifiers may not be integers
  def identifier
    random_int(9999).to_s
  end

  def issue_type_object
    id = ISSUE_TYPE.keys.sample
    {
      id: id,
      label: ISSUE_TYPE[id]
    }
  end

  def phrase
    FFaker::Lorem.phrase
  end

  def priority_object
    id = random_int(2)
    {
      id: id,
      label: PRIORITY[id]
    }
  end

  def random_int(range = 3)
    FFaker::Random.rand(range)
  end

  def regarding
    REGARDING.sample
  end

  def status_object
    id = random_int(4)
    {
      id: id,
      label: STATUS[id]
    }
  end
end

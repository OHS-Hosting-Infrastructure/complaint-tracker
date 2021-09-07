require "ffaker"

module FfakerWrapper
  def date_string
    date.strftime("%F")
  end

  def date
    FFaker::Time.between(1.month.ago, 1.month.after).to_date
  end

  def datetime_string
    # format UTC date YYYY-MM-DDTHH:MM:SSZ
    datetime.strftime("%FT%TZ")
  end

  def datetime
    FFaker::Time.between(1.month.ago, 1.month.after).to_datetime
  end

  def grantee_name
    # these just sound cool for use as the grantee name :)
    FFaker::AddressUK.street_name
  end

  # returns a string because actual identifiers may not be integers
  def identifier
    random_int(9999).to_s
  end

  def phrase
    FFaker::Lorem.phrase
  end

  def random_int(range = 3)
    FFaker::Random.rand(range)
  end

  def word
    FFaker::Lorem.word
  end
end

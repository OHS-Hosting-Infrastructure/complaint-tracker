require "ffaker"

module FfakerWrapper
  def date
    FFaker::Time.date
  end

  def datetime_string
    # format UTC date YYYY-MM-DDTHH:MM:SSZ
    datetime.strftime("%FT%TZ")
  end

  def datetime
    FFaker::Time.datetime
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

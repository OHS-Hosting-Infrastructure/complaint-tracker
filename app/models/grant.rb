class Grant
  attr_accessor :id

  def initialize(data)
    @id = data[:id]
    @attributes = data[:attributes]
  end

  def centers
    @attributes[:numberOfCenters]
  end

  def complaints_per_fiscal_year
    # {
    #   2022: 4,
    #   2021: 3
    # }
    @attributes[:totalComplaintsFiscalYear].each_with_object({}) do |count, obj|
      obj[count[:fiscalYear]] = count[:totalComplaints]
    end
  end

  def region
    @attributes[:region]
  end

  def start_date
    @attributes[:grantProgramStartDate]
  end
end

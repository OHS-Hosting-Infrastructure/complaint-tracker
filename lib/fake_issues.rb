class FakeIssues
  include Singleton

  def data
    @data ||= 25.times.map { |index|
      Api::FakeData::Complaint.new.data.tap do |complaint|
        complaint[:id] = (1500 + index).to_s
      end.with_indifferent_access
    }
  end
end

class IssueMonitoringReviewsController < ApplicationController
  include NeedsHsesAccessToken

  def create
    @issue_monitoring_review = IssueMonitoringReview.new(
      issue_id: issue_id,
      review_id: review_id,
      access_token: hses_access_token
    )

    respond_to do |format|
      if @issue_monitoring_review.save
        format.js { render inline: "location.reload(true);" }
      else
        format.js { render inline: "alert('there was an error linking to a RAN review');" }
        # TODO implement when working on error handling
        # format.js { render "create_errors" }
      end
    end
  end

  private

  def issue_id
    params[:issue_id_monitoring]
  end

  def review_id
    params[:monitoring_review_id]
  end
end

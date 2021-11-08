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

  def destroy
    review_link = IssueMonitoringReview.find_by(
      issue_id: issue_id,
      review_id: review_id
    )
    review_link.destroy!
    redirect_back fallback_location: complaint_path(issue_id)
  end

  def update
    @issue_monitoring_review = IssueMonitoringReview.find(params[:id])

    respond_to do |format|
      if @issue_monitoring_review.update(review_id: review_id, access_token: hses_access_token)
        format.js { render inline: "location.reload(true);" }
      else
        format.js { render inline: "alert('there was an error changing the id of the RAN review');" }
        # format.js { render "update_errors" }
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

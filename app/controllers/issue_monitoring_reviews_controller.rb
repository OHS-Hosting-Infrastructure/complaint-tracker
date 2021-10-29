class IssueMonitoringReviewsController < ApplicationController
  include NeedsHsesAccessToken

  def create
    @issue_monitoring_report = IssueMonitoringReview.new(
      issue_id: issue_id,
      review_id: review_id,
      access_token: hses_access_token
    )

    respond_to do |format|
      if @issue_monitoring_report.save
        format.js { render inline: "location.reload(true);" }
      else
        Rails.logger.error("Problem saving the link to RAN review: " + @issue_monitoring_report.errors.full_messages.join("; "))
        # TODO implement when working on error handling
        # format.js { render "create_errors" }
      end
    end
  end

  private

  def issue_id
    params[:issue_id]
  end

  def review_id
    params[:monitoring_review_id]
  end
end

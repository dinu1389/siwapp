class ReportsController < ApplicationController

	# GET /items/amount
  #
  # Calculates the net amount for an item
  def new
    @report = Report.new(template_id: params[:template_id])
  end
end

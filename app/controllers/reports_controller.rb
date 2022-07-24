class ReportsController < ApplicationController

	# GET /items/amount
  #
  # Calculates the net amount for an item
  def new
    @template= Template.find_by(id: params[:template_id])
    @report = Report.new(template_id: params[:template_id])
    @item = 'hello Dinu'
    html = render_to_string :inline =>  @template.html_string,
      :locals => {:item => @item}


    file = Htmltoword::Document.create_and_save html, 'inv.docx'
  end
end

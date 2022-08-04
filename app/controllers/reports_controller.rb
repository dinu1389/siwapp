class ReportsController < ApplicationController

	# GET /items/amount
  #
  # Calculates the net amount for an item
  def new
    @template= Template.find_by(id: params[:template_id])
    @report = Report.new(template_id: params[:template_id])
    # @item = 'hello Dinu'
    # html = render_to_string :inline =>  @template.html_string,
    #   :locals => {:item => @item}


    #file = Htmltoword::Document.create_and_save html, 'inv.docx'
  end

  def create
    @report = Report.new(report_params)
    @report.save!
    validate_variables
    redirect_to edit_report_path(@report)
    #render 'edit', locals: { @report: @report }
  end

  def edit
    @report = Report.find_by(id: params[:id])
  end

  def index
    @reports = Report.all.order(updated_at: :desc)
  end

  def generatedocx
    @report = Report.find_by(id: params[:@report][:report_id])
    template = @report.template
    file = @report.data_files.first
    url = ActiveStorage::Blob.service.send(:path_for, file.key)
    @csv_data = CSV.open(url, headers: true).read
    row = @csv_data[0] 
    row_hash = row.to_hash
    row_hash =  HashWithIndifferentAccess.new(row_hash)
    name = File.basename(file.filename.to_s, File.extname(file.filename.to_s)).downcase
    instance_variable_set("@#{name}", row_hash)
    locals_hash = {}
    locals_hash["@#{name}"] = row_hash
    locals_hash =  HashWithIndifferentAccess.new(locals_hash)
    #locals_hash = {:ae => row_hash, :item => @item}
    html = render_to_string :inline =>  template.html_string, :locals => locals_hash
   #html = render_to_string :inline =>  template.html_string, :locals => {:@ae => row_hash}
    file = Htmltoword::Document.create_and_save html, 'result.docx'
  end

  private

  def report_params
    params.require(:report).permit(:template_id, data_files: [])
  end


  def validate_variables
    if @report.data_files.attached?
      @report.data_files.each do |file|
        # #@csv_data = CSV.open(file.download, headers: true).read
        # @csv_data = CSV.open(file.download, &:readline)
        # @csv_data = CSV.open(file.download, headers: true).read
        # url = rails_blob_path(file, disposition: "attachment")
        # byebug
        
        # url = ActiveStorage::Blob.service.send(:path_for, file.key)
        # @csv_data = CSV.open(url, headers: true).read
      end
    end
  end
end

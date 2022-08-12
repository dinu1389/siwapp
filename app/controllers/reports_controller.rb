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

  def generatedocx_backup
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
    # zip_file(file)
    @report.result_file.attach(io: File.open("#{Rails.root}/result.docx"), filename: 'result.docx')

    redirect_to edit_report_path(@report)
  end

  def generatedocx_2
    @report = Report.find_by(id: params[:@report][:report_id])
    template = @report.template
    target_path = "#{Rails.root}/tmp/#{@report.id}"
    FileUtils.rm_rf(target_path) if File.exist?(target_path)
    if @report.data_files.attached?
      @report.data_files.each do |file|
        url = ActiveStorage::Blob.service.send(:path_for, file.key)
        @csv_data = CSV.open(url, headers: true).read
        @csv_data.each do |row|
          row_hash = row.to_hash
          row_hash =  HashWithIndifferentAccess.new(row_hash)
          name = File.basename(file.filename.to_s, File.extname(file.filename.to_s)).downcase
          instance_variable_set("@#{name}", row_hash)
          locals_hash = {}
          locals_hash["@#{name}"] = row_hash
          locals_hash =  HashWithIndifferentAccess.new(locals_hash)
          html = render_to_string :inline =>  template.html_string, :locals => locals_hash
          final_file = "#{@report.id}-#{row_hash[:USUBJID]}.docx"
          
          
          File.delete(final_file) if File.exist?(final_file)
          

          docx_file = Htmltoword::Document.create_and_save html, final_file
          FileUtils.mkdir_p "#{target_path}"
          if File.exists?(target_path)
            FileUtils.mv(docx_file, target_path)
          end

        end
      end
      zip_output_path = "#{target_path}/#{@report.id}.zip"
      zf = ZipFileGenerator.new(target_path, zip_output_path)
      zf.write()
      @report.output_file.attach(io: File.open(zip_output_path), filename: "#{@report.id}.zip")
      # File.delete(final_file) if File.exist?(final_file)
      FileUtils.rm_rf(target_path) if File.exist?(target_path)
    end
    redirect_to edit_report_path(@report)
  end

  def generatedocx
    @report = Report.find_by(id: params[:@report][:report_id])
    template = @report.template
    target_path = "#{Rails.root}/tmp/#{@report.id}"
    FileUtils.rm_rf(target_path) if File.exist?(target_path)
    if @report.data_files.attached?
      @report.data_files.each do |file|
        name = File.basename(file.filename.to_s, File.extname(file.filename.to_s)).downcase
        url = ActiveStorage::Blob.service.send(:path_for, file.key)
        if name == 'dm'
          @csv_data = CSV.open(url, headers: true).read
          @csv_data.each do |row|
            start_obj = VarObject.new(row, row.headers)
            #instance_variable_set("@#{name}", tmp)

            locals_hash = {}
            locals_hash["#{name}"] = start_obj
            locals_hash =  HashWithIndifferentAccess.new(locals_hash)
            # {:dm => tmp}
            html = render_to_string :inline =>  template.html_string, :locals => locals_hash

            final_file = "#{@report.id}-#{start_obj.USUBJID}.docx"
          
          
            File.delete(final_file) if File.exist?(final_file)
            
  
            docx_file = Htmltoword::Document.create_and_save html, final_file
            FileUtils.mkdir_p "#{target_path}"
            if File.exists?(target_path)
              FileUtils.mv(docx_file, target_path)
            end
            # MHs.each do |obj|
            #   obj[MH.SUBID]
            # end
          end
        end
      end
    end
    zip_files(target_path)
    redirect_to edit_report_path(@report)
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

  # def locals_hash name, value
  #   locals_hash = {}
  #   locals_hash["@#{name}"] = value
  #   locals_hash =  HashWithIndifferentAccess.new(locals_hash)
  # end

  def zip_files target_path
    zip_output_path = "#{target_path}/#{@report.id}.zip"
    zf = ZipFileGenerator.new(target_path, zip_output_path)
    zf.write()
    @report.output_file.attach(io: File.open(zip_output_path), filename: "#{@report.id}.zip")
    # File.delete(final_file) if File.exist?(final_file)
    FileUtils.rm_rf(target_path) if File.exist?(target_path)
  end
  # def zip_file file
  #   # Zip::OutputStream.write_buffer do |stream|
  #   #   # add pdf to zip
  #   #   stream.write IO.read(file) 
  #   # end
  #   # zfpath = Rails.root.join('tmp', "somename-#{SecureRandom.hex(8)}.zip")
  #   # Zip::ZipFile.open(zfpath, Zip::ZipFile::CREATE) do |zipfile|
     
  #   #   zipfile.add(file)
  #   # end
  #   # Zip::File.open("my.zip", create: true) {
  #   # |zipfile|
  #   #   zipfile.get_output_stream(file)
  #   #   zipfile.mkdir("a_dir")
  #   # }
  # end
end

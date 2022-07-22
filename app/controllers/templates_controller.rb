class TemplatesController < ApplicationController
  before_action :set_type
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  # GET /templates
  # GET /templates.json
  def index
    @templates = Template.all
  end

  # GET /templates/1
  # GET /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # GET /templates/1/edit
  def edit
  end

  def about
    # ApplicationController.new.render_to_string
    # html_safe
    # https://stackoverflow.com/questions/41306355/how-to-replace-the-characters-in-a-string
    # html = render_to_string :inline => temp, :locals => {:item => @item}
    @template = Template.find_by(name: 'test')
    val = @template&.template
    replacements = { '{{' => '<%=', '}}' => '%>' }
    val2 = val.gsub(Regexp.union(replacements.keys), replacements) if val.present?
    html = ApplicationController.new.render_to_string :inline => val2, :locals => {:item => @item} if val2.present?
  end

  def update_template
    params[:content][:uniqueID][:value]
    Template.where(name: 'test').destroy_all
    @template = Template.create(name: 'test', template: params[:content][:uniqueID][:value], content: params[:content])
  end

  # POST /templates
  # POST /templates.json
  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to templates_url, notice: 'Template was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # POST /templates
  # updates default template
  def set_default
    # Email Template
    Template.where(id: params["email_default_template"]).update_all(email_default: true)
    Template.where.not(id: params["email_default_template"]).update_all(email_default: false)
    # PDF Template
    Template.where(id: params["print_default_template"]).update_all(print_default: true)
    Template.where.not(id: params["print_default_template"]).update_all(print_default: false)

    redirect_to templates_url
  end

  # PATCH/PUT /templates/1
  # PATCH/PUT /templates/1.json
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to templates_url, notice: 'Template was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /templates/1
  # DELETE /templates/1.json
  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to templates_url, notice: 'Template was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template
      @template = Template.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def template_params
      params.require(:template).permit(:name, :template, :subject)
    end
end

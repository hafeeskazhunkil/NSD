class UploadsController < ApplicationController
  before_filter :authenticate, :except => [:new, :create, :status]
  caches_page :new
  protect_from_forgery :except => :create # I use page caching and that breaks it. Also I don't need to worry about forgeries here.
  
  def status
    @upload = Upload.find(params[:id])
  end
  
  def download
    @upload = Upload.find(params[:id])
    send_file(@upload.filename_full_path, :type => @upload.content_type, :filename => @upload.original_filename)
  end
  
  # GET /uploads
  # GET /uploads.xml
  def index
    @uploads = Upload.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @uploads }
    end
  end

  # GET /uploads/1
  # GET /uploads/1.xml
  def show
    @upload = Upload.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @upload }
    end
  end

  # GET /uploads/new
  # GET /uploads/new.xml
  def new
    @title = "Upload a file for our sign &amp; design company in Chicago"
    @upload = Upload.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @upload }
    end
  end

  # GET /uploads/1/edit
  def edit
    @upload = Upload.find(params[:id])
  end

  # POST /uploads
  # POST /uploads.xml
  def create
    @upload = Upload.new(params[:upload])

    respond_to do |format|
      if @upload.save
        flash[:notice] = 'Upload was successfully created.'
        format.html { redirect_to(status_upload_url(@upload)) }
        format.xml  { render :xml => @upload, :status => :created, :location => @upload }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @upload.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /uploads/1
  # PUT /uploads/1.xml
  def update
    @upload = Upload.find(params[:id])

    respond_to do |format|
      if @upload.update_attributes(params[:upload])
        flash[:notice] = 'Upload was successfully updated.'
        format.html { redirect_to(@upload) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @upload.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.xml
  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy

    respond_to do |format|
      format.html { redirect_to(uploads_url) }
      format.xml  { head :ok }
    end
  end
end

class CodersController < ApplicationController
  
  #before_filter :load_locations, :only => [:index, :filter_by_cities]
  
  # GET /coders
  # GET /coders.xml
  def index
    @coders = Coder.search(
      (params[:search] || ""),
      :page => (params[:page] || 1),
      :order => :rank
    )
    
    @count = ThinkingSphinx::Search.count(params[:search])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @coders }
    end
  end

  # GET /coders/1
  # GET /coders/1.xml
  def show
    @coder = Coder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @coder }
    end
  end

  # GET /coders/new
  # GET /coders/new.xml
  def new
    @coder = Coder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @coder }
    end
  end

  # GET /coders/1/edit
  def edit
    @coder = Coder.find(params[:id])
  end

  # POST /coders
  # POST /coders.xml
  def create
    @coder = Coder.new(params[:coder])

    respond_to do |format|
      if @coder.save
        flash[:notice] = 'Coder was successfully created.'
        format.html { redirect_to(@coder) }
        format.xml  { render :xml => @coder, :status => :created, :location => @coder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @coder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /coders/1
  # PUT /coders/1.xml
  def update
    @coder = Coder.find(params[:id])

    respond_to do |format|
      if @coder.update_attributes(params[:coder])
        flash[:notice] = 'Coder was successfully updated.'
        format.html { redirect_to(@coder) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @coder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /coders/1
  # DELETE /coders/1.xml
  def destroy
    @coder = Coder.find(params[:id])
    @coder.destroy

    respond_to do |format|
      format.html { redirect_to(coders_url) }
      format.xml  { head :ok }
    end
  end
  
  def filter_by_cities
    
    @coders = Coder.find(:all,:conditions => ["city like ?","#{params[:locations]}%"],:order => :rank)   
    render :action => "index"
  end
  
  private
  
  def load_locations
    @locations = Coder.find(:all, :select => "city",:conditions => "city is not null",:order => "city")
    @locations = @locations.collect {|coder| [coder.city,coder.city]}
    [@locations.uniq!]
  end
end
